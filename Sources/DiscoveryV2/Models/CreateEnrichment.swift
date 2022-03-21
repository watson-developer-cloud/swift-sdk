/**
 * (C) Copyright IBM Corp. 2022.
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
 Information about a specific enrichment.
 */
public struct CreateEnrichment: Codable, Equatable {

    /**
     The type of this enrichment.
     */
    public enum TypeEnum: String {
        case classifier = "classifier"
        case dictionary = "dictionary"
        case regularExpression = "regular_expression"
        case uimaAnnotator = "uima_annotator"
        case ruleBased = "rule_based"
        case watsonKnowledgeStudioModel = "watson_knowledge_studio_model"
    }

    /**
     The human readable name for this enrichment.
     */
    public var name: String?

    /**
     The description of this enrichment.
     */
    public var description: String?

    /**
     The type of this enrichment.
     */
    public var type: String?

    /**
     An object that contains options for the current enrichment. Starting with version `2020-08-30`, the enrichment
     options are not included in responses from the List Enrichments method.
     */
    public var options: EnrichmentOptions?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case type = "type"
        case options = "options"
    }

    /**
      Initialize a `CreateEnrichment` with member variables.

      - parameter name: The human readable name for this enrichment.
      - parameter description: The description of this enrichment.
      - parameter type: The type of this enrichment.
      - parameter options: An object that contains options for the current enrichment. Starting with version
        `2020-08-30`, the enrichment options are not included in responses from the List Enrichments method.

      - returns: An initialized `CreateEnrichment`.
     */
    public init(
        name: String? = nil,
        description: String? = nil,
        type: String? = nil,
        options: EnrichmentOptions? = nil
    )
    {
        self.name = name
        self.description = description
        self.type = type
        self.options = options
    }

}
