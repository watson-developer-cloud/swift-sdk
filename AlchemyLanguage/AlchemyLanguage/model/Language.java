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

import com.google.gson.annotations.SerializedName;
import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyLanguage;

/**
 * Language returned by the {@link AlchemyLanguage} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class Language extends AlchemyLanguageGenericModel {

    /** The ethnologue. */
    private String ethnologue;

    /** The iso6391. */
    @SerializedName("iso-639-1")
    private String iso6391;

    /** The iso6392. */
    @SerializedName("iso-639-2")
    private String iso6392;

    /** The iso6393. */
    @SerializedName("iso-639-3")
    private String iso6393;

    /** The native speakers. */
    @SerializedName("native-speakers")
    private String nativeSpeakers;

    /** The wikipedia. */
    private String wikipedia;

    /**
     * Gets the ethnologue.
     *
     * @return The ethnologue
     */
    public String getEthnologue() {
        return ethnologue;
    }

    /**
     * Gets the iso6391.
     *
     * @return The iso6391
     */
    public String getIso6391() {
        return iso6391;
    }

    /**
     * Gets the iso6392.
     *
     * @return The iso6392
     */
    public String getIso6392() {
        return iso6392;
    }

    /**
     * Gets the iso6393.
     *
     * @return The iso6393
     */
    public String getIso6393() {
        return iso6393;
    }

    /**
     * Gets the native speakers.
     *
     * @return The nativeSpeakers
     */
    public String getNativeSpeakers() {
        return nativeSpeakers;
    }

    /**
     * Gets the wikipedia.
     *
     * @return The wikipedia
     */
    public String getWikipedia() {
        return wikipedia;
    }

    /**
     * Sets the ethnologue.
     *
     * @param ethnologue The ethnologue
     */
    public void setEthnologue(String ethnologue) {
        this.ethnologue = ethnologue;
    }

    /**
     * Sets the iso6391.
     *
     * @param iso6391 The iso-639-1
     */
    public void setIso6391(String iso6391) {
        this.iso6391 = iso6391;
    }

    /**
     * Sets the iso6392.
     *
     * @param iso6392 The iso-639-2
     */
    public void setIso6392(String iso6392) {
        this.iso6392 = iso6392;
    }

    /**
     * Sets the iso6393.
     *
     * @param iso6393 The iso-639-3
     */
    public void setIso6393(String iso6393) {
        this.iso6393 = iso6393;
    }

    /**
     * Sets the native speakers.
     *
     * @param nativeSpeakers The native-speakers
     */
    public void setNativeSpeakers(String nativeSpeakers) {
        this.nativeSpeakers = nativeSpeakers;
    }

    /**
     * Sets the wikipedia.
     *
     * @param wikipedia The wikipedia
     */
    public void setWikipedia(String wikipedia) {
        this.wikipedia = wikipedia;
    }
}
