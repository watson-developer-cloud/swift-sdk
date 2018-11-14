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
 Each object in the **results** array corresponds to an individual document returned by the original query.
 */
public struct LogQueryResponseResultDocumentsResult: Codable, Equatable {

    /**
     The result rank of this document. A position of `1` indicates that it was the first returned result.
     */
    public var position: Int?

    /**
     The **document_id** of the document that this result represents.
     */
    public var documentID: String?

    /**
     The raw score of this result. A higher score indicates a greater match to the query parameters.
     */
    public var score: Double?

    /**
     The confidence score of the result's analysis. A higher score indicating greater confidence.
     */
    public var confidence: Double?

    /**
     The **collection_id** of the document represented by this result.
     */
    public var collectionID: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case position = "position"
        case documentID = "document_id"
        case score = "score"
        case confidence = "confidence"
        case collectionID = "collection_id"
    }

}
