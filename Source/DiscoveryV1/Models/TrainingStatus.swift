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
public struct TrainingStatus {

    public var totalExamples: Int?

    public var available: Bool?

    public var processing: Bool?

    public var minimumQueriesAdded: Bool?

    public var minimumExamplesAdded: Bool?

    public var sufficientLabelDiversity: Bool?

    public var notices: Int?

    public var successfullyTrained: String?

    public var dataUpdated: String?

    /**
     Initialize a `TrainingStatus` with member variables.

     - parameter totalExamples:
     - parameter available:
     - parameter processing:
     - parameter minimumQueriesAdded:
     - parameter minimumExamplesAdded:
     - parameter sufficientLabelDiversity:
     - parameter notices:
     - parameter successfullyTrained:
     - parameter dataUpdated:

     - returns: An initialized `TrainingStatus`.
    */
    public init(totalExamples: Int? = nil, available: Bool? = nil, processing: Bool? = nil, minimumQueriesAdded: Bool? = nil, minimumExamplesAdded: Bool? = nil, sufficientLabelDiversity: Bool? = nil, notices: Int? = nil, successfullyTrained: String? = nil, dataUpdated: String? = nil) {
        self.totalExamples = totalExamples
        self.available = available
        self.processing = processing
        self.minimumQueriesAdded = minimumQueriesAdded
        self.minimumExamplesAdded = minimumExamplesAdded
        self.sufficientLabelDiversity = sufficientLabelDiversity
        self.notices = notices
        self.successfullyTrained = successfullyTrained
        self.dataUpdated = dataUpdated
    }
}

extension TrainingStatus: Codable {

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
        static let allValues = [totalExamples, available, processing, minimumQueriesAdded, minimumExamplesAdded, sufficientLabelDiversity, notices, successfullyTrained, dataUpdated]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalExamples = try container.decodeIfPresent(Int.self, forKey: .totalExamples)
        available = try container.decodeIfPresent(Bool.self, forKey: .available)
        processing = try container.decodeIfPresent(Bool.self, forKey: .processing)
        minimumQueriesAdded = try container.decodeIfPresent(Bool.self, forKey: .minimumQueriesAdded)
        minimumExamplesAdded = try container.decodeIfPresent(Bool.self, forKey: .minimumExamplesAdded)
        sufficientLabelDiversity = try container.decodeIfPresent(Bool.self, forKey: .sufficientLabelDiversity)
        notices = try container.decodeIfPresent(Int.self, forKey: .notices)
        successfullyTrained = try container.decodeIfPresent(String.self, forKey: .successfullyTrained)
        dataUpdated = try container.decodeIfPresent(String.self, forKey: .dataUpdated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(totalExamples, forKey: .totalExamples)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(processing, forKey: .processing)
        try container.encodeIfPresent(minimumQueriesAdded, forKey: .minimumQueriesAdded)
        try container.encodeIfPresent(minimumExamplesAdded, forKey: .minimumExamplesAdded)
        try container.encodeIfPresent(sufficientLabelDiversity, forKey: .sufficientLabelDiversity)
        try container.encodeIfPresent(notices, forKey: .notices)
        try container.encodeIfPresent(successfullyTrained, forKey: .successfullyTrained)
        try container.encodeIfPresent(dataUpdated, forKey: .dataUpdated)
    }

}
