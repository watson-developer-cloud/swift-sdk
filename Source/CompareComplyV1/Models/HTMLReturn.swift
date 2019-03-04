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
 The HTML converted from an input document.
 */
public struct HTMLReturn: Codable, Equatable {

    /**
     The number of pages in the input document.
     */
    public var numPages: String?

    /**
     The author of the input document, if identified.
     */
    public var author: String?

    /**
     The publication date of the input document, if identified.
     */
    public var publicationDate: String?

    /**
     The title of the input document, if identified.
     */
    public var title: String?

    /**
     The HTML version of the input document.
     */
    public var html: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case numPages = "num_pages"
        case author = "author"
        case publicationDate = "publication_date"
        case title = "title"
        case html = "html"
    }

}
