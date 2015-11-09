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

import java.util.Date;

import com.google.gson.annotations.JsonAdapter;
import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyLanguage;
import com.ibm.watson.developer_cloud.alchemy.v1.util.PublicationDateTypeAdapter;
import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * PublicationDate returned by the {@link AlchemyLanguage} service.
 * 
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
@JsonAdapter(PublicationDateTypeAdapter.class)
public class PublicationDate extends GenericModel {

	/** The confident. */
	private Boolean confident;

	/** The date. */
	private Date date;

	/**
	 * Gets the confident.
	 *
	 * @return the confident
	 */
	public Boolean getConfident() {
		return confident;
	}

	/**
	 * Gets the date.
	 *
	 * @return the date
	 */
	public Date getDate() {
		return date;
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
	 * Sets the date.
	 *
	 * @param date the date to set
	 */
	public void setDate(Date date) {
		this.date = date;
	}

}
