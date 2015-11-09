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

import com.google.gson.annotations.SerializedName;
import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyLanguage;

/**
 * Combined returned by the {@link AlchemyLanguage} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class CombinedResults extends AlchemyLanguageGenericModel  {
	
    /** The author. */
    private String author;
    
    /** The concepts. */
    private List<Concept> concepts;
    
    /** The entities. */
    private List<Entity> entities;
	
	/** The feeds. */
    private List<Feed> feeds;
	
	/** The image. */
    private String image;
	
	/** The image keywords. */
    private List<Keyword> imageKeywords;
	
	/** The keywords. */
	private List<Keyword> keywords;
	
	/** The publication date. */
    private PublicationDate publicationDate;
	
	/** The relations. */
    private List<SAORelation> relations;
	
	/** The doc sentiment. */
	@SerializedName("docSentiment")
    private Sentiment sentiment;
	
	/** The taxonomy. */
    private List<Taxonomy> taxonomy;
	
	/** The title. */
    private String title;
	
	/**
	 * Gets the author.
	 *
	 * @return the author
	 */
	public String getAuthor() {
		return author;
	}
	
	/**
	 * Gets the concepts.
	 *
	 * @return the concepts
	 */
	public List<Concept> getConcepts() {
		return concepts;
	}
	
	/**
	 * Gets the entities.
	 *
	 * @return the entities
	 */
	public List<Entity> getEntities() {
		return entities;
	}
	
	/**
	 * Gets the feeds.
	 *
	 * @return the feeds
	 */
	public List<Feed> getFeeds() {
		return feeds;
	}
	
	/**
	 * Gets the image.
	 *
	 * @return the image
	 */
	public String getImage() {
		return image;
	}
	
	/**
	 * Gets the image keywords.
	 *
	 * @return the imageKeywords
	 */
	public List<Keyword> getImageKeywords() {
		return imageKeywords;
	}
	
	/**
     * Gets the keywords.
     *
     * @return the keywords
     */
	public List<Keyword> getKeywords() {
		return keywords;
	}
	
	/**
	 * Gets the publication date.
	 *
	 * @return the publicationDate
	 */
	public PublicationDate getPublicationDate() {
		return publicationDate;
	}
	
	/**
	 * Gets the relations.
	 *
	 * @return the relations
	 */
	public List<SAORelation> getRelations() {
		return relations;
	}
	
	/**
	 * Gets the sentiment.
	 *
	 * @return the sentiment
	 */
	public Sentiment getSentiment() {
		return sentiment;
	}
	
	/**
	 * Gets the taxonomy.
	 *
	 * @return the taxonomy
	 */
	public List<Taxonomy> getTaxonomy() {
		return taxonomy;
	}
	
	/**
	 * Gets the title.
	 *
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}
	
	/**
	 * Sets the author.
	 *
	 * @param author the author to set
	 */
	public void setAuthor(String author) {
		this.author = author;
	}
	
	/**
	 * Sets the concepts.
	 *
	 * @param concepts the concepts to set
	 */
	public void setConcepts(List<Concept> concepts) {
		this.concepts = concepts;
	}
	
	/**
	 * Sets the entities.
	 *
	 * @param entities the entities to set
	 */
	public void setEntities(List<Entity> entities) {
		this.entities = entities;
	}
    
    /**
	 * Sets the feeds.
	 *
	 * @param feeds the feeds to set
	 */
	public void setFeeds(List<Feed> feeds) {
		this.feeds = feeds;
	}
    
    /**
	 * Sets the image.
	 *
	 * @param image the image to set
	 */
	public void setImage(String image) {
		this.image = image;
	}
    
    /**
	 * Sets the image keywords.
	 *
	 * @param imageKeywords the imageKeywords to set
	 */
	public void setImageKeywords(List<Keyword> imageKeywords) {
		this.imageKeywords = imageKeywords;
	}
    
    /**
	 * Sets the keywords.
	 *
	 * @param keywords the keywords to set
	 */
	public void setKeywords(List<Keyword> keywords) {
		this.keywords = keywords;
	}
    
    /**
	 * Sets the publication date.
	 *
	 * @param publicationDate the publicationDate to set
	 */
	public void setPublicationDate(PublicationDate publicationDate) {
		this.publicationDate = publicationDate;
	}
    
    /**
	 * Sets the relations.
	 *
	 * @param relations the relations to set
	 */
	public void setRelations(List<SAORelation> relations) {
		this.relations = relations;
	}

    /**
	 * Sets the sentiment.
	 *
	 * @param sentiment the sentiment to set
	 */
	public void setSentiment(Sentiment sentiment) {
		this.sentiment = sentiment;
	}
    
    /**
	 * Sets the taxonomy.
	 *
	 * @param taxonomy the taxonomy to set
	 */
	public void setTaxonomy(List<Taxonomy> taxonomy) {
		this.taxonomy = taxonomy;
	}
    
    /**
	 * Sets the title.
	 *
	 * @param title the title to set
	 */
	public void setTitle(String title) {
		this.title = title;
	}

}
