/**
 * Copyright 2009-2013 The Australian National University
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
package au.edu.anu.portal.portlets.sakaiconnector.helper;

import java.util.List;

import au.edu.anu.portal.portlets.sakaiconnector.logic.SakaiWebServiceLogic;
import au.edu.anu.portal.portlets.sakaiconnector.models.Site;
import au.edu.anu.portal.portlets.sakaiconnector.models.Tool;

/**
 * This is a static cover for the logic class, used until we convert to Spring.
 * 
 * @author Steve Swinsburg (steve.swinsburg@anu.edu.au)
 *
 */
public class SakaiWebServiceHelper {

	
	public static String getRemoteUserIdForUser(SakaiWebServiceLogic logic, String eid) {
		return logic.getRemoteUserIdForUser(eid);
	}
	
	public static List<Site> getAllSitesForUser(SakaiWebServiceLogic logic, String eid) {
		return logic.getAllSitesForUser(eid);
	}
	
	public static List<Tool> getToolsForSite(SakaiWebServiceLogic logic, String siteId, String eid) {
		return logic.getToolsForSite(siteId, eid);
	}
	
}
