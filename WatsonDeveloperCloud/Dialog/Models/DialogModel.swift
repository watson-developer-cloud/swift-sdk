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
    
    // A collection of Dialog models
    internal struct DialogModelCollection: Mappable {
        
        // The Dialog models
        var dialogs: [DialogModel]?
        
        init?(_ map: Map) {}
        
        mutating func mapping(map: Map) {
            dialogs <- map["dialogs"]
        }
    }
    
    // A DialogID uniquely identifies a Dialog application
    public typealias DialogID = String
    
    // A Dialog model
    public struct DialogModel: Mappable {
        
        // The Dialog application identifier
        public var dialogID: DialogID?
        
        // The name of the Dialog application
        public var name: String?
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            dialogID <- map["dialog_id"]
            name     <- map["name"]
        }
    }
    
    // A Dialog model identifier
    internal struct DialogIDModel: Mappable {
        
        // The dialog identifier
        var id: DialogID?
        
        init?(_ map: Map) {}
        
        mutating func mapping(map: Map) {
            id <- map["dialog_id"]
        }
    }
}