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

/** The Authors, Publication Date, and Title of the document. Supports URL and HTML input types. */
public struct MetadataResult {

    /// The authors of the document.
    public var authors: [Author]?

    /// The publication date in the format ISO 8601.
    public var publicationDate: String?

    /// The title of the document.
    public var title: String?

    /**
     Initialize a `MetadataResult` with member variables.

     - parameter authors: The authors of the document.
     - parameter publicationDate: The publication date in the format ISO 8601.
     - parameter title: The title of the document.

     - returns: An initialized `MetadataResult`.
    */
    public init(authors: [Author]? = nil, publicationDate: String? = nil, title: String? = nil) {
        self.authors = authors
        self.publicationDate = publicationDate
        self.title = title
    }
}

extension MetadataResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case authors = "authors"
        case publicationDate = "publication_date"
        case title = "title"
        static let allValues = [authors, publicationDate, title]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        authors = try container.decodeIfPresent([Author].self, forKey: .authors)
        publicationDate = try container.decodeIfPresent(String.self, forKey: .publicationDate)
        title = try container.decodeIfPresent(String.self, forKey: .title)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(publicationDate, forKey: .publicationDate)
        try container.encodeIfPresent(title, forKey: .title)
    }

}
