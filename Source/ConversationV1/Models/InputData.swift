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
import Freddy

/** An input object that includes the input text. */
public struct InputData: JSONEncodable, JSONDecodable {
    
    /// The user's input.
    public let text: String?
    
    /**
     Create an `InputData` with the user's input text.
 
     - parameter text: The user's input text.
     */
    internal init(text: String? = nil) {
        self.text = text
    }
    
    /// Used internally to serialize an `InputData` model from JSON.
    public init(json: JSON) throws {
        text = try? json.string("text")
    }
    
    /// Used internally to serialize an `InputData` model to JSON.
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        if let text = text {
            json["text"] = .String(text)
        }
        return JSON.Dictionary(json)
    }
}
