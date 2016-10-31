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

/** A custom voice model used by the Text to Speech service. */
public struct CustomVoiceUpdate: JSONEncodable {
    
    /// The new name for the custom voice model.
    private let name: String?
    
    /// The new description for the custom voice model.
    private let description: String?
    
    /// A list of words and their translations from the custom voice model.
    private let words: [Word]
    
    /// Used to initialize a `CustomVoiceUpdate` model.
    public init(name: String? = nil, description: String? = nil, words: [Word] = []) {
        self.name = name
        self.description = description
        self.words = words
    }
    
    /// Used internally to serialize a `CustomVoiceUpdate` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let name = name {
            json["name"] = name
        }
        if let description = description {
            json["description"] = description
        }
        json["words"] = words.map { word in word.toJSONObject() }
        
        return json
    }
}
