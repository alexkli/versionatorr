<%@ page contentType="text/html;charset=UTF-8" language="java" %><%
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%
%><%@ page import="
    org.osgi.framework.Version,
    org.apache.maven.artifact.versioning.DefaultArtifactVersion,
    org.apache.maven.shared.osgi.DefaultMaven2OsgiConverter
" %><%
%><%!
    String comparisonSymbol(int compareResult) {
        if (compareResult < 0) {
            return "<";
        } else if (compareResult > 0) {
            return ">";
        } else {
            return "=";
        }
    }

    String def(String str, String def) {
        if (str == null) {
            return def;
        }
        return str;
    }
%><%
    String a = def(request.getParameter("a"), "1.0");
    String b = def(request.getParameter("b"), "1.2");
%><html>
<head>
    <title>Versionatorr</title>
    <link type="text/css" rel="stylesheet" href="github-markdown.css" />
    <link type="text/css" rel="stylesheet" href="stylish.css" />
</head>

<body>
<article class="markdown-body">

    <h1>Versionatorr&trade;</h1>
    <p class="center">Compare and understand Maven & OSGi version numbers. Start here:</p>

    <form method="GET">
        <table class="triptych">
            <tr>
                <td><input name="a" value="<%= a %>" /></td>
                <td>vs.</td>
                <td><input name="b" value="<%= b %>" /></td>
            </tr>
        </table>
        <p class="note center">
            Examples: <a href="?a=1.0&b=1.2">simple</a>,
            <a href="?a=1.0-SNAPSHOT&b=1.0">SNAPSHOT</a>,
            <a href="?a=1.0-beta&b=1.0">qualifier</a>,
            <a href="?a=1.2.3-42-beta&b=1.2.3-42">build number</a>,
            <a href="?a=1.0.0.2&b=1.0.0.2.0.0.0">dotdotdot</a>
        </p>
        <p class="fight">
            <input type="submit" value="Fight!">
        </p>
    </form>

    <h3><a href="http://books.sonatype.com/mvnref-book/reference/pom-relationships-sect-pom-syntax.html">Maven</a></h3>

    <%
        DefaultArtifactVersion mavenA = new DefaultArtifactVersion(a);
        DefaultArtifactVersion mavenB = new DefaultArtifactVersion(b);
        int mavenComp = mavenA.compareTo(mavenB);
    %>

    <table class="triptych result">
        <tr>
            <td><span class="<%= mavenComp > 0 ? "winner" : "" %>"><%= a %></span></td>
            <td><%= comparisonSymbol(mavenComp) %></td>
            <td><span class="<%= mavenComp < 0 ? "winner" : "" %>"><%= b %></span></td>
        </tr>
    </table>

    <table class="details">
        <thead>
            <tr>
                <th>Full</th>
                <th>Major</th>
                <th>Minor</th>
                <th>Incremental</th>
                <th>Build Number</th>
                <th>Qualifier</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><%= mavenA.toString() %></td>
                <td><%= mavenA.getMajorVersion() %></td>
                <td><%= mavenA.getMinorVersion() %></td>
                <td><%= mavenA.getIncrementalVersion() %></td>
                <td><%= mavenA.getBuildNumber() %></td>
                <td><%= def(mavenA.getQualifier(), "") %></td>
            </tr>
            <tr>
                <td><%= mavenB.toString() %></td>
                <td><%= mavenB.getMajorVersion() %></td>
                <td><%= mavenB.getMinorVersion() %></td>
                <td><%= mavenB.getIncrementalVersion() %></td>
                <td><%= mavenB.getBuildNumber() %></td>
                <td><%= def(mavenB.getQualifier(), "") %></td>
            </tr>
        </tbody>
    </table>

    <h3><a href="http://www.osgi.org/javadoc/r4v43/core/org/osgi/framework/Version.html">OSGi</a></h3>

    <%
        DefaultMaven2OsgiConverter maven2Osgi = new DefaultMaven2OsgiConverter();

        Version osgiA;
        Version osgiB;
        String osgiConvertedA = null;
        String osgiConvertedB = null;

        try {
            osgiA = new Version(a);
        } catch (Exception e) {
            osgiConvertedA = maven2Osgi.getVersion(a);
            osgiA = new Version(osgiConvertedA);
            a = osgiConvertedA;
        }
        try {
            osgiB = new Version(b);
        } catch (Exception e) {
            osgiConvertedB = maven2Osgi.getVersion(b);
            osgiB = new Version(osgiConvertedB);
            b = osgiConvertedB;
        }

        int osgiComp = osgiA.compareTo(osgiB);
    %>

    <table class="triptych result">
        <tr>
            <td><span class="<%= osgiComp > 0 ? "winner" : "" %>"><%= a %></span></td>
            <td><%= comparisonSymbol(osgiComp) %></td>
            <td><span class="<%= osgiComp < 0 ? "winner" : "" %>"><%= b %></span></td>
        </tr>
        <tr class="note">
            <td>
                <% if (osgiConvertedA != null) { %>
                <a href="http://felix.apache.org/site/apache-felix-maven-bundle-plugin-bnd.html">Converted</a> into OSGi compliant format.
                <% } %>
            </td>
            <td></td>
            <td>
                <% if (osgiConvertedB != null) { %>
                <a href="http://felix.apache.org/site/apache-felix-maven-bundle-plugin-bnd.html">Converted</a> into OSGi compliant format.
                <% } %>
            </td>
        </tr>
    </table>

    <table class="details">
        <thead>
            <tr>
                <th>Full</th>
                <th>Major</th>
                <th>Minor</th>
                <th>Micro (Patch)</th>
                <th>Qualifier</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><%= osgiA.toString() %></td>
                <td><%= osgiA.getMajor() %></td>
                <td><%= osgiA.getMinor() %></td>
                <td><%= osgiA.getMicro() %></td>
                <td><%= osgiA.getQualifier() %></td>
            </tr>
            <tr>
                <td><%= osgiB.toString() %></td>
                <td><%= osgiB.getMajor() %></td>
                <td><%= osgiB.getMinor() %></td>
                <td><%= osgiB.getMicro() %></td>
                <td><%= osgiB.getQualifier() %></td>
            </tr>
        </tbody>
    </table>

    <footer>
        &copy; 2014 alexkli –
        <a href="https://github.com/alexkli/versionatorr">Code on github</a>
        <br>
        Using org.osgi.core 4.1.3, maven-artifact 3.1 and maven-bundle-plugin 2.4.0.
    </footer>

</article>
</body>
</html>