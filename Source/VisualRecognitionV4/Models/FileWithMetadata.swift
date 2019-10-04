/**
 * (C) Copyright IBM Corp. 2019.
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
 A file with its associated metadata.
 */
public struct FileWithMetadata: Codable, Equatable {

    /**
     The data / content for the file.
     */
    public var data: Data

    /**
     The filename of the file.
     */
    public var filename: String?

    /**
     The content type of the file.
     */
    public var contentType: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case data = "data"
        case filename = "filename"
        case contentType = "content_type"
    }

    /**
     Initialize a `FileWithMetadata` with member variables.

     - parameter data: The data / content for the file.
     - parameter filename: The filename of the file.
     - parameter contentType: The content type of the file.

     - returns: An initialized `FileWithMetadata`.
     */
    public init(
        data: Data,
        filename: String? = nil,
        contentType: String? = nil
    )
    {
        self.data = data
        self.filename = filename
        self.contentType = contentType
    }

}
