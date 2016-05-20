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
    
/** An input model for content to be analyzed by Personality Insights. */
public struct ContentItem: JSONEncodable {

    private let id: String?
    private let userID: String?
    private let sourceID: String?
    private let created: Int?
    private let updated: Int?
    private let contentType: String?
    private let language: String?
    private let content: String
    private let parentID: String?
    private let reply: Bool?
    private let forward: Bool?

    /**
     Initialize a `ContentItem` to be analyzed by Personality Insights.

     - parameter id: Unique identifier for this content item.
     - parameter userID: Unique identifier for the author of this content.
     - parameter sourceID: Identifier for the source of this content. For example, blog123,
        or twitter.
     - parameter created: Timestamp that identifies when this content was created, in
        milliseconds since midnight 1/1/1970 UTC. Required only for results about temporal
        behavior data.
     - parameter updated: Timestamp that identifies when this content last updated, in
        milliseconds since midnight 1/1/1970 UTC. Required only for results about temporal
        behavior data.
     - parameter contentType: MIME type of the content. For example, "text/plain" (the default)
        or "text/html." The tags are stripped from HTML content before it is analyzed. Other
        MIME types are processed as-is.
     - parameter language: Language identifier (two-letter ISO 639-1 identifier). Both English
        ("en") and Spanish ("es") input content are supported. The default is English. In all
        cases, regional variants are treated as their parent language; for example, "en-US" is
        interpreted as "en".
     - parameter content: Content to be analyzed. Up to 20MB of content is supported.
     - parameter parentID: Unique id of the parent content item. Used to identify hierarchical
        relationships between posts/replies, messages/replies, etc.
     - parameter reply: Indicates whether this content item is a reply to another content item.
     - parameter forward: Indicates whether this content item is a forwarded/copied version of
        another content item.
    */
    public init(
        id: String? = nil,
        userID: String? = nil,
        sourceID: String? = nil,
        created: Int? = nil,
        updated: Int? = nil,
        contentType: String? = nil,
        language: String? = nil,
        content: String,
        parentID: String? = nil,
        reply: Bool? = nil,
        forward: Bool? = nil)
    {
        self.id = id
        self.userID = userID
        self.sourceID = sourceID
        self.created = created
        self.updated = updated
        self.contentType = contentType
        self.language = language
        self.content = content
        self.parentID = parentID
        self.reply = reply
        self.forward = forward
    }

    /// Used internally to serialize a `ContentItem` model to JSON.
    public func toJSON() -> JSON {
        var map = [String: JSON]()
        map["content"] = .String(content)
        if let id = id { map["id"] = .String(id) }
        if let userID = userID { map["userid"] = .String(userID) }
        if let sourceID = sourceID { map["sourceid"] = .String(sourceID) }
        if let created = created { map["created"] = .Int(created) }
        if let updated = updated { map["updated"] = .Int(updated) }
        if let contentType = contentType { map["contenttype"] = .String(contentType) }
        if let language = language { map["language"] = .String(language) }
        if let parentID = parentID { map["parentid"] = .String(parentID) }
        if let reply = reply { map["reply"] = .Bool(reply) }
        if let forward = forward { map["forward"] = .Bool(forward) }
        return JSON.Dictionary(map)
    }
}
