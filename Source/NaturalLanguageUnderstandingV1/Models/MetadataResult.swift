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
import RestKit

public struct MetadataResult: JSONDecodable,JSONEncodable {
    public let authors: [Author]?
    /// ISO 8601 date-time
    public let publicationDate: String?
    /// Title of the document
    public let title: String?

    /**
     Initialize a `MetadataResult` with required member variables.

     - returns: An initialized `MetadataResult`.
    */
    public init() {
        self.authors = nil
        self.publicationDate = nil
        self.title = nil
    }

    /**
    Initialize a `MetadataResult` with all member variables.

     - parameter authors: 
     - parameter publicationDate: ISO 8601 date-time
     - parameter title: Title of the document

    - returns: An initialized `MetadataResult`.
    */
    public init(authors: [Author], publicationDate: String, title: String) {
        self.authors = authors
        self.publicationDate = publicationDate
        self.title = title
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `MetadataResult` model from JSON.
    public init(json: JSON) throws {
        authors = try? json.decodedArray(at: "authors", type: Author.self)
        publicationDate = try? json.getString(at: "publication_date")
        title = try? json.getString(at: "title")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `MetadataResult` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let authors = authors {
            json["authors"] = authors.map { authorsElem in authorsElem.toJSONObject() }
        }
        if let publicationDate = publicationDate { json["publication_date"] = publicationDate }
        if let title = title { json["title"] = title }
        return json
    }
}
