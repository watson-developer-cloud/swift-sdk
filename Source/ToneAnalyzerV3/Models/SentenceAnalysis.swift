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
import RestKit

/** The result of analyzing a sentence within a document. */
public struct SentenceAnalysis: JSONDecodable {
    
    /// A unique number identifying this sentence within the document.
    public let sentenceID: Int
    
    /// The index of the character in the document where this sentence starts.
    public let inputFrom: Int
    
    /// The index of the character in the document after the end of this sentence
    /// (i.e. `inputTo - inputFrom` is the length of the sentence in characters).
    public let inputTo: Int
    
    /// The text of this sentence.
    public let text: String
    
    /// The tone analysis results for this sentence, divided into
    /// three categories: social tone, emotion tone, and writing tone.
    public let toneCategories: [ToneCategory]
    
    /// Used internally to initialize a `SentenceAnalysis` model from JSON.
    public init(json: JSON) throws {
        sentenceID = try json.getInt(at: "sentence_id")
        inputFrom = try json.getInt(at: "input_from")
        inputTo = try json.getInt(at: "input_to")
        text = try json.getString(at: "text")
        toneCategories = try json.decodedArray(at: "tone_categories", type: ToneCategory.self)
    }
}
