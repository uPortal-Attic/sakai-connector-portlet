<%@ page contentType="text/html" isELIgnored="false" %>

<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%@ page import="javax.portlet.PortletConfig" %>


<%@ page import="au.edu.anu.portal.portlets.basiclti.support.OAuthSupport" %>
<%@ page import="au.edu.anu.portal.portlets.basiclti.support.HttpSupport" %>

<% 


//need to get values from the URL and then reconstruct the map.
//this is because the iframe is in a different request so does not have access to the original data
//so we must pass it on the URL and deserilaise it back to a map here via Request.getParameterMap

//since this is a separate request, we are no longer in the portlet


//convert URL params back into Map
Map<String,String> props = HttpSupport.deserialiseParameterMap(request.getParameterMap());

//get secret from application config
String secret = application.getInitParameter("secret");

//construct endpoint from application config and add remote toolId
String endpoint = application.getInitParameter("endpoint") + props.get("remote_tool_id");

//get key from map
String key = props.get("tool_consumer_instance_guid");

//sign the map
props = OAuthSupport.signProperties(endpoint, props, "POST", key, secret);
//String data = HttpSupport.doPost(endpoint,props);
String data = HttpSupport.postLaunchHtml(endpoint,props);


if(data == null) {
	out.println("connection failed"); 
} else {
	out.println(data);
}

%>


