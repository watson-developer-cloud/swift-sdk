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

/** IntentCollection. */
public struct IntentCollection {

    /// An array of intents.
    public var intents: [IntentExport]

    /// An object defining the pagination data for the returned objects.
    public var pagination: Pagination

    /**
     Initialize a `IntentCollection` with member variables.

     - parameter intents: An array of intents.
     - parameter pagination: An object defining the pagination data for the returned objects.

     - returns: An initialized `IntentCollection`.
    */
    public init(intents: [IntentExport], pagination: Pagination) {
        self.intents = intents
        self.pagination = pagination
    }
}

extension IntentCollection: Codable {

    private enum CodingKeys: String, CodingKey {
        case intents = "intents"
        case pagination = "pagination"
        static let allValues = [intents, pagination]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        intents = try container.decode([IntentExport].self, forKey: .intents)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(intents, forKey: .intents)
        try container.encode(pagination, forKey: .pagination)
    }

}
