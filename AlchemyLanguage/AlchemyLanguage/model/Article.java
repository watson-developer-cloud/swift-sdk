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
import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyDataNews;
import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * Url by the {@link AlchemyDataNews} service.
 * 
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class Article extends GenericModel {

	/**
	 * EnrichedTitle returned by the {@link AlchemyDataNews} service.
	 * 
	 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
	 */
	public static class EnrichedTitle extends GenericModel {

		/** The concepts. */
		private List<Concept> concepts;

		/** The entities. */
		private List<Entity> entities;

		/** The sentiment. */
		@SerializedName("docSentiment")
		private Sentiment sentiment;

		/** The taxonomy. */
		private List<Taxonomy> taxonomy;

		/**
		 * Gets the concepts.
		 * 
		 * @return The concepts
		 */
		public List<Concept> getConcepts() {
			return concepts;
		}

		/**
		 * Gets the entities.
		 * 
		 * @return The entities
		 */
		public List<Entity> getEntities() {
			return entities;
		}

		/**
		 * Gets the taxonomy.
		 * 
		 * @return The taxonomy
		 */
		public List<Taxonomy> getTaxonomy() {
			return taxonomy;
		}

		/**
		 * Sets the concepts.
		 * 
		 * @param concepts
		 *            The concepts
		 */
		public void setConcepts(List<Concept> concepts) {
			this.concepts = concepts;
		}

		/**
		 * Sets the entities.
		 * 
		 * @param entities
		 *            The entities
		 */
		public void setEntities(List<Entity> entities) {
			this.entities = entities;
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
	}

	/** The author. */
	private String author;

	/** The enriched title. */
	private EnrichedTitle enrichedTitle;

	/** The publication date. */
	private PublicationDate publicationDate;

	/** The title. */
	private String title;

	/** The url. */
	private String url;

	/**
	 * Gets the author.
	 *
	 * @return The author
	 */
	public String getAuthor() {
		return author;
	}

	/**
	 * Gets the enriched title.
	 *
	 * @return The enrichedTitle
	 */
	public EnrichedTitle getEnrichedTitle() {
		return enrichedTitle;
	}

	/**
	 * Gets the publication date.
	 *
	 * @return The publicationDate
	 */
	public PublicationDate getPublicationDate() {
		return publicationDate;
	}

	/**
	 * Gets the title.
	 *
	 * @return The title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * Gets the url.
	 *
	 * @return The url
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * Sets the author.
	 *
	 * @param author            The author
	 */
	public void setAuthor(String author) {
		this.author = author;
	}

	/**
	 * Sets the enriched title.
	 *
	 * @param enrichedTitle            The enrichedTitle
	 */
	public void setEnrichedTitle(EnrichedTitle enrichedTitle) {
		this.enrichedTitle = enrichedTitle;
	}

	/**
	 * Sets the publication date.
	 *
	 * @param publicationDate            The publicationDate
	 */
	public void setPublicationDate(PublicationDate publicationDate) {
		this.publicationDate = publicationDate;
	}

	/**
	 * Sets the title.
	 *
	 * @param title            The title
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * Sets the url.
	 *
	 * @param url            The url
	 */
	public void setUrl(String url) {
		this.url = url;
	}
}
