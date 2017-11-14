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

/** The pagination data for the returned objects. */
public struct Pagination {

    /// The URL that will return the same page of results.
    public var refreshUrl: String

    /// The URL that will return the next page of results.
    public var nextUrl: String?

    /// Reserved for future use.
    public var total: Int?

    /// Reserved for future use.
    public var matched: Int?

    /**
     Initialize a `Pagination` with member variables.

     - parameter refreshUrl: The URL that will return the same page of results.
     - parameter nextUrl: The URL that will return the next page of results.
     - parameter total: Reserved for future use.
     - parameter matched: Reserved for future use.

     - returns: An initialized `Pagination`.
    */
    public init(refreshUrl: String, nextUrl: String? = nil, total: Int? = nil, matched: Int? = nil) {
        self.refreshUrl = refreshUrl
        self.nextUrl = nextUrl
        self.total = total
        self.matched = matched
    }
}

extension Pagination: Codable {

    private enum CodingKeys: String, CodingKey {
        case refreshUrl = "refresh_url"
        case nextUrl = "next_url"
        case total = "total"
        case matched = "matched"
        static let allValues = [refreshUrl, nextUrl, total, matched]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        refreshUrl = try container.decode(String.self, forKey: .refreshUrl)
        nextUrl = try container.decodeIfPresent(String.self, forKey: .nextUrl)
        total = try container.decodeIfPresent(Int.self, forKey: .total)
        matched = try container.decodeIfPresent(Int.self, forKey: .matched)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(refreshUrl, forKey: .refreshUrl)
        try container.encodeIfPresent(nextUrl, forKey: .nextUrl)
        try container.encodeIfPresent(total, forKey: .total)
        try container.encodeIfPresent(matched, forKey: .matched)
    }

}
