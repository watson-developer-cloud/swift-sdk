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

/** Document conversion settings. */
public struct Conversions {

    /// A list of PDF conversion settings.
    public var pdf: PdfSettings?

    /// A list of Word conversion settings.
    public var word: WordSettings?

    /// A list of HTML conversion settings.
    public var html: HtmlSettings?

    /// Defines operations that can be used to transform the final output JSON into a normalized form. Operations are executed in the order that they appear in the array.
    public var jsonNormalizations: [NormalizationOperation]?

    /**
     Initialize a `Conversions` with member variables.

     - parameter pdf: A list of PDF conversion settings.
     - parameter word: A list of Word conversion settings.
     - parameter html: A list of HTML conversion settings.
     - parameter jsonNormalizations: Defines operations that can be used to transform the final output JSON into a normalized form. Operations are executed in the order that they appear in the array.

     - returns: An initialized `Conversions`.
    */
    public init(pdf: PdfSettings? = nil, word: WordSettings? = nil, html: HtmlSettings? = nil, jsonNormalizations: [NormalizationOperation]? = nil) {
        self.pdf = pdf
        self.word = word
        self.html = html
        self.jsonNormalizations = jsonNormalizations
    }
}

extension Conversions: Codable {

    private enum CodingKeys: String, CodingKey {
        case pdf = "pdf"
        case word = "word"
        case html = "html"
        case jsonNormalizations = "json_normalizations"
        static let allValues = [pdf, word, html, jsonNormalizations]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pdf = try container.decodeIfPresent(PdfSettings.self, forKey: .pdf)
        word = try container.decodeIfPresent(WordSettings.self, forKey: .word)
        html = try container.decodeIfPresent(HtmlSettings.self, forKey: .html)
        jsonNormalizations = try container.decodeIfPresent([NormalizationOperation].self, forKey: .jsonNormalizations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(pdf, forKey: .pdf)
        try container.encodeIfPresent(word, forKey: .word)
        try container.encodeIfPresent(html, forKey: .html)
        try container.encodeIfPresent(jsonNormalizations, forKey: .jsonNormalizations)
    }

}
