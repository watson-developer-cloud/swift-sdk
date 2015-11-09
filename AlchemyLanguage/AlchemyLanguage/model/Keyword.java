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

import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyLanguage;
import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * Keyword returned by the {@link AlchemyLanguage} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class Keyword extends GenericModel {

    /** The knowledge graph. */
    private KnowledgeGraph knowledgeGraph;

    /** The relevance. */
    private Double relevance;

    /** The sentiment. */
    private Sentiment sentiment;

    /** The text. */
    private String text;
    
    /**
     * Gets the knowledge graph.
     *
     * @return the knowledgeGraph
     */
	public KnowledgeGraph getKnowledgeGraph() {
		return knowledgeGraph;
	}

	/**
     * Gets the relevance.
     *
     * @return     The relevance
     */
    public Double getRelevance() {
        return relevance;
    }

	/**
     * Gets the sentiment.
     *
     * @return     The sentiment
     */
    public Sentiment getSentiment() {
        return sentiment;
    }

    /**
     * Gets the text.
     *
     * @return     The text
     */
    public String getText() {
        return text;
    }

    /**
	 * Sets the knowledge graph.
	 *
	 * @param knowledgeGraph the knowledgeGraph to set
	 */
	public void setKnowledgeGraph(KnowledgeGraph knowledgeGraph) {
		this.knowledgeGraph = knowledgeGraph;
	}

    /**
     * Sets the relevance.
     *
     * @param relevance     The relevance
     */
    public void setRelevance(Double relevance) {
        this.relevance = relevance;
    }

    /**
     * Sets the sentiment.
     *
     * @param sentiment     The sentiment
     */
    public void setSentiment(Sentiment sentiment) {
        this.sentiment = sentiment;
    }

    /**
     * Sets the text.
     *
     * @param text     The text
     */
    public void setText(String text) {
        this.text = text;
    }

}
