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
    private let entities: [Entity]?
    private let intents: [Intent]?
    private let output: OutputData?
    
    /**
     Create a `MessageRequest`.
     
     - parameter input: An input object that includes the input text.
     - parameter context: The context, or state, associated with this request.
     - parameter entities: An array of terms that shall be identified as entities
     - parameter intents: An array of terms that shall be identified as intents.
     - parameter output: An output object that includes the response to the user,
        the nodes that were hit, and messages from the log.
     */
    init(
        input: InputData,
        context: Context? = nil,
        entities: [Entity]? = nil,
        intents: [Intent]? = nil,
        output: OutputData? = nil)
    {
        self.input = input
        self.context = context
        self.entities = entities
        self.intents = intents
        self.output = output
    }
    
    /// Used internally to serialize a `MessageRequest` model to JSON.
    func toJSON() -> JSON {
        var json = [String: JSON]()
        json["input"] = input.toJSON()
        if let context = context {
            json["context"] = context.toJSON()
        }
        if let entities = entities {
            json["entities"] = .Array(entities.map {$0.toJSON()})
        }
        if let intents = intents {
            json["intents"] = .Array(intents.map {$0.toJSON()})
        }
        if let output = output {
            json["output"] = output.toJSON()
        }
        return JSON.Dictionary(json)
    }
}
