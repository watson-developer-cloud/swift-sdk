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
 The source type of the image.
 */
public struct ImageSource: Codable, Equatable {

    /**
     The source type of the image.
     */
    public enum TypeEnum: String {
        case file = "file"
        case url = "url"
    }

    /**
     The source type of the image.
     */
    public var type: String

    /**
     Name of the image file if uploaded. Not returned when the image is passed by URL.
     */
    public var filename: String?

    /**
     Name of the .zip file of images if uploaded. Not returned when the image is passed directly or by URL.
     */
    public var archiveFilename: String?

    /**
     Source of the image before any redirects. Not returned when the image is uploaded.
     */
    public var sourceURL: String?

    /**
     Fully resolved URL of the image after redirects are followed. Not returned when the image is uploaded.
     */
    public var resolvedURL: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case filename = "filename"
        case archiveFilename = "archive_filename"
        case sourceURL = "source_url"
        case resolvedURL = "resolved_url"
    }

}
