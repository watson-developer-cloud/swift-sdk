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
 An object that contains options for the current enrichment. Starting with version `2020-08-30`, the enrichment options
 are not included in responses from the List Enrichments method.
 */
public struct EnrichmentOptions: Codable, Equatable {

    /**
     An array of supported languages for this enrichment. When creating an enrichment, only specify a language that is
     used by the model or in the dictionary. Required when `type` is `dictionary`. Optional when `type` is `rule_based`.
     Not valid when creating any other type of enrichment.
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
     The name of the result document field that this enrichment creates. Required when `type` is `rule_based` or
     `classifier`. Not valid when creating any other type of enrichment.
     */
    public var resultField: String?

    /**
     A unique identifier of the document classifier. Required when `type` is `classifier`. Not valid when creating any
     other type of enrichment.
     */
    public var classifierID: String?

    /**
     A unique identifier of the document classifier model. Required when `type` is `classifier`. Not valid when creating
     any other type of enrichment.
     */
    public var modelID: String?

    /**
     Specifies a threshold. Only classes with evaluation confidence scores that are higher than the specified threshold
     are included in the output. Optional when `type` is `classifier`. Not valid when creating any other type of
     enrichment.
     */
    public var confidenceThreshold: Double?

    /**
     Evaluates only the classes that fall in the top set of results when ranked by confidence. For example, if set to
     `5`, then the top five classes for each document are evaluated. If set to 0, the `confidence_threshold` is used to
     determine the predicted classes. Optional when `type` is `classifier`. Not valid when creating any other type of
     enrichment.
     */
    public var topK: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case languages = "languages"
        case entityType = "entity_type"
        case regularExpression = "regular_expression"
        case resultField = "result_field"
        case classifierID = "classifier_id"
        case modelID = "model_id"
        case confidenceThreshold = "confidence_threshold"
        case topK = "top_k"
    }

    /**
      Initialize a `EnrichmentOptions` with member variables.

      - parameter languages: An array of supported languages for this enrichment. When creating an enrichment, only
        specify a language that is used by the model or in the dictionary. Required when `type` is `dictionary`. Optional
        when `type` is `rule_based`. Not valid when creating any other type of enrichment.
      - parameter entityType: The name of the entity type. This value is used as the field name in the index. Required
        when `type` is `dictionary` or `regular_expression`. Not valid when creating any other type of enrichment.
      - parameter regularExpression: The regular expression to apply for this enrichment. Required when `type` is
        `regular_expression`. Not valid when creating any other type of enrichment.
      - parameter resultField: The name of the result document field that this enrichment creates. Required when
        `type` is `rule_based` or `classifier`. Not valid when creating any other type of enrichment.
      - parameter classifierID: A unique identifier of the document classifier. Required when `type` is `classifier`.
        Not valid when creating any other type of enrichment.
      - parameter confidenceThreshold: Specifies a threshold. Only classes with evaluation confidence scores that are
        higher than the specified threshold are included in the output. Optional when `type` is `classifier`. Not valid
        when creating any other type of enrichment.
      - parameter topK: Evaluates only the classes that fall in the top set of results when ranked by confidence. For
        example, if set to `5`, then the top five classes for each document are evaluated. If set to 0, the
        `confidence_threshold` is used to determine the predicted classes. Optional when `type` is `classifier`. Not
        valid when creating any other type of enrichment.

      - returns: An initialized `EnrichmentOptions`.
     */
    public init(
        languages: [String]? = nil,
        entityType: String? = nil,
        regularExpression: String? = nil,
        resultField: String? = nil,
        classifierID: String? = nil,
        confidenceThreshold: Double? = nil,
        topK: Int? = nil
    )
    {
        self.languages = languages
        self.entityType = entityType
        self.regularExpression = regularExpression
        self.resultField = resultField
        self.classifierID = classifierID
        self.confidenceThreshold = confidenceThreshold
        self.topK = topK
    }

}
