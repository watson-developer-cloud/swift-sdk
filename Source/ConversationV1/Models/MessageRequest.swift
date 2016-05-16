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

//Struct for Messages
public struct MessageRequest: JSONEncodable, JSONDecodable {
    
    var input:   [String: JSON]!
    var context: [String: JSON]?
    
    public init(message: String, tags: [String]? = nil, context: [String: JSON]? = nil) {
        self.input  = ["text" : JSON.String(message)]
        self.context = context
    }
    
    public init(json: JSON) throws {
        input   = try json.dictionary("input")
        context = try? json.dictionary("context")
    }
    
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        json["input"] = .Dictionary(input)
        if let context = context { json["context"] = .Dictionary(context) }
        return JSON.Dictionary(json)
    }
}