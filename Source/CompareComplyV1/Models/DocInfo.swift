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
 Information about the parsed input document.
 */
public struct DocInfo: Codable, Equatable {

    /**
     The full text of the parsed document in HTML format.
     */
    public var html: String?

    /**
     The title of the parsed document. If the service did not detect a title, the value of this element is `null`.
     */
    public var title: String?

    /**
     The MD5 hash of the input document.
     */
    public var hash: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case html = "html"
        case title = "title"
        case hash = "hash"
    }

}
