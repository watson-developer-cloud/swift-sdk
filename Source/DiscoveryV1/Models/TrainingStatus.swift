/**
 * Copyright IBM Corporation 2018
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

    public var totalExamples: Int?

    public var available: Bool?

    public var processing: Bool?

    public var minimumQueriesAdded: Bool?

    public var minimumExamplesAdded: Bool?

    public var sufficientLabelDiversity: Bool?

    public var notices: Int?

    public var successfullyTrained: Date?

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
