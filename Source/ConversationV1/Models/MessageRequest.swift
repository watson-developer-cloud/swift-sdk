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

/** A request formatted for the Conversation service. */
internal struct MessageRequest: JSONEncodable {
    
    private let text: String
    private let context: JSON?
    
    /**
     Create a `MessageRequest` with a message and context.
     
     - parameter message: The user's input message.
     - parameter context: The context, or state, associated with this request.
     */
    init(message: String, context: JSON? = nil) {
        self.text = message
        self.context = context
    }
    
    /// Used internally to serialize a `MessageRequest` model to JSON.
    func toJSON() -> JSON {
        var json = [String: JSON]()
        json["input"] = .Dictionary(["text": .String(text)])
        if let context = context {
            json["context"] = context
        }
        return JSON.Dictionary(json)
    }
}
