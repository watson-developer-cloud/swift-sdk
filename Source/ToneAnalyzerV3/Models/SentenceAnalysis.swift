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

/** SentenceAnalysis. */
public struct SentenceAnalysis {

    /// The unique identifier of a sentence of the input content. The first sentence has ID 0, and the ID of each subsequent sentence is incremented by one.
    public var sentenceID: Int

    /// The text of the input sentence.
    public var text: String

    /// **`2017-09-21`:** An array of `ToneScore` objects that provides the results of the analysis for each qualifying tone of the sentence. The array includes results for any tone whose score is at least 0.5. The array is empty if no tone has a score that meets this threshold. **`2016-05-19`:** Not returned.
    public var tones: [ToneScore]?

    /// **`2017-09-21`:** Not returned. **`2016-05-19`:** An array of `ToneCategory` objects that provides the results of the tone analysis for the sentence. The service returns results only for the tones specified with the `tones` parameter of the request.
    public var toneCategories: [ToneCategory]?

    /// **`2017-09-21`:** Not returned. **`2016-05-19`:** The offset of the first character of the sentence in the overall input content.
    public var inputFrom: Int?

    /// **`2017-09-21`:** Not returned. **`2016-05-19`:** The offset of the last character of the sentence in the overall input content.
    public var inputTo: Int?

    /**
     Initialize a `SentenceAnalysis` with member variables.

     - parameter sentenceID: The unique identifier of a sentence of the input content. The first sentence has ID 0, and the ID of each subsequent sentence is incremented by one.
     - parameter text: The text of the input sentence.
     - parameter tones: **`2017-09-21`:** An array of `ToneScore` objects that provides the results of the analysis for each qualifying tone of the sentence. The array includes results for any tone whose score is at least 0.5. The array is empty if no tone has a score that meets this threshold. **`2016-05-19`:** Not returned.
     - parameter toneCategories: **`2017-09-21`:** Not returned. **`2016-05-19`:** An array of `ToneCategory` objects that provides the results of the tone analysis for the sentence. The service returns results only for the tones specified with the `tones` parameter of the request.
     - parameter inputFrom: **`2017-09-21`:** Not returned. **`2016-05-19`:** The offset of the first character of the sentence in the overall input content.
     - parameter inputTo: **`2017-09-21`:** Not returned. **`2016-05-19`:** The offset of the last character of the sentence in the overall input content.

     - returns: An initialized `SentenceAnalysis`.
    */
    public init(sentenceID: Int, text: String, tones: [ToneScore]? = nil, toneCategories: [ToneCategory]? = nil, inputFrom: Int? = nil, inputTo: Int? = nil) {
        self.sentenceID = sentenceID
        self.text = text
        self.tones = tones
        self.toneCategories = toneCategories
        self.inputFrom = inputFrom
        self.inputTo = inputTo
    }
}

extension SentenceAnalysis: Codable {

    private enum CodingKeys: String, CodingKey {
        case sentenceID = "sentence_id"
        case text = "text"
        case tones = "tones"
        case toneCategories = "tone_categories"
        case inputFrom = "input_from"
        case inputTo = "input_to"
        static let allValues = [sentenceID, text, tones, toneCategories, inputFrom, inputTo]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sentenceID = try container.decode(Int.self, forKey: .sentenceID)
        text = try container.decode(String.self, forKey: .text)
        tones = try container.decodeIfPresent([ToneScore].self, forKey: .tones)
        toneCategories = try container.decodeIfPresent([ToneCategory].self, forKey: .toneCategories)
        inputFrom = try container.decodeIfPresent(Int.self, forKey: .inputFrom)
        inputTo = try container.decodeIfPresent(Int.self, forKey: .inputTo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sentenceID, forKey: .sentenceID)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(tones, forKey: .tones)
        try container.encodeIfPresent(toneCategories, forKey: .toneCategories)
        try container.encodeIfPresent(inputFrom, forKey: .inputFrom)
        try container.encodeIfPresent(inputTo, forKey: .inputTo)
    }

}
