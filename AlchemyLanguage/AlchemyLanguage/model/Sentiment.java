/**
 * Copyright 2015 IBM Corp. All Rights Reserved.
 * <p/>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p/>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p/>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.ibm.watson.developer_cloud.alchemy.v1.model;

import com.google.gson.annotations.SerializedName;
import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyLanguage;
import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * Sentiment returned by the {@link AlchemyLanguage} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class Sentiment extends GenericModel {
	
    /**
	 * Sentiment type enumeration.
	 */
	public enum SentimentType {
		
		/** negative sentiment. */
		@SerializedName("negative")	NEGATIVE,
		
		/** neutral sentiment. */
		@SerializedName("neutral")	NEUTRAL,
		
		/** positive sentiment. */
		@SerializedName("positive") POSITIVE
	}
	
	/** The mixed. */
    private String mixed;

	/** The score. */
    private Double score;

	/** The sentiment type. */
    private SentimentType type;
	
    /**
     * Gets the mixed.
     *
     * @return the mixed
     */
	public String getMixed() {
		return mixed;
	}

    /**
     * Gets the score.
     *
     * @return the score
     */
    public Double getScore() {
        return score;
    }

    /**
     * Gets the type.
     *
     * @return     The type
     */
    public SentimentType getType() {
        return type;
    }

    /**
     * Sets the mixed.
     *
     * @param mixed the mixed to set
     */
	public void setMixed(String mixed) {
		this.mixed = mixed;
	}

    /**
     * Sets the score.
     *
     * @param score the new score
     */
    public void setScore(Double score) {
        this.score = score;
    }

    /**
     * Sets the type.
     *
     * @param type     The type
     */
    public void setType(SentimentType type) {
        this.type = type;
    }
}
