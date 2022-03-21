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
 Information about a document classifier.
 */
public struct DocumentClassifier: Codable, Equatable {

    /**
     A unique identifier of the document classifier.
     */
    public var classifierID: String?

    /**
     A human-readable name of the document classifier.
     */
    public var name: String

    /**
     A description of the document classifier.
     */
    public var description: String?

    /**
     The date that the document classifier was created.
     */
    public var created: Date?

    /**
     The language of the training data that is associated with the document classifier. Language is specified by using
     the ISO 639-1 language code, such as `en` for English or `ja` for Japanese.
     */
    public var language: String?

    /**
     An array of enrichments to apply to the training data that is used by the document classifier.
     */
    public var enrichments: [DocumentClassifierEnrichment]?

    /**
     An array of fields that are used to train the document classifier. The same set of fields must exist in the
     training data, the test data, and the documents where the resulting document classifier enrichment is applied at
     run time.
     */
    public var recognizedFields: [String]?

    /**
     The name of the field from the training data that contains the classification labels.
     */
    public var answerField: String?

    /**
     Name of the CSV file with training data that is used to train the document classifier.
     */
    public var trainingDataFile: String?

    /**
     Name of the CSV file with data that is used to test the document classifier. If no test data is provided, a subset
     of the training data is used for testing purposes.
     */
    public var testDataFile: String?

    /**
     An object with details for creating federated document classifier models.
     */
    public var federatedClassification: ClassifierFederatedModel?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case classifierID = "classifier_id"
        case name = "name"
        case description = "description"
        case created = "created"
        case language = "language"
        case enrichments = "enrichments"
        case recognizedFields = "recognized_fields"
        case answerField = "answer_field"
        case trainingDataFile = "training_data_file"
        case testDataFile = "test_data_file"
        case federatedClassification = "federated_classification"
    }

}
