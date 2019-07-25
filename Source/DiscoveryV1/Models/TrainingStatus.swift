/**
 * Copyright IBM Corporation 2019
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

/** TrainingStatus. */
public struct TrainingStatus: Codable, Equatable {

    /**
     The total number of training examples uploaded to this collection.
     */
    public var totalExamples: Int?

    /**
     When `true`, the collection has been successfully trained.
     */
    public var available: Bool?

    /**
     When `true`, the collection is currently processing training.
     */
    public var processing: Bool?

    /**
     When `true`, the collection has a sufficent amount of queries added for training to occur.
     */
    public var minimumQueriesAdded: Bool?

    /**
     When `true`, the collection has a sufficent amount of examples added for training to occur.
     */
    public var minimumExamplesAdded: Bool?

    /**
     When `true`, the collection has a sufficent amount of diversity in labeled results for training to occur.
     */
    public var sufficientLabelDiversity: Bool?

    /**
     The number of notices associated with this data set.
     */
    public var notices: Int?

    /**
     The timestamp of when the collection was successfully trained.
     */
    public var successfullyTrained: Date?

    /**
     The timestamp of when the data was uploaded.
     */
    public var dataUpdated: Date?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case totalExamples = "total_examples"
        case available = "available"
        case processing = "processing"
        case minimumQueriesAdded = "minimum_queries_added"
        case minimumExamplesAdded = "minimum_examples_added"
        case sufficientLabelDiversity = "sufficient_label_diversity"
        case notices = "notices"
        case successfullyTrained = "successfully_trained"
        case dataUpdated = "data_updated"
    }

}
