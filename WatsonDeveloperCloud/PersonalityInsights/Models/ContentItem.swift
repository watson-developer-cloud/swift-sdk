/**
 * Copyright IBM Corporation 2015
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
import ObjectMapper

extension PersonalityInsights {
    
    /// An input model object used to pass detailed information about content items.
    public struct ContentItem: Mappable {
        
        /// Unique identifier for this content item
        public var ID:String?
        /// Unique identifier for the author of this content
        public var userID: String?
        /// Identifier for the source of this content. For example, blog123, twitter
        public var sourceID: String?
        /// Timestamp that identifies when this content was created. In milliseconds since midnight 1/1/1970 UTC
        public var created: Int?
        /// Timestamp that identifies when this content last updated. In milliseconds since midnight 1/1/1970 UTC
        public var updated: Int?
        /// MIME type of the content, for example, "text/plain, text/html". The tags are stripped from HTML content before it is analyzed. Other MIME types are processed as is
        public var contentType: String?
        public var charset: String?
        /// Language identifier (two-letter ISO 639-1 identifier). Currently only English content (en) is supported
        public var language: String?
        /// Content to be analyzed. Up to 20MB of content is supported
        public var content: String?
        /// Unique id of the parent content item. Used to identify hierarchical relationships between posts/replies, messages/replies, etc.
        public var parentID: String?
        /// Indicates whether this content item is a reply to another content item
        public var reply: Bool?
        /// Indicates whether this content item is a forwarded/copied version of another content item
        public var forward: Bool?
        
        public init?(_ map: Map) {}
        
        public init(ID:String?, userID:String?, sourceID:String?, created:Int?,
            updated:Int?, contentType:String?, charset:String?, language:String?,
            content:String?, parentID:String?, reply:Bool?, forward:Bool?) {
                
            self.ID = ID
            self.userID = userID
            self.sourceID = sourceID
            self.created = created
            self.updated = updated
            self.contentType = contentType
            self.charset = charset
            self.language = language
            self.content = content
            self.parentID = parentID
            self.reply = reply
            self.forward = forward
        }
        
        public mutating func mapping(map: Map) {
            ID          <- map["id"]
            userID      <- map["userid"]
            sourceID    <- map["sourceid"]
            created     <- map["created"]
            updated     <- map["updated"]
            contentType <- map["contenttype"]
            charset     <- map["charset"]
            language    <- map["language"]
            content     <- map["content"]
            parentID    <- map["parentid"]
            reply       <- map["reply"]
            forward     <- map["forward"]
        }
    }
}