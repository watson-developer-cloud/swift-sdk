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

/** ExampleCollectionResponse. */
public struct ExampleCollectionResponse: JSONDecodable, JSONEncodable {

    /// An array of ExampleResponse objects describing the examples defined for the intent.
    public let examples: [ExampleResponse]

    /// A PaginationResponse object defining the pagination data for the returned objects.
    public let pagination: PaginationResponse

    /**
     Initialize a `ExampleCollectionResponse` with member variables.

     - parameter examples: An array of ExampleResponse objects describing the examples defined for the intent.
     - parameter pagination: A PaginationResponse object defining the pagination data for the returned objects.

     - returns: An initialized `ExampleCollectionResponse`.
    */
    public init(examples: [ExampleResponse], pagination: PaginationResponse) {
        self.examples = examples
        self.pagination = pagination
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `ExampleCollectionResponse` model from JSON.
    public init(json: JSON) throws {
        examples = try json.decodedArray(at: "examples", type: ExampleResponse.self)
        pagination = try json.decode(at: "pagination", type: PaginationResponse.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `ExampleCollectionResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["examples"] = examples.map { $0.toJSONObject() }
        json["pagination"] = pagination.toJSONObject()
        return json
    }
}
