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

import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyVision;
import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * Identity by the {@link AlchemyVision} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class Identity extends GenericModel {

    /** The disambiguated. */
    private DisambiguatedLinks disambiguated;

    /** The knowledge graph. */
    private KnowledgeGraph knowledgeGraph;

    /** The name. */
    private String name;

    /** The score. */
    private String score;

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
     * Gets the name.
     *
     * @return The name
     */
    public String getName() {
        return name;
    }

    /**
     * Gets the score.
     *
     * @return The score
     */
    public String getScore() {
        return score;
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
     * Sets the name.
     *
     * @param name The name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Sets the score.
     *
     * @param score The score
     */
    public void setScore(String score) {
        this.score = score;
    }
}
