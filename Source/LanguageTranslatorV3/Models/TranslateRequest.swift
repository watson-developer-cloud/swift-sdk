/**
 * (C) Copyright IBM Corp. 2018, 2020.
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
internal struct TranslateRequest: Codable, Equatable {

    /**
     Input text in UTF-8 encoding. Multiple entries will result in multiple translations in the response.
     */
    public var text: [String]

    /**
     The model to use for translation. For example, `en-de` selects the IBM provided base model for English to German
     translation. A model ID overrides the source and target parameters and is required if you use a custom model. If no
     model ID is specified, you must specify a target language.
     */
    public var modelID: String?

    /**
     Language code that specifies the language of the source document.
     */
    public var source: String?

    /**
     Language code that specifies the target language for translation. Required if model ID is not specified.
     */
    public var target: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case modelID = "model_id"
        case source = "source"
        case target = "target"
    }

    /**
     Initialize a `TranslateRequest` with member variables.

     - parameter text: Input text in UTF-8 encoding. Multiple entries will result in multiple translations in the
       response.
     - parameter modelID: The model to use for translation. For example, `en-de` selects the IBM provided base model
       for English to German translation. A model ID overrides the source and target parameters and is required if you
       use a custom model. If no model ID is specified, you must specify a target language.
     - parameter source: Language code that specifies the language of the source document.
     - parameter target: Language code that specifies the target language for translation. Required if model ID is
       not specified.

     - returns: An initialized `TranslateRequest`.
     */
    public init(
        text: [String],
        modelID: String? = nil,
        source: String? = nil,
        target: String? = nil
    )
    {
        self.text = text
        self.modelID = modelID
        self.source = source
        self.target = target
    }

}
