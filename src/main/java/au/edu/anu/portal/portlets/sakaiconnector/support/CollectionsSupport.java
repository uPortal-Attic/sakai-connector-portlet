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

import java.util.Map;

/**
 * Java.util.Collections utility class. Does a few miscellaneous tasks
 * 
 * @author Steve Swinsburg (steve.swinsburg@anu.edu.au)
 *
 */
public class CollectionsSupport {

	/**
	 * Print all key-value pairs of a map to stdout
	 * @param map
	 */
	public static void printMap(Map<?,?> map) {
		for (Map.Entry<?,?> param : map.entrySet()) {
			System.out.println(param.getKey() + ":" + param.getValue());
		}
	}
	
}
