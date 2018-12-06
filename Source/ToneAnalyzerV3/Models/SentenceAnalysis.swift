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
public struct SentenceAnalysis: Codable, Equatable {

    /**
     The unique identifier of a sentence of the input content. The first sentence has ID 0, and the ID of each
     subsequent sentence is incremented by one.
     */
    public var sentenceID: Int

    /**
     The text of the input sentence.
     */
    public var text: String

    /**
     **`2017-09-21`:** An array of `ToneScore` objects that provides the results of the analysis for each qualifying
     tone of the sentence. The array includes results for any tone whose score is at least 0.5. The array is empty if no
     tone has a score that meets this threshold. **`2016-05-19`:** Not returned.
     */
    public var tones: [ToneScore]?

    /**
     **`2017-09-21`:** Not returned. **`2016-05-19`:** An array of `ToneCategory` objects that provides the results of
     the tone analysis for the sentence. The service returns results only for the tones specified with the `tones`
     parameter of the request.
     */
    public var toneCategories: [ToneCategory]?

    /**
     **`2017-09-21`:** Not returned. **`2016-05-19`:** The offset of the first character of the sentence in the overall
     input content.
     */
    public var inputFrom: Int?

    /**
     **`2017-09-21`:** Not returned. **`2016-05-19`:** The offset of the last character of the sentence in the overall
     input content.
     */
    public var inputTo: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case sentenceID = "sentence_id"
        case text = "text"
        case tones = "tones"
        case toneCategories = "tone_categories"
        case inputFrom = "input_from"
        case inputTo = "input_to"
    }

}
