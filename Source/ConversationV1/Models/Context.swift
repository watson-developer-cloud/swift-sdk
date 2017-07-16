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
import RestKit

/** The context, or state, associated with a message. */
public struct Context: JSONEncodable, JSONDecodable {

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// The unique identifier of the conversation.
    public let conversationID: String

    /// A system object that includes information about the dialog.
    public let system: System

    /// Used internally to initialize a `Context` model from JSON.
    public init(json: JSON) throws {
        self.json = try json.getDictionaryObject()
        conversationID = try json.getString(at: "conversation_id")
        system = try json.decode(at: "system", type: System.self)
    }

    /// Used internally to serialize a `Context` model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}

/** A system object that includes information about the dialog. */
public struct System: JSONEncodable, JSONDecodable {

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// An array of dialog node ids that are in focus in the conversation. If no node is in the
    /// list, the conversation restarts at the root with the next request. If multiple dialog nodes
    /// are in the list, several dialogs are in progress, and the last ID in the list is active.
    /// When the active dialog ends, it is removed from the stack and the previous one becomes
    /// active.
    public let dialogStack: [String]

    /// The number of cycles of user input and response in this conversation.
    public let dialogTurnCounter: Int

    /// The number of inputs in this conversation. This counter might be higher than the
    /// `dialogTurnCounter` when multiple inputs are needed before a response can be returned.
    public let dialogRequestCounter: Int

    /// Used internally to initialize a `System` model from JSON.
    public init(json: JSON) throws {
        self.json = try json.getDictionaryObject()
        //dialogStack = try? json.getArray(at: "dialog_stack").map { try $0.getString(at: "dialog_node") }
        dialogStack = []
        dialogTurnCounter = try json.getInt(at: "dialog_turn_counter")
        dialogRequestCounter = try json.getInt(at: "dialog_request_counter")
    }

    /// Used internally to serialize a `System` model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
