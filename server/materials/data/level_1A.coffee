import label from "../lib/label"
import level from "../lib/level"
import page from "../lib/page"
import problem from "../lib/problem"
import topic from "../lib/topic"

topic_module_33219_0 = () ->
    return topic("Как отлаживать программы", null, [
        label("<a href=\"http://blog.algoprog.ru/how-to-debug-small-programs/\">Про то, как искать ошибки в маленьких программах</a>. Вы, наверное, пока еще не все тут поймете, но тем не менее прочитайте, а потом возвращайтесь к этому тексту на всем протяжении уровня 1."),
    ])

topic_15960 = () ->
    return topic("Арифметические операции", "1А: Задачи на арифметические операции", [
        label("<a href=\"http://notes.algoprog.ru/python_basics/0_quick_start.html\">Начало работы c питоном и Wing IDE</a>"),
        problem(2938),
        problem(2939),
        problem(2937),
        problem(2936),
        problem(2941),
        problem(2942),
        problem(2943),
        problem(2944),
        problem(2947),
        problem(2951),
        problem(2952),
    ])

topic_15962 = () ->
    return topic("Условный оператор", "1А: Задачи на условный оператор", [
        label("<a href=\"http://notes.algoprog.ru/python_basics/1_if.html\">Питон: теория по условному оператору</a>"),
        label("<a href=\"http://blog.algoprog.ru/do-not-check-limits/\">Не надо проверять, выполняются ли ограничения из условия</a>"),
        problem(292),
        problem(293),
        problem(2959),
        problem(294),
        problem(253),
        problem(11),
        problem({testSystem: "ejudge", contest: 6, problem: 2, id: "e26"})
        problem(12),
        problem({testSystem: "ejudge", contest: 6, problem: 3, id: "e23"})
        problem(13),
        problem({testSystem: "ejudge", contest: 6, problem: 1})
        problem(14),
        problem({testSystem: "ejudge", contest: 6, problem: 4})
    ])

module15969 = () ->
    page("Про оформление программ и отступы (про паскаль, но в питоне и c++ все то же самое)", """
        <div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Оформление программ и отступы</h1>
        <h2>Общие замечания</h2>
        <p>Паскаль, как и многие другие языки программирования, допускает достаточно свободное оформление программ. Вы можете ставить пробелы и переводы строк как вам угодно (за исключением, конечно, ряда понятных требований типа пробелов в выражении <font face="courier">if a mod b=c then</font>).</p><p>
        
        </p><p>Тем не менее, следует придерживаться определенных правил — не для того, чтобы программа компилировалась, а для того, чтобы программу было бы легче читать человеку. Это важно и в ситуации, когда вашу программу будет читать кто-то другой, так и в ситуации, когда вашу программу будете читать <i>вы сами</i>. В хорошо отформатированной программе легче находить другие ошибки компиляциии, легче находить логические ошибки в коде, такую программу легче дописывать и модифицировать и так далее.</p>
        
        <p>Основная цель форматирования программы — чтобы была лучше видна ее структура, то есть чтобы были лучше видны циклы, if'ы и прочие конструкции, важные для понимания последовательности выполнения действий. Должно быть легко понять, какие команды в каком порядке выполняются в программе, и в первую очередь — какие команды относятся к каким циклам и if'ам (циклы, if'ы и подобные конструкции ниже я буду называть управляющими конструкциями).</p>
        
        <p>Поэтому следует придерживаться некоторых правил. Есть множество разных стандартов, правил на эту тему; во многих проектах, которые пишут целые команды программистов, есть официально требования, и каждый программист обязан их соблюдать вплоть до пробела. На наших занятиях я не буду столь строго относиться к оформлению, но тем не менее я буду требовать соблюдения ряда правил (это — некоторая "выжимка", то общее, что есть практически во всех стандартах), а также буду настоятельно рекомендовать соблюдать еще ряд правил.</p>
        
        <p>Разделы ниже будут пополняться по мере того, как я что-то буду вспоминать или видеть в ваших программах.</p>
        
        <h2>Обязательные требования</h2>
        <ul>
        <li>Используйте здравый смысл. Любое из указанных ниже правил можно нарушать, если здравый смысл подсказывает вам, что лучше сделать не так — но такие ситуации скорее исключение, чем правило.</li>
        <li>На каждой строке должно быть не более одной команды и/или управляющей конструкции.
        <ul><li>Исключение: очень тесно связанные между собой по смыслу команды типа assign и reset.</li>
        <li>Исключение: управляющая конструкция, внутри которой находится только одна короткая команда, например:
        <pre>if a&gt;0 then inc(i);
        </pre>
        </li>
        <li>Исключение: цикл for со вложенным if'ом, имеющий смысл "пройти только по элементам, удовлетворяющим условию":
        <pre>for i:=a to b do if x[i]&lt;&gt;0 then begin // больше кода тут быть не должно!
        </pre>
        </li>
        </ul>
        </li>
        <li>В коде должны быть отступы — некоторые строки должны быть написаны не вплотную к левому краю, а с несколькими пробелами вначале:
        <pre>if a=0 then begin
           b:=2;  // в этой строке отступ
           c:=c+2; // и в этой тоже
        end;
        </pre>
        Основной принцип отступов — программу можно представить себе как последовательность вложенных блоков. Основной блок — сама программа. В нем могут быть простые команды, а также сложные блоки — if'ы, циклы и т.д. Код внутри if'а или внутри цикла — это отдельный блок, вложенный в основной блок. Код внутри цикла внутри if'а — это блок, вложенный в другой блок, вложенный в третий. Пример: следующему коду:
        <pre>read(n);
        for i:=1 to n do begin
          read(a[i]);
          if a[i]&gt;0 then begin
            writeln(a[i]);
            k:=k+1;
          end;
        end;
        if n&gt;0 then 
          writeln('!');
        </pre> 
        соответствует следующая структура блоков:
        <pre>+--------------------+
        | основная программа |
        | +-----------+      |
        | | цикл for  |      |
        | | +-------+ |      |
        | | | if    | |      |
        | | +-------+ |      |
        | +-----------+      |
        | +------+           |
        | | if   |           |
        | +------+           |
        +--------------------+
        </pre>
        Так вот, в пределах одного блока отступ должен быть один и тот же. А для каждого внутреннего блока отступ должен быть увеличен. (При этом заголовок цикла или if'а считается частью внешнего блока и пишется без отступа.)</li>
        <li>То же самое можно сказать по-другому: внутренний код управляющей конструкции должен быть написан с отступом. Если в одну управляющую конструкцию вложена другая, то отступ у внутреннего кода должен быть удвоен, и т.д. В результате все команды, которые всегда выполняются одна за другой, должны идти с одним отступом (их первые символы должны идти один под другим), а если где-то порядок может меняться, отступы должны быть разные.<br>
        Придерживайтесь одинакового размера "базового" отступа везде в программе, обычно его берут 2 или 4 пробела. Один пробел — слишком мало.<br>
        Пример отступов:
        <pre>for i:=1 to n do begin
            read(a); // вошли внутрь for --- появился отступ: 4 пробела
            if a&lt;&gt;0 then begin 
                inc(m); // вошли еще и внутрь if --- отступ стал в два раза больше
                b[m]:=a;
            end;
        end;
        for i:=1 to m do
            writeln(b[i]); // если выше единичный отступ был 4 пробела, то и здесь тоже 4, а не 2!
        </pre></li>
        <li>Элементы, обозначающие окончание части или всей управляющей конструкции (else и/или end) должны находиться на отдельных строках и на том же уровне отступа, что и начало управляющей конструкции. (К begin это не относится, т.к. начало управляющей конструкции видно и так.)<br>
        Примеры:<br>
        <font color="red">Неправильно:
        <pre>for i:=1 to n do begin
            read(a);
            s:=s+a; end;      // end очень плохо заметен
        if s&gt;2 then 
            writeln(s) 
            else begin         // else очень плохо заметен
            writeln('Error');
            halt;
            end;               // end плохо заметен
        </pre></font>
        <font color="green">Правильно:
        <pre>for i:=1 to n do begin
            read(a);
            s:=s+a; 
        end;                  // end сразу виден
        if s&gt;2 then
            writeln(s) 
        else begin            // else сразу виден и разрывает последовательность строк: 
            writeln('Error');  // видно, что это две ветки
            halt;
        end;                  // видно, что end есть и не потерян
        </pre></font>
        Допускается размещать фразу <font face="courier">end else begin</font> на одной строке.</li>
        <li>Бывает так, что у вас идет целая цепочка конструкций if, разбирающая несколько случаев:
        <pre>if dir='North' then
            ...
        else if dir='South' then
            ...
        else if dir='East' then
            ...
        else if dir='West' then
            ...
        else
            writeln('Error!');
        </pre>
        По смыслу программы это — многовариантное ветвление, здесь все случаи равноправны или почти равноправны. Тот факт, что в программе каждый следующий if вложен в предыдущий — это просто следствие того, что в паскале нет возможности сделать многовариантное ветвление. Поэтому такой код надо оформлять именно так, как указано выше, т.е. все ветки <font face="courier">else if</font> делать на одном отступе. (Не говоря уж о том, что если на каждый такой if увеличивать отступ, то программа очень сильно уедет вправо.)<br>
        Но отличайте это от слудеющего варианта:
        <pre>if a=0 then 
            writeln(-1);
        else begin
            if b=0 then begin
                x:=1;
            else
                x:=b/a;
            writeln(x);
        end;
        </pre>
        Здесь варианты <code>if a=0</code> и <code>if b=0</code> не равноправны: вариант <code>b=0</code> явно вложен внутрь <code>else</code>.
        
        </li><li>Команды, выполняющиеся последовательно, должны иметь один и тот же оступ.
        Примеры:<br>
        <font color="red">Неправильно:
        <pre> read(a);
           b:=0;
          c:=0;
        for i:=1 to a do begin
              b:=b+i*i;
            c:=c+i;
         end;
        </pre></font>
        <font color="red">Все равно неправильно (for всегда выполняется после c:=0, поэтому отступы должны быть одинаковыми):
        <pre>   read(a);
           b:=0;
           c:=0;
        for i:=1 to a do begin 
              b:=b+i*i;
              c:=c+i;
        end;
        </pre></font>
        <font color="green">Правильно:
        <pre>read(a);
        b:=0;
        c:=0;
        for i:=1 to a do begin 
            b:=b+i*i;
            c:=c+i;
        end;
        </pre></font>
        </li>
        <li>Не следует без необходимости переносить на новую строку части заголовка управляющих конструкций (условия в if, while, repeat; присваивание в заголовке for; параметры процедур и т.д.). С другой стороны, если заголовок управляющей конструкции получается слишком длинным, то перенести можно, но тогда перенесенная часть должна быть написана с отступом, и вообще форматирование должно быть таким, чтобы было четко видно, где заканчивается заголовок управляющей конструкции, и хорошо бы выделить структуру заголовка (парные скобки в условии и т.п.)<br>
        Примеры:<br>
        <font color="red">Неправильно:
        <pre>if
        a=0 then // условие короткое, лучше в одну строку
        ...
        for 
           i:=1
           to 10 do // аналогично
        ...
        {слишком длинно --- лучше разбить}
        if (((sum+min=min2+min3) or (sqrt(sumSqr)&lt;30)) and (abs(set1-set2)+eps&gt;thershold)) or (data[length(s)-i+1]=data[i]) or good then...</pre></font>
        <font color="green">Правильно:
        <pre>if a=0 then
        ...
        for i:=1 to 10 do
        ...
        {четко видно, где заканчивается условие, плюс выделены парные скобки}
        if (
              ( (sum+min=min2+min3) or (sqrt(sumSqr)&lt;30) ) and (abs(set1-set2)+eps&gt;thershold)
            ) or (data[length(s)-i+1]=data[i]) or good
        then...</pre></font>
        
        </li><li>В секции <font face="courier">var</font> все строчки должны быть выровнены так, чтобы первая буква первой переменной в каждой строке были бы одна под другой; это обозначает, что у второй и далее строк должен быть отступ 4 пробела. Аналогично в остальных секциях, идущих до кода, (<font face="courier">type</font>, <font face="courier">const</font> и т.д.) надо все строки варавнивать по первому символу:
        <pre>type int=integer;
             float=extended;
        var i:integer;
            s:string;
        </pre>
        </li><li>Разделяйте процедуры/функции друг от друга и от основного текста пустой строкой (или двумя); используйте также пустые строки внутри длинного программного текста, чтобы разбить его на логически связные блоки.</li>
        </ul>
        <h2>Не столь обязательные требования, но которые я настоятельно рекомендую соблюдать</h2>
        <ul>
        <li>Пишите <font face="courier">begin</font> на той же строке, что и управляющая конструкция, ну или хотя бы на том же отступе, что и управляющая конструкция:<br>
        <font color="red">Совсем плохо:
        <pre>for i:=1 to n do
            begin
            read(a[i]);
            ...
        </pre>
        </font>
        <font color="#555500">Более-менее:
        <pre>for i:=1 to n do
        begin
            read(a[i]);
            ...
        </pre></font>
        <font color="green">Еще лучше:
        <pre>for i:=1 to n do begin
            read(a[i]);
            ...
        </pre></font>
        </li>
        </ul>
        <h2>Пример хорошо отформатированной программы:</h2>
        <pre>function sum(a, b: longint): longint;
        begin
          sum := a + b;
        end;
         
        var i, a, b, s: longint;
            x, y: double;
            arr: array [1..1000] of boolean;
         
        begin
        read(a, b);
         
        arr[1] := true;
         
        for i := 2 to 1000 do
          if ((a &gt; 0) and (arr[i-1])) then
            arr[i] := true;
         
        for i := 1 to 1000 do
          arr[i] := false;
         
        s := 0;
        if (a &lt; 0) then begin
          a := -a;
          if (b &lt; 0) then begin
            b := -b;
            s := a + b;
          end else begin
            while (s &lt;= 0) do begin
              case a of
                1: begin
                  s := s + 3;
                end;
                2: begin
                  s := s - 4;
                  a := a - 1;
                end;
                else
                  s := 1;
              end;
            end;
          end;
        end else if (b &lt; 0) then begin
          b := -b;
          s := (a + b) * (a - b);
        end else begin
          s := sum(a, b) * sum(a, b);
        end;
            
        writeln(s);
        end.
        </pre></div>
    """, {skipTree: true})

topic_15966 = () ->
    return topic("Циклы", "1А: Задачи на циклы", [
        label("""
            <a href="http://notes.algoprog.ru/python_basics/2_loops.html">Питон: теория про циклы</a><br>
            Внутри теории про циклы есть также раздел <a href="http://notes.algoprog.ru/python_basics/2_loops.html#break-continue">про команды break и continue</a>.
            Прочитайте его, даже если вы пишете не на питоне, в других языках все аналогично.
        """),
        module15969(),
        problem(333),
        problem(351),
        problem(315),
        problem(340),
        problem(347),
        problem(113),
        problem(3058),
        problem(3064),
        problem(3065),
        problem(3067),
    ])

export default level_1A = () ->
    return level("1А", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_15960(),
        topic_15962(),
        topic_module_33219_0(),
        topic_15966(),
    ])