/**
 * Copyright 2009-2012 The Australian National University
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
package au.edu.anu.portal.portlets.sakaiconnector.logic;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.apachecommons.CommonsLog;
import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import org.apache.commons.lang.StringUtils;

import au.edu.anu.portal.portlets.sakaiconnector.models.Site;
import au.edu.anu.portal.portlets.sakaiconnector.models.Tool;
import au.edu.anu.portal.portlets.sakaiconnector.support.WebServiceSupport;
import au.edu.anu.portal.portlets.sakaiconnector.utils.Constants;
import au.edu.anu.portal.portlets.sakaiconnector.utils.XmlParser;


/**
 * This class is a simple logic class that makes the required web service calls
 * for the Basic LTI portlet to get its information.
 * 
 * It users the WebServiceSupport class for the actual web service calls.
 * 
 * A remote sessionid is stored in the cache, and checked however if any service calls fail, it is invalidated to force a new one.
 * One point to remember here is that all sessions created are for the admin user, which then gets the data on behalf of the user.
 * Sessions are cached.
 * 
 * @author Steve Swinsburg (steve.swinsburg@anu.edu.au)
 *
 */
@CommonsLog
public class SakaiWebServiceLogic {
	
	@Getter @Setter
	private String adminUsername;
	
	@Getter @Setter
	private String adminPassword;
	
	@Getter @Setter
	private String loginUrl;
	
	@Getter @Setter
	private String scriptUrl;
	
	private static final String METHOD_LOGIN="login";
	private static final String METHOD_GET_USER_ID="getUserId";
	private static final String METHOD_CHECK_SESSION="checkSession";
	private static final String METHOD_GET_ALL_SITES_FOR_USER="getAllSitesForUser";
	private static final String METHOD_GET_PAGES_AND_TOOLS_FOR_SITE="getPagesAndToolsForSite";

	private Cache cache;
	private static final String CACHE_KEY = "admin_remote_session_id"; //used for storing the session in the cache. Should not conflict with an eid (?!)

	
	/**
	 * Get the userId for a user.
	 * @return id or null if no response
	 */
	public String getRemoteUserIdForUser(final String eid) {
		
		Map<String,Map<String,String>> data = new HashMap<String,Map<String,String>>();
		data.put("sessionid", new HashMap<String,String>(){
			{
				put("value",getSession());
				put("type","string");
			}
		});
		data.put("eid", new HashMap<String,String>(){
			{
				put("value",eid);
				put("type","string");
			}
		});
		
		return WebServiceSupport.call(getScriptUrl(), METHOD_GET_USER_ID, data);
	}
	
	/**
	 * Get the XML for a list of all sites for a user, transformed to a List of Sites
	 * @return
	 */
	public List<Site> getAllSitesForUser(final String eid) {
				
		Map<String,Map<String,String>> data = new HashMap<String,Map<String,String>>();
		data.put("sessionid", new HashMap<String,String>(){
			{
				put("value",getSession());
				put("type","string");
			}
		});
		data.put("eid", new HashMap<String,String>(){
			{
				put("value",eid);
				put("type","string");
			}
		});
		
		String xml = WebServiceSupport.call(getScriptUrl(), METHOD_GET_ALL_SITES_FOR_USER, data);		
		
		return XmlParser.parseListOfSites(xml);
	}
	
	/**
	 * Get the list of tools in a site.
	 * @param siteId	siteId
	 * @return
	 */
	public List<Tool> getToolsForSite(final String siteId, final String eid) {
		
		Map<String,Map<String,String>> data = new HashMap<String,Map<String,String>>();
		data.put("sessionid", new HashMap<String,String>(){
			{
				put("value",getSession());
				put("type","string");
			}
		});
		data.put("userid", new HashMap<String,String>(){
			{
				put("value",eid);
				put("type","string");
			}
		});
		data.put("siteid", new HashMap<String,String>(){
			{
				put("value",siteId);
				put("type","string");
			}
		});
		
		String xml = WebServiceSupport.call(getScriptUrl(), METHOD_GET_PAGES_AND_TOOLS_FOR_SITE, data);		

		return XmlParser.parseListOfPages(xml);
	}
	
	
	
	
	/**
	 * Get a new session for the admin user. Don't call this directly, use getSession() instead.
	 * @return
	 */
	private String getNewAdminSession() {
		
		String session = null;
		
		//setup data to send
		Map<String,Map<String,String>> data = new HashMap<String,Map<String,String>>();
		data.put("id", new HashMap<String,String>(){
			{
				put("value",getAdminUsername());
				put("type","string");
			}
		});
		data.put("pw", new HashMap<String,String>(){
			{
				put("value",getAdminPassword());
				put("type","string");
			}
		});
		
		session = WebServiceSupport.call(getLoginUrl(), METHOD_LOGIN, data);
		
		//cache it
		addSessionToCache(session);
		
		//and return it
		return session;
	}
	
	/**
	 * Check a given session is still active. Don't call this directly, use getSession() instead.
	 * @return
	 */
	private boolean isSessionActive(final String session) {
		
		Map<String,Map<String,String>> data = new HashMap<String,Map<String,String>>();
		data.put("sessionid", new HashMap<String,String>(){
			{
				put("value",session);
				put("type","string");
			}
		});
		
		String results = WebServiceSupport.call(getScriptUrl(), METHOD_CHECK_SESSION, data);
		
		if(StringUtils.equals(results, session)) {
			return true;
		}
		
		return false;
	}
	
	
	
	
	
	public SakaiWebServiceLogic() {
		//setup cache via factory to create a singleton 
		CacheManager.create();
		cache = CacheManager.getInstance().getCache(Constants.CACHE_NAME);
	}
	
	/**
	 * Get local session, check it's still active, otherwise get a new one
	 * @return
	 */
	private String getSession() {
		
		//check session
		String session = getSessionFromCache();
		
		//if not in cache, get a new one
		if(StringUtils.isBlank(session)) {
			return getNewAdminSession();
		}
		
		//check it's still active
		if(!isSessionActive(session)){
			getNewAdminSession();
		}
		
		return session;
	}
	
	/**
	 * Get the session from the cache, otherwise return null. The session must be validated after this as it may have expired on the other end.
	 * Don't call this, call getSession instead as that method verifies the session is still active.
	 * @return	the session from the cache or null if it hasn't been created yet.
	 */
	private String getSessionFromCache() {
		
		Element element = cache.get(CACHE_KEY);
		if(element != null) {
			String session = (String) element.getObjectValue();
			log.debug("Fetching session from cache: " + session);
			return session;
		} 
		return null;
	}
	
	/**
	 * Helper to add an item to the session cache
	 * @param data
	 */
	private void addSessionToCache(String session){
		cache.put(new Element(CACHE_KEY, session));
		log.debug("Adding session to cache: " + session);
	}
	
}
