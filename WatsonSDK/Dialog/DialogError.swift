//
//  DialogValidation.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/19/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Dialog {
    
    internal struct DialogError: WatsonError {
        var error: String!
        var code: Int!
        
        var nsError: NSError {
            let domain = Constants.errorDoman
            let userInfo = [NSLocalizedDescriptionKey: self.error]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        }
        
        init() {}
        
        init?(_ map: Map) {}
        
        mutating func mapping(map: Map) {
            error <- map["error"]
            code <- map["code"]
        }
    }
    
    
}