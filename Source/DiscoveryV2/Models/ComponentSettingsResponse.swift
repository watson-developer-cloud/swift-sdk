/**
 * (C) Copyright IBM Corp. 2019.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation

/**
 A response containing the default component settings.
 */
public struct ComponentSettingsResponse: Codable, Equatable {

    /**
     Fields shown in the results section of the UI.
     */
    public var fieldsShown: ComponentSettingsFieldsShown?

    /**
     Whether or not autocomplete is enabled.
     */
    public var autocomplete: Bool?

    /**
     Whether or not structured search is enabled.
     */
    public var structuredSearch: Bool?

    /**
     Number or results shown per page.
     */
    public var resultsPerPage: Int?

    /**
     a list of component setting aggregations.
     */
    public var aggregations: [ComponentSettingsAggregation]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case fieldsShown = "fields_shown"
        case autocomplete = "autocomplete"
        case structuredSearch = "structured_search"
        case resultsPerPage = "results_per_page"
        case aggregations = "aggregations"
    }

}
