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
public struct TranslateRequest: Encodable {

    /**
     Input text in UTF-8 encoding. Multiple entries will result in multiple translations in the response.
     */
    public var text: [String]

    /**
     Model ID of the translation model to use. If this is specified, the **source** and **target** parameters will be
     ignored. The method requires either a model ID or both the **source** and **target** parameters.
     */
    public var modelID: String?

    /**
     Language code of the source text language. Use with `target` as an alternative way to select a translation model.
     When `source` and `target` are set, and a model ID is not set, the system chooses a default model for the language
     pair (usually the model based on the news domain).
     */
    public var source: String?

    /**
     Language code of the translation target language. Use with source as an alternative way to select a translation
     model.
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
     - parameter modelID: Model ID of the translation model to use. If this is specified, the **source** and
       **target** parameters will be ignored. The method requires either a model ID or both the **source** and
       **target** parameters.
     - parameter source: Language code of the source text language. Use with `target` as an alternative way to select
       a translation model. When `source` and `target` are set, and a model ID is not set, the system chooses a default
       model for the language pair (usually the model based on the news domain).
     - parameter target: Language code of the translation target language. Use with source as an alternative way to
       select a translation model.

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
