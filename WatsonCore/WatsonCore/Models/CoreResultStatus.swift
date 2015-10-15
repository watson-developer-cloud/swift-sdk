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
        Log.sharedLogger.info("Need to add error handling and remove strings")
        var data = JSON(anyObject)
        self.status = data["status"].string
        self.statusInfo = data["statusInfo"].string
        self.rawData = anyObject
    }
}
