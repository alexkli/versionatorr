<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.osgi.framework.Version" %>
<%@ page import="org.apache.maven.artifact.versioning.ComparableVersion" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%!
    String compOp(int compareResult) {
        if (compareResult < 0) {
            return "<";
        } else if (compareResult == 0) {
            return "=";
        } else {
            return ">";
        }
    }
%>

<html>
<head>
    <style>
        body {
            font-family: Helvetica, Verdana, sans-serif;
            background-color: #FFFFCC;
            padding: 40px;
        }
    </style>
</head>

<body>

<%
    String verA = request.getParameter("versionA");
    if (verA == null) {
        verA = "1.2";
    }
    String verB = request.getParameter("versionB");
    if (verB == null) {
        verB = "1.2.3";
    }
    ComparableVersion mavenVerA = new ComparableVersion(verA);
    ComparableVersion mavenVerB = new ComparableVersion(verB);
    Version osgiVerA = Version.parseVersion(verA);
    Version osgiVerB = Version.parseVersion(verB);
%>
<h1>Versionatorr: Comparing Maven & OSGi Versions</h1>

<form method="GET">
    <label>
        Version A:
        <input name="versionA" value="<%= verA %>"/>
    </label>
    <br>
    <label>
        Version B:
        <input name="versionB" value="<%= verB %>"/>
    </label>
    <br>
    <input type="submit" value="Compare">
</form>

<h2>Maven</h2>
<p>
    <%= verA %> <b><%= compOp(mavenVerA.compareTo(mavenVerB)) %></b> <%= verB %>
</p>

<h2>OSGi</h2>
<p>
    <%= verA %> <b><%= compOp(osgiVerA.compareTo(osgiVerB)) %></b> <%= verB %>
</p>

</body>
</html>