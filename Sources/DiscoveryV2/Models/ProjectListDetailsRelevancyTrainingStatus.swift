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
 Relevancy training status information for this project.
 */
public struct ProjectListDetailsRelevancyTrainingStatus: Codable, Equatable {

    /**
     When the training data was updated.
     */
    public var dataUpdated: String?

    /**
     The total number of examples.
     */
    public var totalExamples: Int?

    /**
     When `true`, sufficient label diversity is present to allow training for this project.
     */
    public var sufficientLabelDiversity: Bool?

    /**
     When `true`, the relevancy training is in processing.
     */
    public var processing: Bool?

    /**
     When `true`, the minimum number of examples required to train has been met.
     */
    public var minimumExamplesAdded: Bool?

    /**
     The time that the most recent successful training occurred.
     */
    public var successfullyTrained: String?

    /**
     When `true`, relevancy training is available when querying collections in the project.
     */
    public var available: Bool?

    /**
     The number of notices generated during the relevancy training.
     */
    public var notices: Int?

    /**
     When `true`, the minimum number of queries required to train has been met.
     */
    public var minimumQueriesAdded: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case dataUpdated = "data_updated"
        case totalExamples = "total_examples"
        case sufficientLabelDiversity = "sufficient_label_diversity"
        case processing = "processing"
        case minimumExamplesAdded = "minimum_examples_added"
        case successfullyTrained = "successfully_trained"
        case available = "available"
        case notices = "notices"
        case minimumQueriesAdded = "minimum_queries_added"
    }

}
