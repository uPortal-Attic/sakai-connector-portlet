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
package au.edu.anu.portal.portlets.sakaiconnector.support;

import lombok.extern.apachecommons.CommonsLog;

import org.apache.commons.lang.StringUtils;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.jaxws.endpoint.dynamic.JaxWsDynamicClientFactory;

/**
 * A set of services for making Web Service calls
 *
 * @author Steve Swinsburg (steve.swinsburg@anu.edu.au)
 *
 */
@CommonsLog
public class WebServiceSupport {

	/**
	 * Make a web service call to the given endpoint, calling the method and using the params supplied
	 * @param endpoint	wsdl url
	 * @param method	method to call
	 * @param params	Array of params:
	 *  1. Must be in order required to be sent
	 * 	 * @return the response, or null if any exception is thrown.
	 */
	public static String call(String endpoint, String method, Object[] params) {
		
		JaxWsDynamicClientFactory dcf = JaxWsDynamicClientFactory.newInstance();
		
		try {
			Client client = dcf.createClient(endpoint);
			Object[]  returnVals = client.invoke(method, params);
			//extract returned value. getting 1st value as sakai ws calls returns only one value.
			if(returnVals!=null && returnVals.length>0)
				return (String)returnVals[0];
		}
		catch (Exception e) {
			//e.printStackTrace();
			log.error("A connection error occurred: " + e.getClass() + ": " + e.getMessage());
		}
		return null;
	}
	
}
