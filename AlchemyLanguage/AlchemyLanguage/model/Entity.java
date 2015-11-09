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

import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyDataNews;

/**
 * Entity returned by the {@link AlchemyDataNews} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class Entity {

    /** The count. */
    private Integer count;

    /** The disambiguated. */
    private DisambiguatedLinks disambiguated;

    /** The knowledge graph. */
    private KnowledgeGraph knowledgeGraph;

    /** The quotations. */
    //TODO: list of Object??
    private List<Quotation> quotations;

    /** The relevance. */
    private Double relevance;

    /** The sentiment. */
    private Sentiment sentiment;

    /** The text. */
    private String text;

    /** The type. */
    private String type;


    /**
     * Gets the count.
     *
     * @return The count
     */
    public int getCount() {
        return count;
    }

    /**
     * Gets the disambiguated.
     *
     * @return The disambiguated
     */
    public DisambiguatedLinks getDisambiguated() {
        return disambiguated;
    }

    /**
     * Gets the knowledge graph.
     *
     * @return The knowledgeGraph
     */
    public KnowledgeGraph getKnowledgeGraph() {
        return knowledgeGraph;
    }

    /**
     * Gets the quotations.
     *
     * @return The quotations
     */
    public List<Quotation> getQuotations() {
        return quotations;
    }

    /**
     * Gets the relevance.
     *
     * @return The relevance
     */
    public double getRelevance() {
        return relevance;
    }

    /**
     * Gets the sentiment.
     *
     * @return The sentiment
     */
    public Sentiment getSentiment() {
        return sentiment;
    }

    /**
     * Gets the text.
     *
     * @return The text
     */
    public String getText() {
        return text;
    }

    /**
     * Gets the type.
     *
     * @return The type
     */
    public String getType() {
        return type;
    }

    /**
     * Sets the count.
     *
     * @param count The count
     */
    public void setCount(int count) {
        this.count = count;
    }

    /**
     * Sets the disambiguated.
     *
     * @param disambiguated The disambiguated
     */
    public void setDisambiguated(DisambiguatedLinks disambiguated) {
        this.disambiguated = disambiguated;
    }

    /**
     * Sets the knowledge graph.
     *
     * @param knowledgeGraph The knowledgeGraph
     */
    public void setKnowledgeGraph(KnowledgeGraph knowledgeGraph) {
        this.knowledgeGraph = knowledgeGraph;
    }

    /**
     * Sets the quotations.
     *
     * @param quotations The quotations
     */
    public void setQuotations(List<Quotation> quotations) {
        this.quotations = quotations;
    }

    /**
     * Sets the relevance.
     *
     * @param relevance The relevance
     */
    public void setRelevance(double relevance) {
        this.relevance = relevance;
    }

    /**
     * Sets the sentiment.
     *
     * @param sentiment The sentiment
     */
    public void setSentiment(Sentiment sentiment) {
        this.sentiment = sentiment;
    }

    /**
     * Sets the text.
     *
     * @param text The text
     */
    public void setText(String text) {
        this.text = text;
    }

    /**
     * Sets the type.
     *
     * @param type The type
     */
    public void setType(String type) {
        this.type = type;
    }
}
