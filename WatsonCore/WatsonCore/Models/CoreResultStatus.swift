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
    
    public let status: String
    public let statusInfo: String
    public let statusCode: Int
    
    init(status: String, statusInfo: String, statusCode: Int = 200) {
        self.status = status
        self.statusInfo = statusInfo
        self.statusCode = statusCode
    }
    
    init(anyObject: AnyObject) {
        
        var data = JSON(anyObject)
        
        if let status = data["status"].string {
            self.status = status
            self.statusInfo = data["statusInfo"].stringValue
        }
        else if let error_message = data["error_message"].string {
            self.status = String(error_message)
            self.statusInfo = data["error_message"].stringValue
        }
        else {
            status = "Error"
            statusInfo = "Unknown"
        }
        
        // holder for now until I can get the actual value passed in
        self.statusCode = 200
    }
}
