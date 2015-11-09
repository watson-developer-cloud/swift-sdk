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
import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * Subject-Action-Object(SAO) relation returned by the {@link AlchemyLanguage} service.
 * 
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class SAORelation extends GenericModel {

	/**
	 * The Class Action.
	 */
	public static class Action extends GenericModel {

		/**
		 * The Class Verb.
		 */
		public static class Verb extends GenericModel {

			/** The negated. */
			private Integer negated;

			/** The tense. */
			private String tense;

			/** The text. */
			private String text;

			/**
			 * Gets the negated.
			 * 
			 * @return the negated
			 */
			public Integer getNegated() {
				return negated;
			}

			/**
			 * Gets the tense.
			 * 
			 * @return The tense
			 */
			public String getTense() {
				return tense;
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
			 * Sets the negated.
			 * 
			 * @param negated
			 *            the negated to set
			 */
			public void setNegated(Integer negated) {
				this.negated = negated;
			}

			/**
			 * Sets the tense.
			 * 
			 * @param tense
			 *            The tense
			 */
			public void setTense(String tense) {
				this.tense = tense;
			}

			/**
			 * Sets the text.
			 * 
			 * @param text
			 *            The text
			 */
			public void setText(String text) {
				this.text = text;
			}

			/**
			 * With text.
			 * 
			 * @param text
			 *            the text
			 * @return the verb
			 */
			public Verb withText(String text) {
				this.text = text;
				return this;
			}

		}

		/** The lemmatized. */
		private String lemmatized;

		/** The text. */
		private String text;

		/** The verb. */
		private Verb verb;

		/**
		 * Gets the lemmatized.
		 * 
		 * @return The lemmatized
		 */
		public String getLemmatized() {
			return lemmatized;
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
		 * Gets the verb.
		 * 
		 * @return The verb
		 */
		public Verb getVerb() {
			return verb;
		}

		/**
		 * Sets the lemmatized.
		 * 
		 * @param lemmatized
		 *            The lemmatized
		 */
		public void setLemmatized(String lemmatized) {
			this.lemmatized = lemmatized;
		}

		/**
		 * Sets the text.
		 * 
		 * @param text
		 *            The text
		 */
		public void setText(String text) {
			this.text = text;
		}

		/**
		 * Sets the verb.
		 * 
		 * @param verb
		 *            The verb
		 */
		public void setVerb(Verb verb) {
			this.verb = verb;
		}

		/**
		 * With lemmatized.
		 * 
		 * @param lemmatized
		 *            the lemmatized
		 * @return the action
		 */
		public Action withLemmatized(String lemmatized) {
			this.lemmatized = lemmatized;
			return this;
		}

		/**
		 * With text.
		 * 
		 * @param text
		 *            the text
		 * @return the action
		 */
		public Action withText(String text) {
			this.text = text;
			return this;
		}
	}

	/**
	 * The Class RelationObject.
	 */
	public static class RelationObject extends GenericModel {

		/** The entity. */
		private Entity entity;

		/** The keywords. */
		private List<Keyword> keywords;

		/** The sentiment. */
		private Sentiment sentiment;

		/** The sentiment. */
		private Sentiment sentimentFromSubject;

		/** The text. */
		private String text;

		/**
		 * Gets the entity.
		 * 
		 * @return the entity
		 */
		public Entity getEntity() {
			return entity;
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
		 * Gets the sentiment.
		 * 
		 * @return The sentiment
		 */
		public Sentiment getSentiment() {
			return sentiment;
		}

		/**
		 * Gets the sentiment from subject.
		 * 
		 * @return the sentimentFromSubject
		 */
		public Sentiment getSentimentFromSubject() {
			return sentimentFromSubject;
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
		 * Sets the entity.
		 * 
		 * @param entity
		 *            the new entity
		 */
		public void setEntity(Entity entity) {
			this.entity = entity;
		}

		/**
		 * Sets the keywords.
		 * 
		 * @param keywords
		 *            the keywords to set
		 */
		public void setKeywords(List<Keyword> keywords) {
			this.keywords = keywords;
		}

		/**
		 * Sets the sentiment.
		 * 
		 * @param sentiment
		 *            The sentiment
		 */
		public void setSentiment(Sentiment sentiment) {
			this.sentiment = sentiment;
		}

		/**
		 * Sets the sentiment from subject.
		 * 
		 * @param sentimentFromSubject
		 *            the sentimentFromSubject to set
		 */
		public void setSentimentFromSubject(Sentiment sentimentFromSubject) {
			this.sentimentFromSubject = sentimentFromSubject;
		}

		/**
		 * Sets the text.
		 * 
		 * @param text
		 *            The text
		 */
		public void setText(String text) {
			this.text = text;
		}

	}

	/**
	 * The Subject relation.
	 */
	public static class Subject extends GenericModel {

		/** The entities. */
		private Entity entity;

		/** The keywords. */
		private List<Keyword> keywords;

		/** The sentiment. */
		private Sentiment sentiment;

		/** The text. */
		private String text;

		/**
		 * Gets the entity.
		 * 
		 * @return the entity
		 */
		public Entity getEntity() {
			return entity;
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
		 * Gets the sentiment.
		 * 
		 * @return the sentiment
		 */
		public Sentiment getSentiment() {
			return sentiment;
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
		 * Sets the entity.
		 * 
		 * @param entity
		 *            the entity to set
		 */
		public void setEntity(Entity entity) {
			this.entity = entity;
		}

		/**
		 * Sets the keywords.
		 * 
		 * @param keywords
		 *            the keywords to set
		 */
		public void setKeywords(List<Keyword> keywords) {
			this.keywords = keywords;
		}

		/**
		 * Sets the sentiment.
		 * 
		 * @param sentiment
		 *            the sentiment to set
		 */
		public void setSentiment(Sentiment sentiment) {
			this.sentiment = sentiment;
		}

		/**
		 * Sets the text.
		 * 
		 * @param text
		 *            the text to set
		 */
		public void setText(String text) {
			this.text = text;
		}

	}

	/** The action. */
	private Action action;

	/** The object. */
	private RelationObject object;

	/** The sentence. */
	private String sentence;

	/** The subject. */
	private Subject subject;

	/**
	 * Gets the action.
	 * 
	 * @return The action
	 */
	public Action getAction() {
		return action;
	}

	/**
	 * Gets the object.
	 * 
	 * @return The object
	 */
	public RelationObject getObject() {
		return object;
	}

	/**
	 * Gets the sentence.
	 * 
	 * @return The sentence
	 */
	public String getSentence() {
		return sentence;
	}

	/**
	 * Gets the subject.
	 * 
	 * @return The subject
	 */
	public Subject getSubject() {
		return subject;
	}

	/**
	 * Sets the action.
	 * 
	 * @param action
	 *            The action
	 */
	public void setAction(Action action) {
		this.action = action;
	}

	/**
	 * Sets the object.
	 * 
	 * @param object
	 *            The object
	 */
	public void setObject(RelationObject object) {
		this.object = object;
	}

	/**
	 * Sets the sentence.
	 * 
	 * @param sentence
	 *            The sentence
	 */
	public void setSentence(String sentence) {
		this.sentence = sentence;
	}

	/**
	 * Sets the subject.
	 * 
	 * @param subject
	 *            The subject
	 */
	public void setSubject(Subject subject) {
		this.subject = subject;
	}

}
