React = require('react')
deepEqual = require('deep-equal')
import { connect } from 'react-redux'
import { CometSpinLoader } from 'react-css-loaders';

import * as actions from '../redux/actions'
import * as getters from '../redux/getters'

export default ConnectedComponent = (Component, options) ->
    class Result extends React.Component
        constructor: (props) ->
            super(props)
            @handleReload = @handleReload.bind(this)

        urls: () ->
            options.urls(@props)

        dataLoaded: () ->
            for key, url of @urls()
                if not @props.hasData(url)
                    return false
            return true

        render:  () ->
            if not @dataLoaded() and not options.allowNotLoaded
                if options.Placeholder
                    Placeholder = options.Placeholder
                    return <Placeholder/>
                else
                    return <CometSpinLoader/>
            else
                componentProps = {@props...}
                componentProps.handleReload = @handleReload
                delete componentProps.data
                delete componentProps.hasData
                delete componentProps.getData
                delete componentProps.saveDataPromises
                delete componentProps.dispatch
                for key, url of @urls()
                    componentProps[key] = @props.data(url)
                return `<Component  {...componentProps}/>`

        componentWillMount: ->
            if not window?
                promises = @requestData()
                @props.saveDataPromises(promises)

        componentDidMount: ->
            @requestDataAndSetTimeout()

        componentWillUnmount: ->
            if @timeout
                console.log "Clearing timeout"
                clearTimeout(@timeout)

        componentDidUpdate: (prevProps, prevState) ->
            if not deepEqual(options.urls(prevProps), options.urls(@props))
                @requestData()

        requestData: () ->
            promises = (@props.getData(url, true) for key, url of @urls())
            return promises

        handleReload: () ->
            @requestData()

        requestDataAndSetTimeout: () ->
            try
                await Promise.all(@requestData())
                console.log "Updated data", @urls()
            catch e
                console.log "Can't reload data", @urls(), e
            if options.timeout
                console.log "Setting timeout", @urls()
                @timeout = setTimeout((() => @requestDataAndSetTimeout()), options.timeout)

    mapStateToProps = (state, ownProps) ->
        return
            data: (url) -> getters.getData(state, url)
            hasData: (url) -> getters.hasData(state, url)

    mapDispatchToProps = (dispatch, ownProps) ->
        return
            getData: (url, force) -> dispatch(actions.getData(url, force))
            saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))
            dispatch: dispatch

    return connect(mapStateToProps, mapDispatchToProps)(Result)
