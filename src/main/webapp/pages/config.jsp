<%--

    Copyright 2009-2013 The Australian National University

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

           http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.

--%>
<%@ page contentType="text/html" isELIgnored="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="rs" uri="http://www.jasig.org/resource-server" %>


<portlet:defineObjects /> 

<c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : pageContext.request.locale}" scope="request" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="au.edu.anu.portal.portlets.sakaiconnector.utils.messages" />

<style type="text/css">

.sakaiconnector-portlet form p {
	margin-top: 1em;
	margin-bottom: 0;
	font-size: 0.9em;
	font-weight: bold;
}

.sakaiconnector-portlet form textarea {
	width: inherit !important;
}

.sakaiconnector-portlet form input {
	width: inherit !important;
}

.sakaiconnector-portlet-form {
	float:left;
  	width: 500px;
}
.sakaiconnector-portlet-info {
    margin-left: 500px;
}

.sakaiconnector-portlet-info dl {
	margin:0;
	margin-top: 1em;
}

.sakaiconnector-portlet-info dt {
	font-weight: bold;
}



</style>


<div class="sakaiconnector-portlet">

	<div class="sakaiconnector-portlet-form">
		
		<c:if test="${not empty errorMessage}">
			<p class="portlet-msg-error">${errorMessage}</p>
		</c:if>
			
		<form method="POST" action="<portlet:actionURL/>" id="<portlet:namespace/>_config">
		
			<h2><fmt:message key="config.global.heading.portlet" /></h2>
			
			<p><fmt:message key="config.global.portlet.title" /></p>
			<input type="text" name="portletTitle" value="${portletTitle}" />
			
			<h2><fmt:message key="config.global.heading.basiclti" /></h2>
		
			<p><fmt:message key="config.global.basiclti.key" /></p>
			<input type="text" name="key" value="${key}" />
			
			<p><fmt:message key="config.global.basiclti.secret" /></p>
			<input type="password" name="secret" value="${secret}" />
			
			<p><fmt:message key="config.global.basiclti.endpoint" /></p>
			<input type="text" name="endpoint" value="${endpoint}" size="50"/>
			
			<h2><fmt:message key="config.global.heading.sakai" /></h2>
			
			<p><fmt:message key="config.global.sakai.admin.username" /></p>
			<input type="text" name="adminUsername" value="${adminUsername}" />
			
			<p><fmt:message key="config.global.sakai.admin.password" /></p>
			<input type="password" name="adminPassword" value="${adminPassword}" />
			
			<p><fmt:message key="config.global.sakai.ws.login.url" /></p>
			<input type="text" name="loginUrl" value="${loginUrl}" size="50"/>
			
			<p><fmt:message key="config.global.sakai.ws.script.url" /></p>
			<input type="text" name="scriptUrl" value="${scriptUrl}" size="50"/>
			
			<p><fmt:message key="config.global.sakai.allowed.tools" /></p>
			<input type="text" name="allowedTools" value="${allowedTools}" size="40"/>
			
			<p>
	 			<input type="submit" value="<fmt:message key='config.button.submit' />">
			</p>
		</form>
	</div>
	
	<div class="sakaiconnector-portlet-info">
		<div class="portlet-msg-info">
			<h3>Configuration information</h3>
			
			<dl>
				<dt>Key</dt>
			    <dd>
				   	<p>The public parameter that uniquely identifies this portlet connecting to the Basic LTI provider, e.g. <b>my.school.edu.au</b>.
				   	<br />This must match the sakai.properties configuration on your Sakai server.</p>
				</dd>
				<dt>Secret</dt>
			    <dd>
				   	<p>The private value tied to the Basic LTI key, and is privately shared between the portlet and the Basic LTI provider, e.g. <b>secret</b>.
				   	<br />This must match the sakai.properties configuration on your Sakai server.</p>
				</dd>
				<dt>Endpoint</dt>
			    <dd>
				   	<p>The Basic LTI endpoint on the Sakai server, e.g. <b>https://your.sakai.server/imsblti/provider/</b>.</p>
				</dd>
				<dt>Admin username</dt>
			    <dd>
				   	<p>The username of a user in Sakai that has admin privileges, e.g. <b>admin</b>.
				   	<br />This doesn't necessarily have to be the actual admin user, but must be a user in the /site/!admin realm.</p>
				</dd>
				<dt>Admin password</dt>
			    <dd>
				   	<p>The password of the admin user you entered above, e.g. <b>abc123</b>.</p>
				</dd>
				<dt>Web service login URL</dt>
			    <dd>
				   	<p>The URL to the SakaiLogin web service on your Sakai server, e.g. <b>https://your.sakai.server/sakai-axis/SakaiLogin.jws?wsdl</b>.</p>
				</dd>
				<dt>Web service script URL</dt>
			    <dd>
				   	<p>The URL to the SakaiScript web service on your Sakai server, e.g. <b>https://your.sakai.server/sakai-axis/SakaiScript.jws?wsdl</b>.</p>
				</dd>
				<dt>Allowed tools</dt>
			    <dd>
				   	<p>The list of allowed tool IDs that you want to make available for users to choose from, e.g. <b>sakai.resources:sakai.rwiki:sakai.profile2:sakai.sitestats</b>.
				   	<br />This must match the sakai.properties configuration on your Sakai server, be colon separated, and not contain spaces.</p>
				</dd>
			</dl>
			
		</div>
	
	</div>
	
	

</div>
