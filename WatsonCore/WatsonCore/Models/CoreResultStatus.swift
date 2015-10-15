//
//  CoreResultStatus.swift
//  WatsonCore
//
//  Created by Vincent Herrin on 10/12/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CoreResultStatus {
    
    public let status: String!
    public let statusInfo: String!
    public let rawData: AnyObject!
    
    init(status: String, statusInfo: String, rawData: String = "") {
        self.status = status
        self.statusInfo = statusInfo
        self.rawData = rawData
    }
    
    init(anyObject: AnyObject) {
        // TODO "Need to add error handling and remove strings"
        
        var data = JSON(anyObject)
        if (data == nil) {
            status = "Error"
            statusInfo = "Unknown"
        }
        else if (data["status"].string == nil) {
            self.status = data["error_code"].intValue.description
            self.statusInfo = data["error_message"].string
        }
        else {
            self.status = data["status"].string
            self.statusInfo = data["statusInfo"].string
        }
        
        self.rawData = anyObject
    }
}
