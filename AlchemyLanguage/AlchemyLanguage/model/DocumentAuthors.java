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

import java.util.ArrayList;
import java.util.List;

import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyLanguage;
import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * Author returned by the {@link AlchemyLanguage} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class DocumentAuthors extends AlchemyLanguageGenericModel {

    /**
     * Authors returned by the {@link AlchemyLanguage} service.
     *
     * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
     */
    public static class Authors extends GenericModel {

        /**
         * The names.
         */
        private List<String> names = new ArrayList<String>();

        /**
         * Gets the names.
         *
         * @return The names
         */
        public List<String> getNames() {
            return names;
        }

        /**
         * Sets the names.
         *
         * @param names The names
         */
        public void setNames(List<String> names) {
            this.names = names;
        }
    }

    /**
     * The authors.
     */
    private Authors authors;

    /**
     * Gets the authors.
     *
     * @return The authors
     */
    public Authors getAuthors() {
        return authors;
    }

    /**
     * Sets the authors.
     *
     * @param authors The authors
     */
    public void setAuthors(Authors authors) {
        this.authors = authors;
    }
}
