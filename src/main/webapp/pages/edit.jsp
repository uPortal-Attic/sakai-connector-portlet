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


<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedHashMap" %>

<%@ page import="au.edu.anu.portal.portlets.sakaiconnector.utils.Constants" %>
<%@ page import="au.edu.anu.portal.portlets.sakaiconnector.logic.SakaiWebServiceLogic" %>
<%@ page import="au.edu.anu.portal.portlets.sakaiconnector.helper.SakaiWebServiceHelper" %>
<%@ page import="au.edu.anu.portal.portlets.sakaiconnector.models.Site" %>
<%@ page import="au.edu.anu.portal.portlets.sakaiconnector.models.Tool" %>

<%
List<String> heights = new ArrayList<String>();
heights.add(String.valueOf(Constants.PORTLET_HEIGHT_400));
heights.add(String.valueOf(Constants.PORTLET_HEIGHT_600));
heights.add(String.valueOf(Constants.PORTLET_HEIGHT_800));
heights.add(String.valueOf(Constants.PORTLET_HEIGHT_1200));
heights.add(String.valueOf(Constants.PORTLET_HEIGHT_1600));
pageContext.setAttribute("heights",heights);
%>

<portlet:defineObjects /> 

<c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : pageContext.request.locale}" scope="request" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="au.edu.anu.portal.portlets.sakaiconnector.utils.messages" />

 
<rs:resourceURL var="jQueryPath" value="/rs/jquery/1.4.2/jquery-1.4.2.min.js"/>
<script type="text/javascript" language="javascript" src="${jQueryPath}"></script>

<c:set var="n"><portlet:namespace /></c:set>

<script type="text/javascript">
	$(document).ready(function(){
		
		//listen for change events with site id selector
		$('select#${n}_remoteSiteId').change(function(event){
		   
			//dont submit the form if the siteid value is blank
			var siteIdValue = $('select#${n}_remoteSiteId').val();
			
			if(siteIdValue != '') {
				//site id changed so reset the tool list
		  	 	$('select#${n}_remoteToolId').val($('option:first', this).val());
		   		$('form#${n}_edit').submit();
			}
		});
		
		//listen for change events with tool id selector
		$('select#${n}_remoteToolId').change(function(event){
		   
			//check the button
			checkSubmit();
			
		});
		
		//check submit button on each page load
		checkSubmit();
		
		// function to check the submit button and enable/disable as required
		function checkSubmit() {
			var siteIdValue = $('select#${n}_remoteSiteId').val();
			var toolIdValue = $('select#${n}_remoteToolId').val();
			
			//disable if either is blank
			if(siteIdValue == '' || toolIdValue == '') {
				$('#${n}_submit').attr('disabled', true);
			}
			
			//enable only if both have a value
			if(siteIdValue != '' && toolIdValue != '') {
				$('#${n}_submit').attr('disabled', false);
			}
		}
	
		
		
	});

</script>

<style type="text/css">

.sakaiconnector-portlet form p {
	margin-top: 1em;
	margin-bottom: 0;
	font-size: 0.9em;
	font-weight: bold;
}
.sakaiconnector-portlet form a {
	font-weight: normal;
}

.sakaiconnector-portlet h2 {
	margin-top: 0;
}

</style>


<div class="sakaiconnector-portlet">

	<c:if test="${not empty errorMessage}">
		<p class="portlet-msg-error">${errorMessage}</p>
	</c:if>
		
	
	<form method="POST" action="<portlet:actionURL/>" id="${n}_edit">
	
		<p><fmt:message key="config.portlet.title" /></p>
		<input type="text" name="portletTitle" id="${n}_portletTitle" value="${preferredPortletTitle}" />
		
		<p><fmt:message key="config.portlet.height" /></p>
		<select name="portletHeight" id="${n}_portletHeight">
			<c:forEach var="item" items="${heights}">
				<c:choose>
					<c:when test="${item eq preferredPortletHeight}">
					<option value="${item}" selected="selected">${item}</option>
					</c:when>
					<c:otherwise>
						<option value="${item}">${item}</option>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>
		
			
		<p><fmt:message key="config.remote.site" /></p>
		<select name="remoteSiteId" id="${n}_remoteSiteId">
			<option value=""><fmt:message key="config.remote.site.choose" /></option>
			<c:forEach var="item" items="${remoteSites}">
				<c:choose>
					<c:when test="${item.id eq preferredRemoteSiteId}">
						<option value="${item.id}" selected>${item.title}</option>
					</c:when>
					<c:otherwise>
						<option value="${item.id}">${item.title}</option>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>
			
		
		
		<p><fmt:message key="config.remote.tool" /></p>
		<c:choose>
			<c:when test="${not empty preferredRemoteSiteId || replayForm}">
			
				<%
				// get list of tools for this site
				List<Tool> rawTools = SakaiWebServiceHelper.getToolsForSite((SakaiWebServiceLogic)request.getAttribute("logic"), (String)request.getAttribute("preferredRemoteSiteId"), (String)request.getAttribute("eid"));
				
				//clean it
				List<Tool> tools = new ArrayList<Tool>();
				List<String> allowedToolIds = (List<String>)request.getAttribute("allowedToolIds");
				
				for(Tool tool: rawTools) {
					if(allowedToolIds.contains(tool.getRegistrationId())) {
						tools.add(tool);
					}
				}
				
				
				pageContext.setAttribute("tools",tools);
				%>
				
				<select name="remoteToolId" id="${n}_remoteToolId">
					<option value=""><fmt:message key="config.remote.tool.choose" /></option>
					
					<c:forEach var="item" items="${tools}">
						<c:choose>
							<c:when test="${item.registrationId eq preferredRemoteToolId}">
								<option value="${item.registrationId}" selected>${item.title}</option>
							</c:when>
							<c:otherwise>
								<option value="${item.registrationId}">${item.title}</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
			
			
			</c:when>
			<c:otherwise>
				<select name="" disabled>
					<option value=""><fmt:message key="config.remote.tool.choosesitefirst" /></option>
				</select>
			</c:otherwise>
		
		
		</c:choose>
		
		<p>
 			<input type="submit" id="${n}_submit" value="<fmt:message key='config.button.submit' />">
 			<a href="${cancelUrl}"><fmt:message key='config.button.cancel' /></a>
		</p>
	</form>

</div>
