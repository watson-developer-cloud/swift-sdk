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

/** SearchResult. */
public struct SearchResult: Codable, Equatable {

    /**
     The unique identifier of the document in the Discovery service collection.
     This property is included in responses from search skills, which are a beta feature available only to Plus or
     Premium plan users.
     */
    public var id: String

    /**
     An object containing search result metadata from the Discovery service.
     */
    public var resultMetadata: SearchResultMetadata

    /**
     A description of the search result. This is taken from an abstract, summary, or highlight field in the Discovery
     service response, as specified in the search skill configuration.
     */
    public var body: String?

    /**
     The title of the search result. This is taken from a title or name field in the Discovery service response, as
     specified in the search skill configuration.
     */
    public var title: String?

    /**
     The URL of the original data object in its native data source.
     */
    public var url: String?

    /**
     An object containing segments of text from search results with query-matching text highlighted using HTML <em>
     tags.
     */
    public var highlight: SearchResultHighlight?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case resultMetadata = "result_metadata"
        case body = "body"
        case title = "title"
        case url = "url"
        case highlight = "highlight"
    }

}
