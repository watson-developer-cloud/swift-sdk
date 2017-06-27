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

/** The pagination data for the returned objects. */
public struct LogPagination: JSONDecodable, JSONEncodable {

    /// The URL that will return the next page of results.
    public let nextUrl: String?

    /// Reserved for future use.
    public let matched: Int?

    /**
     Initialize a `LogPagination` with member variables.

     - parameter nextUrl: The URL that will return the next page of results.
     - parameter matched: Reserved for future use.

     - returns: An initialized `LogPagination`.
    */
    public init(nextUrl: String? = nil, matched: Int? = nil) {
        self.nextUrl = nextUrl
        self.matched = matched
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `LogPagination` model from JSON.
    public init(json: JSON) throws {
        nextUrl = try? json.getString(at: "next_url")
        matched = try? json.getInt(at: "matched")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `LogPagination` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let nextUrl = nextUrl { json["next_url"] = nextUrl }
        if let matched = matched { json["matched"] = matched }
        return json
    }
}
