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
 * ImageFace returned by {@link AlchemyVision#recognizeFaces(java.util.Map)}.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class ImageFace extends GenericModel {

	/**
	 * Face Age range.
	 */
	public static class AgeRange extends GenericModel {

		/** The age range. */
		private String ageRange;

		/** The score. */
		private Double score;

		/**
		 * Gets the age range.
		 * 
		 * @return The ageRange
		 */
		public String getAgeRange() {
			return ageRange;
		}

		/**
		 * Gets the score.
		 * 
		 * @return The score
		 */
		public Double getScore() {
			return score;
		}

		/**
		 * Sets the age range.
		 * 
		 * @param ageRange The ageRange
		 */
		public void setAgeRange(String ageRange) {
			this.ageRange = ageRange;
		}

		/**
		 * Sets the score.
		 * 
		 * @param score The score
		 */
		public void setScore(Double score) {
			this.score = score;
		}
	}

	/**
	 * Face gender.
	 */
	public static class Gender extends GenericModel {
		
		/** The gender. */
		private String gender;

		/** The score. */
		private Double score;

		/**
		 * Gets the gender.
		 *
		 * @return The gender
		 */
		public String getGender() {
			return gender;
		}

		/**
		 * Gets the score.
		 *
		 * @return The score
		 */
		public Double getScore() {
			return score;
		}

		/**
		 * Sets the gender.
		 *
		 * @param gender The gender
		 */
		public void setGender(String gender) {
			this.gender = gender;
		}

		/**
		 * Sets the score.
		 *
		 * @param score The score
		 */
		public void setScore(Double score) {
			this.score = score;
		}

	}

	/** The age. */
	private AgeRange age;

	/** The gender. */
	private Gender gender;

	/** The height. */
	private String height;

	/** The identity. */
	private Identity identity;

	/** The position x. */
	private String positionX;

	/** The position y. */
	private String positionY;

	/** The width. */
	private String width;

	/**
	 * Gets the age.
	 *
	 * @return The age
	 */
	public AgeRange getAge() {
		return age;
	}

	/**
	 * Gets the gender.
	 *
	 * @return The gender
	 */
	public Gender getGender() {
		return gender;
	}

	/**
	 * Gets the height.
	 *
	 * @return The height
	 */
	public String getHeight() {
		return height;
	}

	/**
	 * Gets the identity.
	 *
	 * @return The identity
	 */
	public Identity getIdentity() {
		return identity;
	}

	/**
	 * Gets the position x.
	 *
	 * @return The positionX
	 */
	public String getPositionX() {
		return positionX;
	}

	/**
	 * Gets the position y.
	 *
	 * @return The positionY
	 */
	public String getPositionY() {
		return positionY;
	}

	/**
	 * Gets the width.
	 *
	 * @return The width
	 */
	public String getWidth() {
		return width;
	}

	/**
	 * Sets the age.
	 *
	 * @param age            The age
	 */
	public void setAge(AgeRange age) {
		this.age = age;
	}

	/**
	 * Sets the gender.
	 *
	 * @param gender            The gender
	 */
	public void setGender(Gender gender) {
		this.gender = gender;
	}

	/**
	 * Sets the height.
	 *
	 * @param height            The height
	 */
	public void setHeight(String height) {
		this.height = height;
	}

	/**
	 * Sets the identity.
	 *
	 * @param identity            The identity
	 */
	public void setIdentity(Identity identity) {
		this.identity = identity;
	}

	/**
	 * Sets the position x.
	 *
	 * @param positionX            The positionX
	 */
	public void setPositionX(String positionX) {
		this.positionX = positionX;
	}

	/**
	 * Sets the position y.
	 *
	 * @param positionY            The positionY
	 */
	public void setPositionY(String positionY) {
		this.positionY = positionY;
	}

	/**
	 * Sets the width.
	 *
	 * @param width            The width
	 */
	public void setWidth(String width) {
		this.width = width;
	}
}
