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

import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyVision;

/**
 * Image by the {@link AlchemyVision} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class ImageKeywords extends AlchemyGenericModel {

    /** The image keywords. */
    private List<ImageKeyword> imageKeywords;

    /** The url. */
    private String url;

    /**
     * Gets the image keywords.
     *
     * @return The imageKeywords
     */
    public List<ImageKeyword> getImageKeywords() {
        return imageKeywords;
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
     * Sets the image keywords.
     *
     * @param imageKeywords The imageKeywords
     */
    public void setImageKeywords(List<ImageKeyword> imageKeywords) {
        this.imageKeywords = imageKeywords;
    }

    /**
     * Sets the url.
     *
     * @param url The url
     */
    public void setUrl(String url) {
        this.url = url;
    }
}
