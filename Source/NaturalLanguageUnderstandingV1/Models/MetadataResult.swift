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

/** The Authors, Publication Date, and Title of the document. Supports URL
    and HTML input types. */
public struct MetadataResult: JSONDecodable {
    
    /// The authors of the document.
    public let authors: [Author]?
    
    /// The publication date in the format ISO 8601.
    public let publicationDate: String?
    
    /// The title of the document.
    public let title: String?

    /// Used internally to initialize a `MetadataResult` model from JSON.
    public init(json: JSON) throws {
        authors = try? json.decodedArray(at: "authors", type: Author.self)
        publicationDate = try? json.getString(at: "publication_date")
        title = try? json.getString(at: "title")
    }
}
