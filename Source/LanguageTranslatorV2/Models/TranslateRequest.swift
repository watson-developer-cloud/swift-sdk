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
    
/** A request to translate input text from a source language to a target language. */
internal struct TranslateRequest: JSONEncodable {

    private let modelID: String?
    private let source: String?
    private let target: String?
    private let text: [String]

    /**
     Initialize a translation request with input text and a model id.

     - parameter text: Input text in UTF-8 encoding. It is a list so that multiple
        sentences/paragraphs can be submitted.
     - parameter modelID: The unique modelID of the translation model being used to
        translate text. The modelID inherently specifies source language, target
        language and domain.

     - returns: An initialized `TranslateRequest` that represents a translation
        request to the Language Translator service.
     */
    init(text: [String], modelID: String) {
        self.modelID = modelID
        self.source = nil
        self.target = nil
        self.text = text
    }

    /**
     Initialize a translation request with input text, a source language, and a
     target language.

     - parameter text: Input text in UTF-8 encoding. It is a list so that multiple
        sentences/paragraphs can be submitted.
     - parameter source: The source language of the input text.
     - parameter target: The target language that the input text will be translated to.

     - returns: An initialized `TranslateRequest` that represents a translation
        request to the Language Translator service.
     */
    init(text: [String], source: String, target: String) {
        self.modelID = nil
        self.source = source
        self.target = target
        self.text = text
    }

    /// Used internally to serialize a `TranslateRequest` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let modelID = modelID { json["model_id"] = modelID }
        if let source = source { json["source"] = source }
        if let target = target { json["target"] = target }
        json["text"] = text
        return json
    }
}
