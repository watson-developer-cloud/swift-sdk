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
public struct PaginationResponse: JSONDecodable, JSONEncodable {

    /// The URL that will return the same page of results.
    public let refreshUrl: String

    /// The URL that will return the next page of results.
    public let nextUrl: String?

    /// Reserved for future use.
    public let total: Int?

    /// Reserved for future use.
    public let matched: Int?

    /**
     Initialize a `PaginationResponse` with member variables.

     - parameter refreshUrl: The URL that will return the same page of results.
     - parameter nextUrl: The URL that will return the next page of results.
     - parameter total: Reserved for future use.
     - parameter matched: Reserved for future use.

     - returns: An initialized `PaginationResponse`.
    */
    public init(refreshUrl: String, nextUrl: String? = nil, total: Int? = nil, matched: Int? = nil) {
        self.refreshUrl = refreshUrl
        self.nextUrl = nextUrl
        self.total = total
        self.matched = matched
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `PaginationResponse` model from JSON.
    public init(json: JSON) throws {
        refreshUrl = try json.getString(at: "refresh_url")
        nextUrl = try? json.getString(at: "next_url")
        total = try? json.getInt(at: "total")
        matched = try? json.getInt(at: "matched")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `PaginationResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["refresh_url"] = refreshUrl
        if let nextUrl = nextUrl { json["next_url"] = nextUrl }
        if let total = total { json["total"] = total }
        if let matched = matched { json["matched"] = matched }
        return json
    }
}
