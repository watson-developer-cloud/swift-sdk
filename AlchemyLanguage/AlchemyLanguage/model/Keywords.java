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
 * Keywords returned by the {@link AlchemyLanguage} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class Keywords extends AlchemyLanguageGenericModel {

    /** The keywords. */
    private List<Keyword> keywords;

    /** The text. */
    private String text;
    
    
    /**
     * Gets the keywords.
     *
     * @return The keywords
     */
    public List<Keyword> getKeywords() {
        return keywords;
    }

	/**
     * Gets the text.
     *
     * @return the text
     */
	public String getText() {
		return text;
	}

	/**
     * Sets the keywords.
     *
     * @param keywords The keywords
     */
    public void setKeywords(List<Keyword> keywords) {
        this.keywords = keywords;
    }

    /**
	 * Sets the text.
	 *
	 * @param text the text to set
	 */
	public void setText(String text) {
		this.text = text;
	}

    /**
     * With keywords.
     *
     * @param keywords the keywords
     * @return the keywords
     */
    public Keywords withKeywords(List<Keyword> keywords) {
        this.keywords = keywords;
        return this;
    }

}