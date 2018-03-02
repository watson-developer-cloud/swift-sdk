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

/** QueryPassages. */
public struct QueryPassages {

    /// The unique identifier of the document from which the passage has been extracted.
    public var documentID: String?

    /// The confidence score of the passages's analysis. A higher score indicates greater confidence.
    public var passageScore: Double?

    /// The content of the extracted passage.
    public var passageText: String?

    /// The position of the first character of the extracted passage in the originating field.
    public var startOffset: Int?

    /// The position of the last character of the extracted passage in the originating field.
    public var endOffset: Int?

    /// The label of the field from which the passage has been extracted.
    public var field: String?

    /**
     Initialize a `QueryPassages` with member variables.

     - parameter documentID: The unique identifier of the document from which the passage has been extracted.
     - parameter passageScore: The confidence score of the passages's analysis. A higher score indicates greater confidence.
     - parameter passageText: The content of the extracted passage.
     - parameter startOffset: The position of the first character of the extracted passage in the originating field.
     - parameter endOffset: The position of the last character of the extracted passage in the originating field.
     - parameter field: The label of the field from which the passage has been extracted.

     - returns: An initialized `QueryPassages`.
    */
    public init(documentID: String? = nil, passageScore: Double? = nil, passageText: String? = nil, startOffset: Int? = nil, endOffset: Int? = nil, field: String? = nil) {
        self.documentID = documentID
        self.passageScore = passageScore
        self.passageText = passageText
        self.startOffset = startOffset
        self.endOffset = endOffset
        self.field = field
    }
}

extension QueryPassages: Codable {

    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case passageScore = "passage_score"
        case passageText = "passage_text"
        case startOffset = "start_offset"
        case endOffset = "end_offset"
        case field = "field"
        static let allValues = [documentID, passageScore, passageText, startOffset, endOffset, field]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentID = try container.decodeIfPresent(String.self, forKey: .documentID)
        passageScore = try container.decodeIfPresent(Double.self, forKey: .passageScore)
        passageText = try container.decodeIfPresent(String.self, forKey: .passageText)
        startOffset = try container.decodeIfPresent(Int.self, forKey: .startOffset)
        endOffset = try container.decodeIfPresent(Int.self, forKey: .endOffset)
        field = try container.decodeIfPresent(String.self, forKey: .field)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(documentID, forKey: .documentID)
        try container.encodeIfPresent(passageScore, forKey: .passageScore)
        try container.encodeIfPresent(passageText, forKey: .passageText)
        try container.encodeIfPresent(startOffset, forKey: .startOffset)
        try container.encodeIfPresent(endOffset, forKey: .endOffset)
        try container.encodeIfPresent(field, forKey: .field)
    }

}
