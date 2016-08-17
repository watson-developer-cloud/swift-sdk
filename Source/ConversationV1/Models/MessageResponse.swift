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

/** A response from the Conversation service. */
public struct MessageResponse: JSONDecodable {
    
    /// The user input from the request.
    public let input: InputData
    
    /// Information about the state of the conversation.
    public let context: Context
    
    /// An array of terms from the request that were identified as entities.
    public let entities: [Entity]
    
    /// An array of terms from the request that were identified as intents. The list is sorted in
    /// descending order of confidence. If there are 10 or fewer intents, the sum of the confidence
    /// values is 100%.
    public let intents: [Intent]
    
    /// An output object that includes the response to the user,
    /// the nodes that were hit, and messages from the log.
    public let output: OutputData
    
    /// Used internally to initialize a `MessageResponse` model from JSON.
    public init(json: JSON) throws {
        input = try json.decode("input")
        context = try json.decode("context")
        entities = try json.arrayOf("entities", type: Entity.self)
        intents = try json.arrayOf("intents",  type: Intent.self)
        output = try json.decode("output")
    }
}
