temp-late
=========

minimalistic template processor

How it works:
a template file is converted into a temporary java file. Basically the temp file is the "inverted" version of the template:
normal code gets into "System.out.println( 'code from template' );" and tagged code of the template becomes the source.
This file is then loaded and executed. The caller can hand in an arbitrary object which can be used at generation time.

There are 2 tags:
`<% %>` quotes arbitrary java code executed at generation time.
`<%+ %>` inserts the String of a java expression into the result. e.g. `<%+data.value%>`

example:
```jsp
<%
import java.util.*;
import java.io.*;
import de.ruedigermoeller.template.*;

// add imports you need during generation =>
import de.ruedigermoeller.templatesample.*;

// this header is always required to make it work. Cut & Paste this as template
public class CLAZZNAME implements IContextReceiver
{
    public void receiveContext(Object o, PrintStream out) throws Exception
    {
       TemplateSample.TemplateContext CTX = (TemplateSample.TemplateContext)o; // cast to your expected context class
%>

<%
    // stuff denoted here is just executed at generation time
    int xy = 13;
%>

// imports of output go here
import java.util.*;

public class <%+CTX.clazzName%> {

    public <%+CTX.clazzName%>() {
        System.out.println(\"value of xy at generation time \"+<%+xy%>); // note the quoting !
    }

<% // example for a loop
   for(int i=0; i < CTX.getters.length; i++ ) { %>
    String <%+CTX.getters[i]%>;

    public get<%+CTX.getters[i]%>( String val ) {
        return <%+CTX.getters[i]%>;
    }
<%} /* for */ %>
}

<%
    // this footer is always required (to match opening braces in header
    }
}
%>
```
is transformed to this intermediary file
```java

import java.util.*;
import java.io.*;

import de.ruedigermoeller.template.*;

// add imports you need during generation =>
import de.ruedigermoeller.templatesample.*;

// this header is always required to make it work. Cut & Paste this as template
public class sampleGEN implements IContextReceiver {
    public void receiveContext(Object o, PrintStream out) throws Exception {
        TemplateSample.TemplateContext CTX = (TemplateSample.TemplateContext) o; // cast to your expected context class
// template line:14
        out.println(""); // template line:15
        out.println(""); // template line:16

        // stuff denoted here is just executed at generation time
        int xy = 13;
// template line:19
        out.println(""); // template line:20
        out.println(""); // template line:21
        out.println("// imports of output go here"); // template line:22
        out.println("import java.util.*;"); // template line:23
        out.println(""); // template line:24
        out.print("public class " + CTX.clazzName);// template line:24
        out.println(" {"); // template line:25
        out.println(""); // template line:26
        out.print("    public " + CTX.clazzName);// template line:26
        out.println("() {"); // template line:27
        out.print("        System.out.println(\"value of xy at generation time \"+" + xy);// template line:27
        out.println("); // note the quoting !"); // template line:28
        out.println("    }"); // template line:29
        out.println(""); // template line:30
        // example for a loop
        for (int i = 0; i < CTX.getters.length; i++) { // template line:31
            out.println(""); // template line:32
            out.print("    String " + CTX.getters[i]);// template line:32
            out.println(";"); // template line:33
            out.println(""); // template line:34
            out.print("    public get" + CTX.getters[i]);// template line:34
            out.println("( String val ) {"); // template line:35
            out.print("        return " + CTX.getters[i]);// template line:35
            out.println(";"); // template line:36
            out.println("    }"); // template line:37
        } /* for */ // template line:37
        out.println(""); // template line:38
        out.println("}"); // template line:39
        out.println(""); // template line:40

        // this footer is always required (to match opening braces in header
    }
}
// template line:44
```

which then is executed with the given context.

Generating intermediary and execut in one step:
```java
public static void main( String arg[] ) {
    TemplateExecutor.Run("./src/main/resources/sample.jsp", new TemplateContext("GeneratedClass"));
}
```

Note that it is checked, wether the template has changed before regenerating it.
The intermedaite files can be found in ./tempgen to easy finding bugs/errors during compilation.

A working sample is included.
