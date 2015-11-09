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

import java.util.List;

import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * Disambiguated returned by the {@link AlchemyLanguage} service.
 * 
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
/**
 * @author German Attanasio Ruiz (germanatt@us.ibm.com)
 *
 */
public class DisambiguatedLinks extends GenericModel {

	/**
	 * The link to the US Census for the disambiguated entity. Note: Provided only for
	 * entities that exist in this linked data-set.
	 */
	private String census;

	/**
	 * The cia link to the CIA World Factbook for the disambiguated entity. Note: Provided
	 * only for entities that exist in this linked data-set.
	 */
	private String ciaFactbook;

	/**
	 * The link to CrunchBase for the disambiguated entity. Note: Provided only for
	 * entities that exist in CrunchBase.
	 */
	private String crunchbase;

	/**
	 * The link to DBpedia for the disambiguated entity. Note: Provided only for entities
	 * that exist in this linked data-set.
	 */
	private String dbpedia;

	/**
	 * The link to Freebase for the disambiguated entity. Note: Provided only for entities
	 * that exist in this linked data-set.
	 */
	private String freebase;

	/** The geographic coordinates. */
	private String geo;

	/**
	 * The link to Geonames for the disambiguated entity. Note: Provided only for entities
	 * that exist in this linked data-set.
	 */
	private String geonames;

	/**
	 * The music link to MusicBrainz for the disambiguated entity. Note: Provided only for
	 * entities that exist in this linked data-set.
	 */
	private String musicBrainz;

	/** The entity name. */
	private String name;

	/**
	 * The link to OpenCyc for the disambiguated entity. Note: Provided only for entities
	 * that exist in this linked data-set.
	 */
	private String opencyc;

	/**  The disambiguated entity subType. */
	private List<String> subType;

	/**
	 * The link to UMBEL for the disambiguated entity. Note: Provided only for entities
	 * that exist in this linked data-set.
	 */
	private String umbel;

	/** The website. */
	private String website;

	/**
	 * The link to YAGO for the disambiguated entity. Note: Provided only for entities
	 * that exist in this linked data-set.
	 */
	private String yago;

	/**
	 * Gets the census.
	 *
	 * @return the census
	 */
	public String getCensus() {
		return census;
	}

	/**
	 * Gets the cia factbook.
	 *
	 * @return the ciaFactbook
	 */
	public String getCiaFactbook() {
		return ciaFactbook;
	}

	/**
	 * Gets the crunchbase.
	 *
	 * @return the crunchbase
	 */
	public String getCrunchbase() {
		return crunchbase;
	}

	/**
	 * Gets the dbpedia.
	 * 
	 * @return The dbpedia
	 */
	public String getDbpedia() {
		return dbpedia;
	}

	/**
	 * Gets the freebase.
	 * 
	 * @return The freebase
	 */
	public String getFreebase() {
		return freebase;
	}

	/**
	 * Gets the geo.
	 *
	 * @return the geo
	 */
	public String getGeo() {
		return geo;
	}

	/**
	 * Gets the geonames.
	 *
	 * @return the geonames
	 */
	public String getGeonames() {
		return geonames;
	}

	/**
	 * Gets the music brainz.
	 *
	 * @return the musicBrainz
	 */
	public String getMusicBrainz() {
		return musicBrainz;
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
	 * Gets the opencyc.
	 * 
	 * @return the opencyc
	 */
	public String getOpencyc() {
		return opencyc;
	}

	/**
	 * Gets the sub type.
	 * 
	 * @return The subType
	 */
	public List<String> getSubType() {
		return subType;
	}

	/**
	 * Gets the umbel.
	 *
	 * @return the umbel
	 */
	public String getUmbel() {
		return umbel;
	}

	/**
	 * Gets the website.
	 * 
	 * @return The website
	 */
	public String getWebsite() {
		return website;
	}

	/**
	 * Gets the yago.
	 * 
	 * @return the yago
	 */
	public String getYago() {
		return yago;
	}

	/**
	 * Sets the census.
	 *
	 * @param census the census to set
	 */
	public void setCensus(String census) {
		this.census = census;
	}

	/**
	 * Sets the cia factbook.
	 *
	 * @param ciaFactbook the ciaFactbook to set
	 */
	public void setCiaFactbook(String ciaFactbook) {
		this.ciaFactbook = ciaFactbook;
	}

	/**
	 * Sets the crunchbase.
	 *
	 * @param crunchbase the crunchbase to set
	 */
	public void setCrunchbase(String crunchbase) {
		this.crunchbase = crunchbase;
	}

	/**
	 * Sets the dbpedia.
	 * 
	 * @param dbpedia
	 *            The dbpedia
	 */
	public void setDbpedia(String dbpedia) {
		this.dbpedia = dbpedia;
	}

	/**
	 * Sets the freebase.
	 * 
	 * @param freebase
	 *            The freebase
	 */
	public void setFreebase(String freebase) {
		this.freebase = freebase;
	}

	/**
	 * Sets the geo.
	 *
	 * @param geo the geo to set
	 */
	public void setGeo(String geo) {
		this.geo = geo;
	}

	/**
	 * Sets the geonames.
	 *
	 * @param geonames the geonames to set
	 */
	public void setGeonames(String geonames) {
		this.geonames = geonames;
	}

	/**
	 * Sets the music brainz.
	 *
	 * @param musicBrainz the musicBrainz to set
	 */
	public void setMusicBrainz(String musicBrainz) {
		this.musicBrainz = musicBrainz;
	}

	/**
	 * Sets the name.
	 * 
	 * @param name
	 *            The name
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * Sets the opencyc.
	 * 
	 * @param opencyc
	 *            the opencyc to set
	 */
	public void setOpencyc(String opencyc) {
		this.opencyc = opencyc;
	}

	/**
	 * Sets the sub type.
	 * 
	 * @param subType
	 *            The subType
	 */
	public void setSubType(List<String> subType) {
		this.subType = subType;
	}

	/**
	 * Sets the umbel.
	 *
	 * @param umbel the umbel to set
	 */
	public void setUmbel(String umbel) {
		this.umbel = umbel;
	}

	/**
	 * Sets the website.
	 * 
	 * @param website
	 *            The website
	 */
	public void setWebsite(String website) {
		this.website = website;
	}

	/**
	 * Sets the yago.
	 * 
	 * @param yago
	 *            the yago to set
	 */
	public void setYago(String yago) {
		this.yago = yago;
	}
}
