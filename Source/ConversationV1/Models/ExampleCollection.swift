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

/** ExampleCollection. */
public struct ExampleCollection {

    /// An array of Example objects describing the examples defined for the intent.
    public var examples: [Example]

    /// An object defining the pagination data for the returned objects.
    public var pagination: Pagination

    /**
     Initialize a `ExampleCollection` with member variables.

     - parameter examples: An array of Example objects describing the examples defined for the intent.
     - parameter pagination: An object defining the pagination data for the returned objects.

     - returns: An initialized `ExampleCollection`.
    */
    public init(examples: [Example], pagination: Pagination) {
        self.examples = examples
        self.pagination = pagination
    }
}

extension ExampleCollection: Codable {

    private enum CodingKeys: String, CodingKey {
        case examples = "examples"
        case pagination = "pagination"
        static let allValues = [examples, pagination]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        examples = try container.decode([Example].self, forKey: .examples)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(examples, forKey: .examples)
        try container.encode(pagination, forKey: .pagination)
    }

}
