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

extension Dialog {

    internal struct DialogModelCollection: Mappable {
        
        var dialogs: [DialogModel]?
        
        init?(_ map: Map) {}
        
        mutating func mapping(map: Map) {
            dialogs <- map["dialogs"]
        }
    }

    public typealias DialogID = String
    
    public struct DialogModel: Mappable {
        
        public var dialogID: DialogID?
        public var name: String?
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            dialogID <- map["dialog_id"]
            name     <- map["name"]
        }
    }
    
    internal struct DialogIDModel: Mappable {
        
        var id: DialogID?
        
        init?(_ map: Map) {}
        
        mutating func mapping(map: Map) {
            id <- map["dialog_id"]
        }
    }
}