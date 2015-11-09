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

import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * The Class Quotation.
 */
public class Quotation extends GenericModel {
	
	/** The quotation. */
	private String quotation;

	/**
	 * Gets the quotation.
	 *
	 * @return the quotation
	 */
	public String getQuotation() {
		return quotation;
	}

	/**
	 * Sets the quotation.
	 *
	 * @param quotation the quotation to set
	 */
	/**
	 * @param quotation
	 */
	public void setQuotation(String quotation) {
		this.quotation = quotation;
	}
	
}
