request = require('request-promise-native')
import { JSDOM } from 'jsdom'

import {downloadLimited} from '../lib/download'
import logger from '../log'

import EjudgeSubmitDownloader from './ejudge/EjudgeSubmitDownloader'

import TestSystem, {TestSystemUser} from './TestSystem'

import RegisteredUser from '../models/registeredUser'
import Problem from '../models/problem'
import Submit from '../models/submit'

import * as downloadSubmits from '../cron/downloadSubmits'


REQUESTS_LIMIT = 20


userCache = {}

class LoggedEjudgeUser
    @getUser: (server, contestId, username, password, isAdmin) ->
        key = "#{server}::#{contestId}::#{username}::#{password}"
        if not userCache[key] or (new Date() - userCache[key].loginTime > 1000 * 60 * 60)
            logger.info "Creating new EjudgeUser ", username, contestId
            newUser = new LoggedEjudgeUser(server, contestId, username, password, isAdmin)
            await newUser._login()
            userCache[key] =
                user: newUser
                loginTime: new Date()
        return userCache[key].user

    constructor: (@server, @contestId, @username, @password, @isAdmin) ->
        @jar = request.jar()
        @requests = 0
        @promises = []
        @sid = {}

    _login: () ->
        await @_loginToProg("new-client")
        if @isAdmin
            await @_loginToProg("new-master")
            await @_loginToProg("serve-control")
        logger.info "Logged in user #{@username}, sid=#{@sid}"

    _loginToProg: (prog) ->
        page = await downloadLimited("#{@server}/cgi-bin/#{prog}", @jar, {
            method: 'POST',
            form: {
                login: @username,
                password: @password,
                contest_id: @contestId
            },
            followAllRedirects: true,
            timeout: 30 * 1000
        })
        if not page.includes("Logout")
            throw "Can't log user #{@username} in"
        sidString = page.match(/SID=([0-9a-f]+)/)
        logger.info "Logger to prog #{prog}, SID=#{sidString[1]}"
        @sid[prog] = sidString[1]

    download: (href, options, prog="new-client") ->
        if @sid[prog]
            if options and ("form" of options)
                options.form.SID = @sid[prog]
            else
                if not href.includes('?')
                    href = href + "?"
                href = href + "&SID=#{@sid[prog]}"
        result = await downloadLimited(href, @jar, options)
        return result

    submit: (problemId, contentType, body) ->
        [_, boundary] = contentType.match(/boundary=(.*)/)
        boundary = "--" + boundary
        body = body.toString()
        body = """
            #{boundary}\r
            Content-Disposition: form-data; name="SID"\r
            \r
            #{@sid["new-client"]}\r
            #{boundary}\r
            Content-Disposition: form-data; name="prob_id"\r
            \r
            #{problemId}\r
            #{boundary}\r
            Content-Disposition: form-data; name="action_40"\r
            \r
            Send!\r
            #{body}
        """
        href = "#{@server}/cgi-bin/new-client"
        page = await downloadLimited(href, @jar, {
            method: 'POST',
            headers: {'Content-Type': contentType},
            body,
            followAllRedirects: true
        })
        document = (new JSDOM(page, {url: href})).window.document
        el = document.getElementsByTagName("title")
        result = el[0].textContent
        if result.includes("Error")
            throw {ejudgeError: result}


export default class Ejudge extends TestSystem
    constructor: (@server, @baseContest) ->
        super()

    id: () ->
        return "ejudge"

    getAdmin: (contestId) ->
        admin = await RegisteredUser.findAdmin()
        return LoggedEjudgeUser.getUser(@server, contestId, admin.ejudgeUsername, admin.ejudgePassword, true)

    registerUser: (user, registeredUser, password) ->
        adminUser = await @getAdmin(@baseContest)

        registeredUser.ejudgePassword = password

        href = "#{@server}/cgi-bin/serve-control"
        form =
            SID: adminUser.sid["serve-control"]
            contest_id: @baseContest
            group_id: ""
            other_login: registeredUser.ejudgeUsername
            other_email: ""
            reg_password1: registeredUser.ejudgePassword
            reg_password2: registeredUser.ejudgePassword
            reg_random: ""
            field_9: 1
            reg_cnts_create: 1
            other_contest_id_1: @baseContest
            other_contest_id_2: @baseContest
            cnts_status: 0
            cnts_password1: ""
            cnts_password2: ""
            cnts_random: ""
            cnts_name: ""
            other_group_id: ""
            action_73: "Create a user"

        res = await adminUser.download(href, {
            method: 'POST',
            headers: {'Content-Type': "application/x-www-form-urlencoded"},
            form: form,
            followAllRedirects: true
        }, "serve-control")

    parseProblem: (admin, problemHref) ->
        page = await admin.download(problemHref)
        document = (new JSDOM(page, {url: problemHref})).window.document
        scoreEl = document.getElementsByClassName("line-table-wb")[0]?.getElementsByTagName("tt")[0]?.textContent
        if isNaN(scoreEl)
            throw "Can not find score for problem #{problemHref}"
        el = document.getElementById("probNavTaskArea-ins")
        for tag in ["h2", "form"]
            subels = el.getElementsByTagName(tag)
            for subel in subels
                subel.parentElement.removeChild(subel)
        headers = el.getElementsByTagName("h3")
        submitHeader = headers[headers.length - 1]
        submitHeader.parentElement.removeChild(submitHeader)
        header = headers[0]
        return {
            name: header.innerHTML
            text: el.innerHTML
            points: +scoreEl
        }

    downloadContestProblems: (contestId) ->
        admin = await @getAdmin(contestId)
        href = "#{@server}/cgi-bin/new-client"
        page = await admin.download(href)
        document = (new JSDOM(page, {url: href})).window.document
        tab = document.getElementById("probNavTopList")
        problemElements = tab.getElementsByClassName("tab")
        result = []
        for el in problemElements
            probHref = el.href
            [_, id] = el.href.match(/prob_id=(.*)(&|$)/)
            problem = await @parseProblem(admin, probHref)
            problem._id = "#{contestId}_#{id}"
            problem.letter = id
            result.push(problem)
            logger.info "Found problem ", problem
        return result

    submitDownloader: (userId, userList, problemId, submitsPerPage) ->
        problems = []
        if problemId
            problems = [await Problem.findById(problemId)]
        else
            problems = await Problem.find({})
        tables = []
        for problem in problems
            for table in problem.tables
                if not (table in tables)
                    tables.push(table)

        parameters = await Promise.all(tables.map((table) =>
            admin: await @getAdmin(table)
            server: @server
            table: table
        ))

        return new EjudgeSubmitDownloader(parameters)

    setOutcome: (submitId, outcome, comment) ->
        [fullMatch, contest, run, problem] = submitId.match(/(.+)r(.+)p(.+)/)
        adminUser = await @getAdmin(contest)
        outcomeCode = switch outcome
            when "AC" then 0
            when "IG" then 9
            when "DQ" then 10
            else undefined
            
        try
            if outcomeCode?
                href = "#{@server}/cgi-bin/new-master"
                options = 
                    method: "POST"
                    headers: {'Content-Type': "application/x-www-form-urlencoded; charset=UTF-8"}
                    form: 
                        action: 67
                        run_id: run
                        status: outcomeCode
                    followAllRedirects: true
                await adminUser.download href, options, "new-master"
        finally
            if comment
                href = "#{@server}/cgi-bin/new-master"
                options = 
                    method: "POST"
                    headers: {'Content-Type': "application/x-www-form-urlencoded; charset=UTF-8"}
                    form: 
                        action_64: "Send run comment"
                        run_id: run
                        msg_text: comment
                    followAllRedirects: true
                await adminUser.download href, options, "new-master"
        logger.info "Successfully set outcome for #{submitId}"

    submitWithFormData: (user, problemId, contentType, data) ->
        [contest, problem] = problemId.split("_")
        try
            oldSubmits = await Submit.findByUserAndProblem(user.userKey(), problemId)
            try
                ejudgeUser = await LoggedEjudgeUser.getUser(@server, contest, user.ejudgeUsername, user.ejudgePassword, false)
                ejudgeData = await ejudgeUser.submit(problem, contentType, data)
            finally
                await downloadSubmits.runForUser(user.userKey(), 5, 1)
        catch e
            logger.error "Can not submit", e
            newSubmits = await Submit.findByUserAndProblem(user.userKey(), problemId)
            if oldSubmits.length == newSubmits.length
                throw e
            logger.error "Though the submit appeared in submit list..."