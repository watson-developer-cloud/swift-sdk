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

/** IntentCollectionResponse. */
public struct IntentCollectionResponse: JSONDecodable, JSONEncodable {

    /// An array of Intent collection.
    public let intents: [IntentExportResponse]

    /// An object defining the pagination data for the returned objects.
    public let pagination: PaginationResponse

    /**
     Initialize a `IntentCollectionResponse` with member variables.

     - parameter intents: An array of Intent collection.
     - parameter pagination: An object defining the pagination data for the returned objects.

     - returns: An initialized `IntentCollectionResponse`.
    */
    public init(intents: [IntentExportResponse], pagination: PaginationResponse) {
        self.intents = intents
        self.pagination = pagination
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `IntentCollectionResponse` model from JSON.
    public init(json: JSON) throws {
        intents = try json.decodedArray(at: "intents", type: IntentExportResponse.self)
        pagination = try json.decode(at: "pagination", type: PaginationResponse.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `IntentCollectionResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["intents"] = intents.map { $0.toJSONObject() }
        json["pagination"] = pagination.toJSONObject()
        return json
    }
}
