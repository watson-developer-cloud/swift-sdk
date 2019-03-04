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

/** TranslateRequest. */
internal struct TranslateRequest: Codable, Equatable {

    /**
     Input text in UTF-8 encoding. Multiple entries will result in multiple translations in the response.
     */
    public var text: [String]

    /**
     A globally unique string that identifies the underlying model that is used for translation.
     */
    public var modelID: String?

    /**
     Translation source language code.
     */
    public var source: String?

    /**
     Translation target language code.
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
     - parameter modelID: A globally unique string that identifies the underlying model that is used for translation.
     - parameter source: Translation source language code.
     - parameter target: Translation target language code.

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
