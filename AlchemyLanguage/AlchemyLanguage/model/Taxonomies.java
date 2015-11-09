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
 * Taxonomies returned by the {@link AlchemyLanguage} service.
 * 
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class Taxonomies extends AlchemyLanguageGenericModel {

	/** The taxonomy. */
	private List<Taxonomy> taxonomy;

	/**
	 * Gets the taxonomy.
	 * 
	 * @return The taxonomy
	 */
	public List<Taxonomy> getTaxonomy() {
		return taxonomy;
	}

	/**
	 * Sets the taxonomy.
	 * 
	 * @param taxonomy
	 *            The taxonomy
	 */
	public void setTaxonomy(List<Taxonomy> taxonomy) {
		this.taxonomy = taxonomy;
	}

	/**
	 * With taxonomy.
	 * 
	 * @param taxonomy
	 *            the taxonomy
	 * @return the taxonomy
	 */
	public Taxonomies withTaxonomy(List<Taxonomy> taxonomy) {
		this.taxonomy = taxonomy;
		return this;
	}
}
