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
 The Authors, Publication Date, and Title of the document. Supports URL and HTML input types.
 */
public struct MetadataResult: Decodable {

    /**
     The authors of the document.
     */
    public var authors: [Author]?

    /**
     The publication date in the format ISO 8601.
     */
    public var publicationDate: String?

    /**
     The title of the document.
     */
    public var title: String?

    /**
     URL of a prominent image on the webpage.
     */
    public var image: String?

    /**
     RSS/ATOM feeds found on the webpage.
     */
    public var feeds: [Feed]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case authors = "authors"
        case publicationDate = "publication_date"
        case title = "title"
        case image = "image"
        case feeds = "feeds"
    }

}
