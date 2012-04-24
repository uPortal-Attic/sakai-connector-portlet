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
package au.edu.anu.portal.portlets.sakaiconnector.models;

import lombok.Data;
import lombok.NoArgsConstructor;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

/**
 * An object that holds information about a site, retrieved from the web service call
 * 
 * @author Steve Swinsburg (steve.swinsburg@anu.edu.au)
 *
 */

@NoArgsConstructor
@Data
@Root(name="item")
public class Site {

	@Element(name="siteId")
	private String id;
	
	@Element(name="siteTitle")
	private String title;
	
}
