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

        public var ID:String?
        public var userID: String?
        public var sourceID: String?
        public var created: Int?
        public var updated: Int?
        public var contentType: String?
        public var charset: String?
        public var language: String?
        public var content: String?
        public var parentID: String?
        public var reply: Bool?
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