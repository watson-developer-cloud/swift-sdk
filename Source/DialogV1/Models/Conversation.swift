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
    
/** A dialog conversation. */
public struct Conversation: JSONDecodable {

    /// The nodes that were executed by the conversation.
    public let hitNodes: [HitNode]
    
    /// The conversation identifier.
    public let conversationID: Int
    
    /// The client identifier.
    public let clientID: Int
    
    /// The messages exchanged during the conversation.
    public let messages: [Message]
    
    /// The profile variables associated with the conversation.
    public let profile: [String: String]

    /// Used internally to initialize a `Conversation` model from JSON.
    public init(json: JSON) throws {
        hitNodes = try json.arrayOf("hit_nodes", type: HitNode.self)
        conversationID = try json.int("conversation_id")
        clientID = try json.int("client_id")
        messages = try json.arrayOf("messages", type: Message.self)

        let profileVariables = try json.array("profile")
        var profile = [String: String]()
        for variable in profileVariables {
            let name = try variable.string("name")
            let value = try variable.string("value")
            profile[name] = value
        }
        self.profile = profile
    }
}

/** A dialog hit node. */
public struct HitNode: JSONDecodable {
    
    /// The details of the node.
    public let details: String
    
    /// The label of the node.
    public let label: String
    
    /// The type of the node.
    public let type: String
    
    /// The node identifier.
    public let nodeID: Int

    /// Used internally to initialize a `HitNode` model from JSON.
    public init(json: JSON) throws {
        details = try json.string("details")
        label = try json.string("label")
        type = try json.string("type")
        nodeID = try json.int("node_id")
    }
}

/** A dialog message. */
public struct Message: JSONDecodable {
    
    /// The text of the message.
    public let text: String
    
    /// The date and time of the message.
    public let dateTime: String
    
    /// The client that prompted the message to be sent.
    public let fromClient: String

    /// Used internally to initialize a `Message` model from JSON.
    public init(json: JSON) throws {
        text = try json.string("text")
        dateTime = try json.string("date_time")
        fromClient = try json.string("from_client")
    } 
}
