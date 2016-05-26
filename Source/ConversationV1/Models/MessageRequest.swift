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

//Struct for Messages
internal struct MessageRequest: JSONEncodable {
    
    private let input:   [String: JSON]
    private let context: [String: JSON]?
    
    /**
     Create a `MessageRequest` with a message and context.
     
     - parameter message: The text of a message to be sent to the server.
     - parameter context: Context, or state, of this request.
     */
    internal init(message: String, context: [String: JSON]? = nil) {
        self.input   = ["text" : JSON.String(message)]
        self.context = context
    }
    
    /// Used internally to serialize a MessageRequest model to JSON.
    internal func toJSON() -> JSON {
        var json = [String: JSON]()
        json["input"] = .Dictionary(input)
        if let context = context { json["context"] = .Dictionary(context) }
        return JSON.Dictionary(json)
    }
}