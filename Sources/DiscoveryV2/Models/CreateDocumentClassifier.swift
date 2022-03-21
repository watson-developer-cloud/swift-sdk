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
 An object that manages the settings and data that is required to train a document classification model.
 */
public struct CreateDocumentClassifier: Codable, Equatable {

    /**
     A human-readable name of the document classifier.
     */
    public var name: String

    /**
     A description of the document classifier.
     */
    public var description: String?

    /**
     The language of the training data that is associated with the document classifier. Language is specified by using
     the ISO 639-1 language code, such as `en` for English or `ja` for Japanese.
     */
    public var language: String

    /**
     The name of the field from the training data that contains the classification labels.
     */
    public var answerField: String

    /**
     An array of enrichments to apply to the training data that is used by the document classifier.
     */
    public var enrichments: [DocumentClassifierEnrichment]?

    /**
     An object with details for creating federated document classifier models.
     */
    public var federatedClassification: ClassifierFederatedModel?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case language = "language"
        case answerField = "answer_field"
        case enrichments = "enrichments"
        case federatedClassification = "federated_classification"
    }

    /**
      Initialize a `CreateDocumentClassifier` with member variables.

      - parameter name: A human-readable name of the document classifier.
      - parameter language: The language of the training data that is associated with the document classifier.
        Language is specified by using the ISO 639-1 language code, such as `en` for English or `ja` for Japanese.
      - parameter answerField: The name of the field from the training data that contains the classification labels.
      - parameter description: A description of the document classifier.
      - parameter enrichments: An array of enrichments to apply to the training data that is used by the document
        classifier.
      - parameter federatedClassification: An object with details for creating federated document classifier models.

      - returns: An initialized `CreateDocumentClassifier`.
     */
    public init(
        name: String,
        language: String,
        answerField: String,
        description: String? = nil,
        enrichments: [DocumentClassifierEnrichment]? = nil,
        federatedClassification: ClassifierFederatedModel? = nil
    )
    {
        self.name = name
        self.language = language
        self.answerField = answerField
        self.description = description
        self.enrichments = enrichments
        self.federatedClassification = federatedClassification
    }

}
