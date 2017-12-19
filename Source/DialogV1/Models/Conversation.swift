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
    public init(json: JSONWrapper) throws {
        hitNodes = try json.decodedArray(at: "hit_nodes", type: HitNode.self)
        conversationID = try json.getInt(at: "conversation_id")
        clientID = try json.getInt(at: "client_id")
        messages = try json.decodedArray(at: "messages", type: Message.self)

        let profileVariables = try json.getArray(at: "profile")
        var profile = [String: String]()
        for variable in profileVariables {
            let name = try variable.getString(at: "name")
            let value = try variable.getString(at: "value")
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
    public init(json: JSONWrapper) throws {
        details = try json.getString(at: "details")
        label = try json.getString(at: "label")
        type = try json.getString(at: "type")
        nodeID = try json.getInt(at: "node_id")
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
    public init(json: JSONWrapper) throws {
        text = try json.getString(at: "text")
        dateTime = try json.getString(at: "date_time")
        fromClient = try json.getString(at: "from_client")
    }
}
