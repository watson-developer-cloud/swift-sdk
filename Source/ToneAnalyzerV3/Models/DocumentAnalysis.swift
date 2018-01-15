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

/** DocumentAnalysis. */
public struct DocumentAnalysis {

    /// **`2017-09-21`:** An array of `ToneScore` objects that provides the results of the analysis for each qualifying tone of the document. The array includes results for any tone whose score is at least 0.5. The array is empty if no tone has a score that meets this threshold. **`2016-05-19`:** Not returned.
    public var tones: [ToneScore]?

    /// **`2017-09-21`:** Not returned. **`2016-05-19`:** An array of `ToneCategory` objects that provides the results of the tone analysis for the full document of the input content. The service returns results only for the tones specified with the `tones` parameter of the request.
    public var toneCategories: [ToneCategory]?

    /// **`2017-09-21`:** A warning message if the overall content exceeds 128 KB or contains more than 1000 sentences. The service analyzes only the first 1000 sentences for document-level analysis and the first 100 sentences for sentence-level analysis. **`2016-05-19`:** Not returned.
    public var warning: String?

    /**
     Initialize a `DocumentAnalysis` with member variables.

     - parameter tones: **`2017-09-21`:** An array of `ToneScore` objects that provides the results of the analysis for each qualifying tone of the document. The array includes results for any tone whose score is at least 0.5. The array is empty if no tone has a score that meets this threshold. **`2016-05-19`:** Not returned.
     - parameter toneCategories: **`2017-09-21`:** Not returned. **`2016-05-19`:** An array of `ToneCategory` objects that provides the results of the tone analysis for the full document of the input content. The service returns results only for the tones specified with the `tones` parameter of the request.
     - parameter warning: **`2017-09-21`:** A warning message if the overall content exceeds 128 KB or contains more than 1000 sentences. The service analyzes only the first 1000 sentences for document-level analysis and the first 100 sentences for sentence-level analysis. **`2016-05-19`:** Not returned.

     - returns: An initialized `DocumentAnalysis`.
    */
    public init(tones: [ToneScore]? = nil, toneCategories: [ToneCategory]? = nil, warning: String? = nil) {
        self.tones = tones
        self.toneCategories = toneCategories
        self.warning = warning
    }
}

extension DocumentAnalysis: Codable {

    private enum CodingKeys: String, CodingKey {
        case tones = "tones"
        case toneCategories = "tone_categories"
        case warning = "warning"
        static let allValues = [tones, toneCategories, warning]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tones = try container.decodeIfPresent([ToneScore].self, forKey: .tones)
        toneCategories = try container.decodeIfPresent([ToneCategory].self, forKey: .toneCategories)
        warning = try container.decodeIfPresent(String.self, forKey: .warning)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(tones, forKey: .tones)
        try container.encodeIfPresent(toneCategories, forKey: .toneCategories)
        try container.encodeIfPresent(warning, forKey: .warning)
    }

}
