/**
 * Copyright 2015 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.ibm.watson.developer_cloud.alchemy.v1.model;

import java.util.List;

import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyLanguage;

/**
 * Microformats returned by the {@link AlchemyLanguage} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class Microformats extends AlchemyLanguageGenericModel {

    /** The microformats. */
    private List<Microformat> microformats;

	/**
	 * Gets the microformats.
	 *
	 * @return the microformats
	 */
	public List<Microformat> getMicroformats() {
		return microformats;
	}

	/**
	 * Sets the microformats.
	 *
	 * @param microformats the microformats to set
	 */
	public void setMicroformats(List<Microformat> microformats) {
		this.microformats = microformats;
	}

}
