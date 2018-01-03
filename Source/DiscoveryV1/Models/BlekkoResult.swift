/**
 * Copyright IBM Corporation 2016
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

/** The results the search engine Blekko returns. */
public struct BlekkoResult: JSONDecodable {

    /// Language of the document. If the language is something other than "en" for
    /// english, the document will fail to be processed and the Status of the QueryResponse
    /// will be 'ERROR'.
    public let language: String?

    /// Raw title of the document.
    public let rawTitle: [String]?

    /// Cleaned title of the document by the service.
    public let cleanTitle: [String]?

    /// Extracted URL of the document.
    public let url: String?

    /// The publication date in epoch seconds from UTC.
    public let chrondate: Int?

    /// Extracted text snippets of the document.
    public let snippets: [String]?

    /// Hostname of the document.
    public let host: String?

    /// Extracted type of document.
    public let documentType: String?

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// Used internally to initialize a `BlekkoResult` model from JSON.
    public init(json: JSONWrapper) throws {
        language = try? json.getString(at: "lang")
        rawTitle = try? json.decodedArray(at: "raw_title", type: Swift.String.self)
        cleanTitle = try? json.decodedArray(at: "clean_title", type: Swift.String.self)
        url = try? json.getString(at: "url")
        chrondate = try? json.getInt(at: "chrondate")
        snippets = try? json.decodedArray(at: "snippets", type: Swift.String.self)
        host = try? json.getString(at: "host")
        documentType = try? json.getString(at: "documentType")
        self.json = try json.getDictionaryObject()
    }

    /// Used internally to serialize a 'BlekkoResult' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
