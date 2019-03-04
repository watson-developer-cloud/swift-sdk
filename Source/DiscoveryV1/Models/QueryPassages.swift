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

/** QueryPassages. */
public struct QueryPassages: Codable, Equatable {

    /**
     The unique identifier of the document from which the passage has been extracted.
     */
    public var documentID: String?

    /**
     The confidence score of the passages's analysis. A higher score indicates greater confidence.
     */
    public var passageScore: Double?

    /**
     The content of the extracted passage.
     */
    public var passageText: String?

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
        case documentID = "document_id"
        case passageScore = "passage_score"
        case passageText = "passage_text"
        case startOffset = "start_offset"
        case endOffset = "end_offset"
        case field = "field"
    }

}
