/**
 * (C) Copyright IBM Corp. 2020.
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
 An object that contains options for the current enrichment. Starting with version `2020-08-30`, the enrichment options
 are not included in responses from the List Enrichments method.
 */
public struct EnrichmentOptions: Codable, Equatable {

    /**
     An array of supported languages for this enrichment. Required when `type` is `dictionary`. Optional when `type` is
     `rule_based`. Not valid when creating any other type of enrichment.
     */
    public var languages: [String]?

    /**
     The name of the entity type. This value is used as the field name in the index. Required when `type` is
     `dictionary` or `regular_expression`. Not valid when creating any other type of enrichment.
     */
    public var entityType: String?

    /**
     The regular expression to apply for this enrichment. Required when `type` is `regular_expression`. Not valid when
     creating any other type of enrichment.
     */
    public var regularExpression: String?

    /**
     The name of the result document field that this enrichment creates. Required when `type` is `rule_based`. Not valid
     when creating any other type of enrichment.
     */
    public var resultField: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case languages = "languages"
        case entityType = "entity_type"
        case regularExpression = "regular_expression"
        case resultField = "result_field"
    }

    /**
      Initialize a `EnrichmentOptions` with member variables.

      - parameter languages: An array of supported languages for this enrichment. Required when `type` is
        `dictionary`. Optional when `type` is `rule_based`. Not valid when creating any other type of enrichment.
      - parameter entityType: The name of the entity type. This value is used as the field name in the index. Required
        when `type` is `dictionary` or `regular_expression`. Not valid when creating any other type of enrichment.
      - parameter regularExpression: The regular expression to apply for this enrichment. Required when `type` is
        `regular_expression`. Not valid when creating any other type of enrichment.
      - parameter resultField: The name of the result document field that this enrichment creates. Required when
        `type` is `rule_based`. Not valid when creating any other type of enrichment.

      - returns: An initialized `EnrichmentOptions`.
     */
    public init(
        languages: [String]? = nil,
        entityType: String? = nil,
        regularExpression: String? = nil,
        resultField: String? = nil
    )
    {
        self.languages = languages
        self.entityType = entityType
        self.regularExpression = regularExpression
        self.resultField = resultField
    }

}
