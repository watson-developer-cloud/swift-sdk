/************************************************************************/
/*                                                                      */
/* IBM Confidential                                                     */
/* OCO Source Materials                                                 */
/*                                                                      */
/* (C) Copyright IBM Corp. 2001, 2016                                   */
/*                                                                      */
/* The source code for this program is not published or otherwise       */
/* divested of its trade secrets, irrespective of what has been         */
/* deposited with the U.S. Copyright Office.                            */
/*                                                                      */
/************************************************************************/

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