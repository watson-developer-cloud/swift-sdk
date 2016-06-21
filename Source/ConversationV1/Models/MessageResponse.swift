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
    
    /// The intents, or meanings, that Watson believes are
    /// associated with the input text based on the training data.
    public let intents: [Intent]?
    
    /// The entities, or specific named items,
    /// that were found in the input text.
    public let entities: [Entity]?
    
    /// The context of the conversation.
    public let context: JSON?
    
    /// Used internally to initialize a `MessageResponse` model from JSON.
    public init(json: JSON) throws {
        intents = try? json.arrayOf("intents",  type: Intent.self)
        entities = try? json.arrayOf("entities", type: Entity.self)
        context = json["context"]
    }
}

/** An intent, or meaning, that Watson believes is associated with some input text. */
public struct Intent: JSONDecodable {
    
    /// A particular intent that Watson believes is associated with the input text.
    public let intent: String
    
    /// The confidence score of the intent, between 0 and 1.
    public let confidence: Double
    
    /// Used internally to initialize an `Intent` model from JSON.
    public init(json: JSON) throws {
        intent = try json.string("intent")
        confidence = try json.double("confidence")
    }
}

/** An entity, or specific named item, that was found in the input text. */
public struct Entity: JSONDecodable {

    /// The name of the detected entity.
    public let entity: String
    
    /// The value of the detected entity.
    public let value: String
    
    /// The location of the detected entity, with the starting
    /// and ending indices as an offset.  E.g. [21, 33]
    public let location: [Int]
    
    /// Used internally to initialize an `Entity` model from JSON.
    public init(json: JSON) throws {
        entity = try json.string("entity")
        value = try json.string("value")
        location = try json.arrayOf("location")
    }
}