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

import com.google.gson.annotations.JsonAdapter;
import com.ibm.watson.developer_cloud.alchemy.v1.util.TaxonomyTypeAdapter;
import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * Taxonomy returned by the {@link AlchemyLanguage} service.
 * 
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
/**
 * @author German Attanasio Ruiz (germanatt@us.ibm.com)
 *
 */
@JsonAdapter(TaxonomyTypeAdapter.class)
public class Taxonomy extends GenericModel {

	/** The confident. */
	private Boolean confident;

	/** The label. */
	private String label;

	/** The score. */
	private Double score;

	/**
	 * Gets the confident.
	 *
	 * @return the confident
	 */
	public Boolean getConfident() {
		return confident;
	}

	/**
	 * Gets the label.
	 * 
	 * @return The label
	 */
	public String getLabel() {
		return label;
	}

	/**
	 * Gets the score.
	 * 
	 * @return The score
	 */
	public Double getScore() {
		return score;
	}

	/**
	 * Sets the confident.
	 *
	 * @param confident the confident to set
	 */
	public void setConfident(Boolean confident) {
		this.confident = confident;
	}

	/**
	 * Sets the label.
	 * 
	 * @param label
	 *            The label
	 */
	public void setLabel(String label) {
		this.label = label;
	}

	/**
	 * Sets the score.
	 * 
	 * @param score
	 *            The score
	 */
	public void setScore(Double score) {
		this.score = score;
	}

}
