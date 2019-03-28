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

/** AlignedElement. */
public struct AlignedElement: Codable, Equatable {

    /**
     Identifies two elements that semantically align between the compared documents.
     */
    public var elementPair: [ElementPair]?

    /**
     Specifies whether the aligned element is identical. Elements are considered identical despite minor differences
     such as leading punctuation, end-of-sentence punctuation, whitespace, the presence or absence of definite or
     indefinite articles, and others.
     */
    public var identicalText: Bool?

    /**
     One or more hashed values that you can send to IBM to provide feedback or receive support.
     */
    public var provenanceIDs: [String]?

    /**
     Indicates that the elements aligned are contractual clauses of significance.
     */
    public var significantElements: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case elementPair = "element_pair"
        case identicalText = "identical_text"
        case provenanceIDs = "provenance_ids"
        case significantElements = "significant_elements"
    }

}
