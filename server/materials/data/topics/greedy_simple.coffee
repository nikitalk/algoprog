import contest from "../../lib/contest"
import label from "../../lib/label"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

module25226 = () ->
    page("Про жадные алгоритмы", String.raw"""
        <div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>"Жадные" алгоритмы</h2>
        <p>Жадные алгоритмы — это алгоритмы, которые, на каждом шагу принимают локально оптимальное решение, не заботясь о том, что будет дальше. Они не всегда верны, но есть задачи, где жадные алгоритмы работают правильно.</p>
        
        <p>Пример жадного алгоритма следующий. Вспомните <a href="/material/p915" onclick="window.goto('/material/p915')();return false;">задачу "Платная лестница"</a> из контеста на ДП. Правильное решение в этой задаче — это именно динамика, но в этой задаче можно также придумать и следующее жадное решение (правда, неправильное). На каждом шагу у нас есть два варианта — подняться на следующую ступеньку или перепрыгнуть через ступеньку. Вот посмотрим, какой из этих двух вариантов дешевле, т.е. на какой из этих ступенек меньше цена, и сделаем такой шаг.</p>
        
        <p>Конечно, это решение неправильное, вот пример. Если на ступеньках написаны следующие числа:</p>
        <pre>1 2 10 2
        </pre>
        <p>то жадный алгоритм увидит, что изначально у него есть два варианта: сходить на ступеньку с числом 1 или с числом 2 — и пойдет на ступеньку с числом 1, т.к. это дешевле. Но правильное решение здесь — пойти на ступеньку с числом 2, т.к. потом мы сможешь перепрыгнуть ступеньку с числом 10.</p>
        
        <p>Этот пример четко показывает, почему жадные алгоритмы обычно не работают. Они не учитывают далекие последствия своих действий, они делают выбор, который оптимален только с учетом ближайших перспектив.</p>
        
        <p>(Сразу отмечу, что нередко жадные алгоритмы хочется применить в задачах на ДП. Да, многие задачи на жадность и на ДП похожи, просто в жадном алгоритме вы доказываете, что вариантов рассматривать не надо, а в ДП вы их честно рассматриваете. Поэтому если жадность не работает, то подумайте, не получится ли тут придумать ДП. Но на самом деле есть и много задач на жадность, где ДП не особенно придумаешь, и много задач на жадность, которые вообще не похожи на ДП.)</p>
        
        <p>Но бывают задачи, в которых жадность все-таки работает, в которых можно <i>доказать</i>, что жадный алгоритм корректен. На самом деле, в наиболее простых задачах корректность жадности очевидна (и на этом уровне у вас в основном будут именно задачи такого типа, более продвинутые будут на уровне 6Б), еще в некоторых задачах корректность жадности может быть не очевидна (или даже может быть несколько разных жадных алгоритмов, которые можно придумать, и непонятно, какой из них правильный), но вы можете написать жадность, отправить на проверку (если это возможно на конкретной олимпиаде) и сразу узнать, корректна она или нет. Наконец, даже если жадность некорректна, она нередко работает в простых случаях, поэтому жадные алгоритмы нередко неплохо подходят на роль частичных решений.</p>
        
        <h3>Как доказывать жадность?</h3>
        
        <p>Как обычно доказывают жадные алгоритмы? На самом деле, на текущем уровне вам не обязательно научиться их доказывать, но если поймете, что написано ниже, то будет хорошо.</p>
        
        <p>Есть два подхода к доказательству задач на жадность. Первый вариант более общий. Он может быть применен в тех задачах, где вам надо сделать несколько последовательных шагов, несколько последовательных выборов. (В примере задачи про платную лестницу выше — вы именно делаете несколько последовательных выборов "на какую ступеньку сходить".) Вам надо доказать, что если вы сделаете локально оптимальный выбор, то он не отменит возможность придти к глобально оптимальному решению. Обычно доказательство идет так: возьмем решение, построенное жадным алгоритмом, возьмем оптимальное решение, найдем первый шаг, где они отличаются, и докажем, что оптимальное решение можно поменять так, чтобы оно осталось оптимальным, но этот отличающийся шаг стал совпадать с жадным решением. Тогда мы имеем оптимальное решение, которое совпадает с жадным на один шаг дальше. Тогда очевидно, что есть оптимальное решение, которое полностью совпадает с жадным, т.е. что жадное является оптимальным.</p>
        
        
        <p>Пример. Пусть у нас задача: есть $N$ вещей, каждая со своим весом. Надо выбрать как можно больше вещей так, чтобы суммарный вес не превосходил заданного числа $C$. Очевидное жадное решение: брать вещи, начиная с самой легкой, пока суммарный вес не превосходит $C$. Как только превзошел — все, выводим ответ.</p>
        
        <p>Давайте докажем. Рассмотрим жадное решение, оно берет себе вещи в порядке возрастания веса. Рассмотрим оптимальное решение и рассмотрим первый шаг, когда в жадном решении мы отклонились от оптимального. Это значит, что в жадном решении мы взяли вещь (пусть это вещь $X$), которая не входит в оптимальное решение. Значит, в оптимальном решении должна быть какая-то вещь (пусть это вещь $Y$), которой нет в жадном, иначе в жадном решении было бы больше вещей, чем в оптимальном, что противоречит оптимальности. При этом вещь $Y$ не легче, чем вещь $X$, т.к. в жадном решении мы брали все вещи в порядке возрастания веса. Тогда возьмем оптимальное решение, и заменим в нем вещь $Y$ на вещь $X$. Суммарный вес вещей в оптимальном решении не увеличится, количество вещей не уменьшится, поэтому решение по-прежнему будет оптимальным. Но оно будет совпадать с жадным на шаг дальше. ЧТД.</p>
        
        <p>Второй вариант доказательства подходит к тем задачам, где вам надо выбрать некоторый <i>порядок</i> предметов: набор предметов вам задан, а надо выбрать, в каком порядке их расположить, чтобы что-то оптимизировать. Тогда вы можете попробовать доказать, что предметы надо расположить в порядке возрастания некоторого параметра (это и будет жадным алгоритмом). Доказательство будет таким: пусть в оптимальном решении предметы идут не в таком порядке. Тогда найдем два соседних предмета, которые идут в неправильном порядке, и поменяем их местами, и докажем, что решение не ухудшится, а значит, останется оптимальным. Тогда очевидно, что жадное решение (которое расставляет предметы в порядке возрастания этого параметра) будет корректным.</p>
        
        <p>Пример. В олимпиадах типа ACM участники решают задачи. За каждую решенную задачу они получают штраф, равный времени, прошедшему с начала тура до момента решения этой задачи. Предположим, что у нас есть идеальная команда, и она тратит $t_i$ минут на решение $i$-й задачи (и никогда не делает неудачных попыток). В каком порядке им надо решать задачи, чтобы получить минимальный штраф?</p>
        
        <p>Жадный алгоритм: в порядке возрастания $t_i$. Доказательство. Пусть у нас есть оптимальное решение, в котором $t_i$ не отсортированы по возрастанию. Найдем две задачи, $i$ и $j$, такие, что в оптимальном решении мы решаем сначала решаем задачу $i$, а сразу после нее задачу $j$, при этом $t_i&gt;=t_j$. Поменяем их местами. Что изменится в плане штрафного времени? Для всех задач, которые мы решали до этих двух, штрафное время не изменится. Для всех задач, которые мы решали после этих двух, штрафное время тоже не изменится. (Именно для этого мы и брали соседние задачи.) Штрафное же время по этим задачам было $t_i+(t_i+t_j)$, а стало $t_j+(t_i+t_j)$. Поскольку $t_i&gt;=t_j$, то решение не ухудшилось, значит, оно осталось оптимальным. ЧТД.</p>
        
        <p>(Оба доказательства выше в принципе можно переформулировать на доказательства от противного: что если оптимальное решение сильно отличается от жадного, то мы меняем оптимальное решение, получаем решение, которое строго лучше, значит, оптимальное решение было не оптимальным. Да, так доказывать тоже можно, но надо аккуратно обойтись со случаем равных значений — случаем $t_i=t_j$ или случаем двух вещей одного веса в первой задаче.)</p>
        
        <p>На самом деле, второй вариант доказательства на самом деле позволяет <i>придумывать</i> жадность в тех задачах, где она не очевидна (если не поймете этот абзац, то не страшно). Если вам в задаче надо расположить объекты в некотором порядке, и вы не знаете, в каком, подумайте: пусть у вас есть некоторый порядок. Поменяем местами два соседних предмета, посмотрим, как изменится решение. Пусть оценка старого решения была $X$, а нового — $Y$ (это, конечно, функция решения). Напишем условие $X&gt;Y$, т.е. что решение улучшилось. Попробуем его преобразовать так, чтобы свести все к характеристикам двух объектов, которые мы меняем местами. Тогда, может быть, мы обнаружим, что условие $X&gt;Y$ эквивалентно условию $f(i)&gt;f(j)$, где $i$ и $j$ — предметы, которые мы поменяли местами, а $f$ — какая-то функция. Тогда очевидно, что в правильном решении надо просто отсортировать предметы по значению функции $f$.</p></div>
    """, {skipTree: true})

module25835 = () ->
    page("Разбор задачи \"Путешествие\", читать только тем, кто ее решил!", String.raw"""
        <div class="box generalbox generalboxcontent boxaligncenter clearfix"><p>Задачу "Путешествие" почему-то очень многие из вас решают очень сложно. На самом деле у этой задачи есть очень простое и короткое решение.</p>
        
        <p>Давайте для начала научимся решать задачу, когда решение существует (т.е. когда ответ не -1). Представьте, что вы едете по дороге. Вы проезжаете очередную заправку. Надо ли вам тут заправляться? Ответ очевиден: если на текущем запасе бензина вы доедете до следующей заправки, то не надо, иначе надо. Этот алгоритм элементарно реализуется, для простоты даже лучше хранить не остаток бензина (он постоянно меняется), а координату, до которой мы можем доехать на текущей заправке (она меняется только при заправках), или, что эквивалентно, информацию, где мы последний раз заправлялись (координату или номер заправки).</p>
        
        <p>Слегка альтернативный подход, но по сути то же самое — т.к. мы решаем задачу, а не едем по трассе, то мы всегда можем "отмотать" время назад. Поэтому едем по трассе, если видим, что до очередной заправки у нас не хватило бензина, то "отматываем" время назад и решаем, что надо бы заправиться на предыдущей заправке.</p>
        
        <p>Для удобства реализации можно в конец массива заправок добавить заправку с координатой $N$ (т.е. с координатой пункта назначения). При любой разумной реализации вы никогда в ней заправляться не будете, зато в основном цикле вам не придется особо рассматривать последний отрезок пути.</p>
        
        <p>Осталось научиться определять, когда ответ -1. Вообще, несложно понять, что ответ -1 тогда и только тогда, когда есть две заправки подряд, расстояние между которыми больше $k$. Это можно проверить заранее, или можно по ходу основного цикла, когда мы решаем заправиться, сразу проверять, сможем ли мы доехать хотя бы до следующей заправки.</p>
        
        <p>Вот два примера решений, которые реализуют этот простой алгоритм:</p>
        
        <pre>// Автор — Саддамбек Нурланбек уулу, комментарии мои (П.К.)
        #include <iostream>
         
        using namespace std;
         
        int k, q, c, n, a[1111];
         
        int main(){
              cin &gt;&gt; n &gt;&gt; k &gt;&gt; s;
         
              // ввод данных
              for(int i = 1;i &lt;= s;++i){
                    cin &gt;&gt; a[i];
                    // сразу проверяем, есть ли решение 
                    if(a[i] -  a[i - 1] &gt; k){
                          cout &lt;&lt; -1;
                          return 0;
                    }
              }
        
              // l - номер заправки, где заправлялись последний раз
              // (всё решение, и выше тоже, предполагает, что в a[0] == 0 изначально, 
              // это на самом деле не очень хорошо)
              int l = 0;
         
              // добавляем заправку в пункте назначения
              a[++s] = n;
         
              for(int i = 1;i &lt;= s;++i){
                    // если до текущей заправки доехать не можем
                    if(a[i] - a[l] &gt; k){
                          c++;
                          // заправляемся в предыдущем пункте
                          l = i - 1;
                    }
              }
         
              cout &lt;&lt; c;
        }
        </iostream></pre>
        <hr>
        <pre># Автор — Андрей Ефремов, комментарии мои (П.К.)
        n, k = [int(i) for i in input().split()]
        s = [int(i) for i in input().split()]
        
        # добавили заправку "очень далеко"
        s.append(2000)
        
        ans = 0
        
        # now = до какой координаты можем доехать при текущем запасе бензина
        now = k
        
        i = 1
        # пока не можем доехать до финиша
        while now &lt; n:
            # если не можем доехать до следующей заправки
            if s[i + 1] &gt; now:
                # если и до текущей не можем, то решения нет
                if s[i] &gt; now:
                    print(-1)
                    break
                else:
                    # иначе надо заправиться на текущей заправке
                    ans += 1
                    now = s[i] + k
            i += 1
        # else после while в питоне работает только если из while мы вышли не по break
        else:
            print(ans)
        </pre></div>
    """, {skipTree: true})

export default arrays = () ->
    return {
        topics: [
            topic("Простая жадность", "Задачи на простую жадность", [
                module25226(),
                problem(1576),
                problem(2826),
                problem(113075),
                problem(734),
                problem(1130),
                problem({testSystem: "codeforces", contest: "777", problem: "B"}),
            ], "greedy_simple"),
            module25835()
        ],
        advancedProblems: [
            problem(3678),
            problem({testSystem: "codeforces", contest: "777", problem: "D"}),
        ]
    }
