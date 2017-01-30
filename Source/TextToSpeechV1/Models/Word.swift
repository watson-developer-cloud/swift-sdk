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

/** A model used by the Text To Speech service, containing a word and its translation. */
public struct Word: JSONEncodable, JSONDecodable {
    
    /// A word from the custom voice model.
    public let word: String
    
    /// The phonetic or sounds-like translation for the word.
    public let translation: String
    
    /// Used to initialize a `Word` model.
    public init(word: String, translation: String) {
        self.word = word
        self.translation = translation
    }
    
    /// Used internally to initialize a `Word` model from JSON.
    public init(json: JSON) throws {
        word = try json.getString(at: "word")
        translation = try json.getString(at: "translation")
    }
    
    /// Used internally to serialize a `Word` model to JSON.
    public func toJSONObject() -> Any {
        return ["word": word, "translation": translation]
    }
}
