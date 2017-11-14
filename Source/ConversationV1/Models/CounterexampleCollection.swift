/**
 * Copyright IBM Corporation 2017
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

/** CounterexampleCollection. */
public struct CounterexampleCollection {

    /// An array of objects describing the examples marked as irrelevant input.
    public var counterexamples: [Counterexample]

    /// An object defining the pagination data for the returned objects.
    public var pagination: Pagination

    /**
     Initialize a `CounterexampleCollection` with member variables.

     - parameter counterexamples: An array of objects describing the examples marked as irrelevant input.
     - parameter pagination: An object defining the pagination data for the returned objects.

     - returns: An initialized `CounterexampleCollection`.
    */
    public init(counterexamples: [Counterexample], pagination: Pagination) {
        self.counterexamples = counterexamples
        self.pagination = pagination
    }
}

extension CounterexampleCollection: Codable {

    private enum CodingKeys: String, CodingKey {
        case counterexamples = "counterexamples"
        case pagination = "pagination"
        static let allValues = [counterexamples, pagination]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        counterexamples = try container.decode([Counterexample].self, forKey: .counterexamples)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(counterexamples, forKey: .counterexamples)
        try container.encode(pagination, forKey: .pagination)
    }

}
