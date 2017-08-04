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

/** CounterexampleCollectionResponse. */
public struct CounterexampleCollectionResponse: JSONDecodable, JSONEncodable {

    /// An array of ExampleResponse objects describing the examples marked as irrelevant input.
    public let counterexamples: [ExampleResponse]

    /// A PaginationResponse object defining the pagination data for the returned objects.
    public let pagination: PaginationResponse

    /**
     Initialize a `CounterexampleCollectionResponse` with member variables.

     - parameter counterexamples: An array of ExampleResponse objects describing the examples marked as irrelevant input.
     - parameter pagination: A PaginationResponse object defining the pagination data for the returned objects.

     - returns: An initialized `CounterexampleCollectionResponse`.
    */
    public init(counterexamples: [ExampleResponse], pagination: PaginationResponse) {
        self.counterexamples = counterexamples
        self.pagination = pagination
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `CounterexampleCollectionResponse` model from JSON.
    public init(json: JSON) throws {
        counterexamples = try json.decodedArray(at: "counterexamples", type: ExampleResponse.self)
        pagination = try json.decode(at: "pagination", type: PaginationResponse.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `CounterexampleCollectionResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["counterexamples"] = counterexamples.map { $0.toJSONObject() }
        json["pagination"] = pagination.toJSONObject()
        return json
    }
}
