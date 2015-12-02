//
//  DialogProfile.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/23/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import ObjectMapper

extension Dialog {
    
    public struct Profile: Mappable {
        
        var clientID: Int?
        var parameters: [Parameter]?
        
        public init(clientID: Int? = nil, parameters: [String: String]? = nil) {
            self.clientID = clientID
            if let parameters = parameters {
                var params = [Parameter]()
                for p in parameters {
                    let parameter = Parameter(name: p.0, value: p.1)
                    params.append(parameter)
                }
                self.parameters = params
            }
        }
        
        public init?(_: Map) {}
        
        mutating public func mapping(map: Map) {
            clientID   <- map["client_id"]
            parameters <- map["name_values"]
        }
    }
    
    public struct Parameter: Mappable {
        
        var name: String?
        var value: String?
        
        public init(name: String? = nil, value: String? = nil) {
            self.name = name
            self.value = value
        }
        
        public init?(_: Map) {}
        
        mutating public func mapping(map: Map) {
            value <- map["value"]
            name  <- map["name"]
        }
    }
}