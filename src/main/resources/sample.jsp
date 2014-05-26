<%
import java.util.*;
import java.io.*;
import de.ruedigermoeller.template.*;

public class CLAZZNAME implements IContextReceiver
{
    public void receiveContext(Object o, PrintStream out) throws Exception
    {
       Object CTX = o;
%>
Trallala <%+ new Date() %>
Hallo, dies ist output. Kontext:<%+CTX%> Datum:<%+ new Date()%>
<% for(int i=0; i < 100; i++ ) {%>
public void setValue<%+i%>( Object val ) {
    mVal<%+i%> = val;
}
<%}%>
<%
    }
}
%>