/**
 * (C) Copyright IBM Corp. 2020.
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
 A passage query response.
 */
public struct QueryResponsePassage: Codable, Equatable {

    /**
     The content of the extracted passage.
     */
    public var passageText: String?

    /**
     The confidence score of the passage's analysis. A higher score indicates greater confidence.
     */
    public var passageScore: Double?

    /**
     The unique identifier of the ingested document.
     */
    public var documentID: String?

    /**
     The unique identifier of the collection.
     */
    public var collectionID: String?

    /**
     The position of the first character of the extracted passage in the originating field.
     */
    public var startOffset: Int?

    /**
     The position of the last character of the extracted passage in the originating field.
     */
    public var endOffset: Int?

    /**
     The label of the field from which the passage has been extracted.
     */
    public var field: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case passageText = "passage_text"
        case passageScore = "passage_score"
        case documentID = "document_id"
        case collectionID = "collection_id"
        case startOffset = "start_offset"
        case endOffset = "end_offset"
        case field = "field"
    }

}
