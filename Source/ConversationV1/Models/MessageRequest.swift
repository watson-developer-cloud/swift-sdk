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
    
    private let input: InputData
    private let context: Context?
    
    /**
     Create a `MessageRequest` with input and context.
     
     - parameter input: An input object that includes the input text.
     - parameter context: The context, or state, associated with this request.
     */
    init(input: InputData, context: Context? = nil) {
        self.input = input
        self.context = context
    }
    
    /**
     Create a `MessageRequest` with text and context.
     
     - parameter text: The user's input text.
     - parameter context: The context, or state, associated with this request.
     */
    init(text: String? = nil, context: Context? = nil) {
        let input = InputData(text: text)
        self.init(input: input, context: context)
    }
    
    /// Used internally to serialize a `MessageRequest` model to JSON.
    func toJSON() -> JSON {
        var json = [String: JSON]()
        json["input"] = input.toJSON()
        if let context = context {
            json["context"] = context.toJSON()
        }
        return JSON.Dictionary(json)
    }
}
