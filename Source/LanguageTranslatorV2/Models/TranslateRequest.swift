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

/** TranslateRequest. */
public struct TranslateRequest {

    /// Input text in UTF-8 encoding. It is a list so that multiple paragraphs can be submitted. Also accept a single string, instead of an array, as valid input.
    public var text: [String]

    /// The unique model_id of the translation model being used to translate text. The model_id inherently specifies source language, target language, and domain. If the model_id is specified, there is no need for the source and target parameters and the values are ignored.
    public var modelID: String?

    /// Used in combination with target as an alternative way to select the model for translation. When target and source are set, and model_id is not set, the system chooses a default model with the right language pair to translate (usually the model based on the news domain).
    public var source: String?

    /// Used in combination with source as an alternative way to select the model for translation. When target and source are set, and model_id is not set, the system chooses a default model with the right language pair to translate (usually the model based on the news domain).
    public var target: String?

    /**
     Initialize a `TranslateRequest` with member variables.

     - parameter text: Input text in UTF-8 encoding. It is a list so that multiple paragraphs can be submitted. Also accept a single string, instead of an array, as valid input.
     - parameter modelID: The unique model_id of the translation model being used to translate text. The model_id inherently specifies source language, target language, and domain. If the model_id is specified, there is no need for the source and target parameters and the values are ignored.
     - parameter source: Used in combination with target as an alternative way to select the model for translation. When target and source are set, and model_id is not set, the system chooses a default model with the right language pair to translate (usually the model based on the news domain).
     - parameter target: Used in combination with source as an alternative way to select the model for translation. When target and source are set, and model_id is not set, the system chooses a default model with the right language pair to translate (usually the model based on the news domain).

     - returns: An initialized `TranslateRequest`.
    */
    public init(text: [String], modelID: String? = nil, source: String? = nil, target: String? = nil) {
        self.text = text
        self.modelID = modelID
        self.source = source
        self.target = target
    }
}

extension TranslateRequest: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case modelID = "model_id"
        case source = "source"
        case target = "target"
        static let allValues = [text, modelID, source, target]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode([String].self, forKey: .text)
        modelID = try container.decodeIfPresent(String.self, forKey: .modelID)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        target = try container.decodeIfPresent(String.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(modelID, forKey: .modelID)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(target, forKey: .target)
    }

}
