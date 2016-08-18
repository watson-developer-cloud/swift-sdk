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

/** The context, or state, associated with a message. */
public struct Context: JSONEncodable, JSONDecodable {
    
    /// The unique identifier of the conversation.
    public let conversationID: String?
    
    /// A system object that includes information about the dialog.
    public let system: SystemResponse?
    
    /**
     Create a `Context` to specify the context, or state, associated with a message.
 
     - parameter conversationID: The unique identifier of the conversation.
     - parameter system: A system object that includes information about the dialog.
     */
    public init(conversationID: String?, system: SystemResponse? = nil) {
        self.conversationID = conversationID
        self.system = system
    }
    
    /// Used internally to initialize a `Context` model from JSON.
    public init(json: JSON) throws {
        conversationID = try? json.string("conversation_id")
        system = try? json.decode("system", type: SystemResponse.self)
    }
    
    /// Used internally to serialize a `Context` model to JSON.
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        if let conversationID = conversationID {
            json["conversation_id"] = .String(conversationID)
        }
        if let system = system {
            json["system"] = system.toJSON()
        }
        return JSON.Dictionary(json)
    }
}

/** A system object that includes information about the dialog. */
public struct SystemResponse: JSONEncodable, JSONDecodable {
    
    /// An array of dialog node ids that are in focus in the conversation.
    public let dialogStack: [String]
    
    /// The number of cycles of user input and response in this conversation.
    public let dialogTurnCounter: Int
    
    /// The number of inputs in this conversation. This counter might be higher than the
    /// `dialogTurnCounter` when multiple inputs are needed before a response can be returned.
    public let dialogRequestCounter: Int
    
    /**
     Create a `SystemResponse`.

     - parameter dialogStack: An array of dialog node ids that are in focus in the conversation.
     - parameter dialogTurnCounter: The number of cycles of user input and response in the conversation.
     - parameter dialogRequestCounter: The number of inputs in this conversation. This counter might
        be higher than the `dialogTurnCounter` when multiple inputs are needed before a response
        can be returned.
     */
    public init(dialogStack: [String], dialogTurnCounter: Int, dialogRequestCounter: Int) {
        self.dialogStack = dialogStack
        self.dialogTurnCounter = dialogTurnCounter
        self.dialogRequestCounter = dialogRequestCounter
    }
    
    /// Used internally to initialize a `SystemResponse` model from JSON.
    public init(json: JSON) throws {
        dialogStack = try json.arrayOf("dialog_stack", type: Swift.String)
        dialogTurnCounter = try json.int("dialog_turn_counter")
        dialogRequestCounter = try json.int("dialog_request_counter")
    }
    
    /// Used internally to serialize a `SystemResponse` model to JSON.
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        json["dialog_stack"] = .Array(dialogStack.map { .String($0) })
        json["dialog_turn_counter"] = .Int(dialogTurnCounter)
        json["dialog_request_counter"] = .Int(dialogRequestCounter)
        return JSON.Dictionary(json)
    }
}
