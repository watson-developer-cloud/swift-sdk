/**
 * Copyright IBM Corporation 2018
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
 Basic information about the input document.
 */
public struct Document: Decodable {

    /**
     Document title, if detected.
     */
    public var title: String?

    /**
     The input document converted into HTML format.
     */
    public var html: String?

    /**
     The MD5 hash value of the input document.
     */
    public var hash: String?

    /**
     The label applied to the input document with the calling method's `file1_label` or `file2_label` value.
     */
    public var label: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case html = "html"
        case hash = "hash"
        case label = "label"
    }

}
