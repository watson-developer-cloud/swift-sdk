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

/** ValueCollection. */
public struct ValueCollection {

    /// An array of entity values.
    public var values: [ValueExport]

    /// An object defining the pagination data for the returned objects.
    public var pagination: Pagination

    /**
     Initialize a `ValueCollection` with member variables.

     - parameter values: An array of entity values.
     - parameter pagination: An object defining the pagination data for the returned objects.

     - returns: An initialized `ValueCollection`.
    */
    public init(values: [ValueExport], pagination: Pagination) {
        self.values = values
        self.pagination = pagination
    }
}

extension ValueCollection: Codable {

    private enum CodingKeys: String, CodingKey {
        case values = "values"
        case pagination = "pagination"
        static let allValues = [values, pagination]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        values = try container.decode([ValueExport].self, forKey: .values)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(values, forKey: .values)
        try container.encode(pagination, forKey: .pagination)
    }

}
