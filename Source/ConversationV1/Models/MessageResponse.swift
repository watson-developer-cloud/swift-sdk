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

/** A conversation response. */
public struct MessageResponse: JSONDecodable {
    
    // Context, or state, from the Conversation system
    public var context:  [String: JSON]?
    
    // Output, or response, from the system
    public var output:   [String: JSON]?
    
    // List of intents
    public var intents:  [Intent]?
    
    // List of entities
    public var entities: [Entity]?
    
    public init(json: JSON) throws {
        context  = try json.dictionary("context")
        output   = try json.dictionary("output")
        intents  = try json.arrayOf("intents",  type: Intent.self)
        entities = try json.arrayOf("entities", type: Entity.self)
    }
}

public struct Intent: JSONDecodable {
    
    // Classified intent for the requested input
    public var intent:     String?
    
    // Confidence of this intent
    public var confidence: Double?
    
    public init(json: JSON) throws {
        intent     = try json.string("intent")
        confidence = try json.double("confidence")
    }
}

public struct Entity: JSONDecodable {

    // Name of a detected entity
    public var entity  : String?
    
    // Value of the detected entity
    public var value   : String?
    
    // Location of the detected entity, with the starting and ending indices as an
    // offset.  E.g. [21, 33]
    public var location: [Int]?
    
    public init(json: JSON) throws {
        entity   = try json.string("entity")
        value    = try json.string("value")
        location = try json.arrayOf("location")
    }
}