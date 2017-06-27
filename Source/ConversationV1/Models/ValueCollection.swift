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
import RestKit

/** ValueCollection. */
public struct ValueCollection: JSONDecodable, JSONEncodable {

    /// An array of entity values.
    public let values: [ValueExport]

    /// An object defining the pagination data for the returned objects.
    public let pagination: PaginationResponse

    /**
     Initialize a `ValueCollection` with member variables.

     - parameter values: An array of entity values.
     - parameter pagination: An object defining the pagination data for the returned objects.

     - returns: An initialized `ValueCollection`.
    */
    public init(values: [ValueExport], pagination: PaginationResponse) {
        self.values = values
        self.pagination = pagination
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `ValueCollection` model from JSON.
    public init(json: JSON) throws {
        values = try json.decodedArray(at: "values", type: ValueExport.self)
        pagination = try json.decode(at: "pagination", type: PaginationResponse.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `ValueCollection` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["values"] = values.map { $0.toJSONObject() }
        json["pagination"] = pagination.toJSONObject()
        return json
    }
}
