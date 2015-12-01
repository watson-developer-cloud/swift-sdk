//
//  Dialog.swift
//  Dialog
//
//  Created by Jonathan Ballands on 11/9/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

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
        
        var dialogID: DialogID?
        var name: String?
        
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