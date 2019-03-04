/**
 * Copyright IBM Corporation 2019
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

/**
 Pagination details, if required by the length of the output.
 */
public struct Pagination: Codable, Equatable {

    /**
     A token identifying the current page of results.
     */
    public var refreshCursor: String?

    /**
     A token identifying the next page of results.
     */
    public var nextCursor: String?

    /**
     The URL that returns the current page of results.
     */
    public var refreshURL: String?

    /**
     The URL that returns the next page of results.
     */
    public var nextURL: String?

    /**
     Reserved for future use.
     */
    public var total: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case refreshCursor = "refresh_cursor"
        case nextCursor = "next_cursor"
        case refreshURL = "refresh_url"
        case nextURL = "next_url"
        case total = "total"
    }

}
