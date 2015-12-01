//
//  DialogContent.swift
//  Dialog
//
//  Created by Jonathan Ballands on 11/9/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

extension Dialog {
    
    public struct Node: Mappable {
        var content: String?
        var node: String?
        
        init(content: String? = nil, node: String? = nil) {
            self.content = content
            self.node = node
        }
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            content <- map["content"]
            node    <- map["node"]
        }
    }
}