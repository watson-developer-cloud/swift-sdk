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

/** An output object that includes the response to the user, the nodes that were hit, and messages from the log. */
public struct OutputData: JSONEncodable, JSONDecodable {
    
    /// An array of up to 50 messages logged with the request.
    public let logMessages: [LogMessageResponse]
    
    /// An array of responses to the user.
    public let text: [String]
    
    /// An array of the nodes that were executed to create the response. The information is
    /// useful for debugging and for visualizing the path taken through the node tree.
    public let nodesVisited: [String]
    
    /**
     Create an `OutputData`.
 
     - parameter logMessages: An array of up to 50 messages logged with the request.
     - parameter text: An array of responses to the user.
     - parameter nodesVisited: An array of the nodes that were executed to create the response.
        The information is iseful for debugging and for visualizing the path taken through the
        node tree.
     */
    public init(logMessages: [LogMessageResponse], text: [String], nodesVisited: [String]) {
        self.logMessages = logMessages
        self.text = text
        self.nodesVisited = nodesVisited
    }
    
    /// Used internally to initialize an `OutputData` model from JSON.
    public init(json: JSON) throws {
        logMessages = try json.arrayOf("log_messages", type: LogMessageResponse.self)
        text = try json.arrayOf("text", type: Swift.String)
        nodesVisited = try json.arrayOf("nodes_visited", type: Swift.String)
    }
    
    /// Used internally to serialize an `OutputData` model to JSON.
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        json["log_messages"] = .Array(logMessages.map { $0.toJSON() })
        json["text"] = .Array(text.map { .String($0) })
        json["nodes_visited"] = .Array(nodesVisited.map { .String($0) })
        return JSON.Dictionary(json)
    }
}

/** A message logged with the request. */
public struct LogMessageResponse: JSONEncodable, JSONDecodable {
    
    /// The severity of the message ("info", "error", or "warn")
    public let level: String?
    
    /// The log message
    public let message: String?
    
    /**
     Create a `LogMessageResponse`
 
     - parameter level: The severity of the message ("info", "error", or "warn").
     - parameter msg: The log message.
     */
    public init(level: String?, message: String?) {
        self.level = level
        self.message = message
    }
    
    /// Used internally to initialize a `LogMessageResponse` model from JSON.
    public init(json: JSON) throws {
        level = try? json.string("level")
        message = try? json.string("msg")
    }
    
    /// Used internally to serialize a `LogMessageResponse` model to JSON.
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        if let level = level {
            json["level"] = .String(level)
        }
        if let message = message {
            json["msg"] = .String(message)
        }
        return JSON.Dictionary(json)
    }
}
