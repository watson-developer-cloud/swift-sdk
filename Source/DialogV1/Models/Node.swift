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
    
/** A dialog node. */
public struct Node: JSONEncodable, JSONDecodable {
    
    /// The node's associated content.
    public let content: String
    
    /// The node's type.
    public let node: String

    /**
     Create a `Node` with associated content and a type.
 
     - parameter content: The node's associated content.
     - parameter node: The node's type.
     */
    public init(content: String, node: String) {
        self.content = content
        self.node = node
    }

    /// Used internally to initialize a `FaceTags` model from JSON.
    public init(json: JSON) throws {
        content = try json.getString(at: "content")
        node = try json.getString(at: "node")
    }

    /// Used internally to initialize a `FaceTags` model from JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["content"] = content
        json["node"] = node
        return json
    }
}
