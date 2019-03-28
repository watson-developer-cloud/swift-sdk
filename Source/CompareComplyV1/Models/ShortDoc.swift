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
 Brief information about the input document.
 */
public struct ShortDoc: Codable, Equatable {

    /**
     The title of the input document, if identified.
     */
    public var title: String?

    /**
     The MD5 hash of the input document.
     */
    public var hash: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case hash = "hash"
    }

    /**
     Initialize a `ShortDoc` with member variables.

     - parameter title: The title of the input document, if identified.
     - parameter hash: The MD5 hash of the input document.

     - returns: An initialized `ShortDoc`.
    */
    public init(
        title: String? = nil,
        hash: String? = nil
    )
    {
        self.title = title
        self.hash = hash
    }

}
