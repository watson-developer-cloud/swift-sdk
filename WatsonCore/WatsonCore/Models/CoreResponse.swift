//
//  Response.swift
//  WatsonCore
//
//  Scaled down version of Alamofire response object
//
//  Created by Vincent Herrin on 10/12/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import SwiftyJSON
import Foundation

public struct CoreResponse{

    /// The data returned by the server.
    public let data: AnyObject!

    public let status: String
    public let statusInfo: String
    public let statusCode: Int

    
    
    init(status: String, statusInfo: String, statusCode: Int = 0, data: AnyObject = "") {
        self.status = status
        self.statusInfo = statusInfo
        self.statusCode = statusCode
        self.data = data
    }
    
    init(anyObject: AnyObject, statusCode: Int) {
        //TODO: remove strings
        
        if (anyObject is String) {
            self.data = anyObject as! String
            self.statusCode = statusCode
            self.status = ""
            self.statusInfo = ""
        }
        else if (anyObject is NSError) {
            self.data = anyObject
            let nsError = (anyObject as! NSError)
            self.status = nsError.userInfo.description
            self.statusInfo = nsError.description
            self.statusCode = nsError.code
        }
        else {
            var data = JSON(anyObject)
            
            // Alchemy
            if let status = data["status"].string {
                self.status = status
                self.statusInfo = data["statusInfo"].stringValue
                self.data = anyObject
                self.statusCode = statusCode
            }
            // Language
            else if let error_message = data["error_message"].string {
                self.status = String(error_message)
                self.statusInfo = data["error_message"].stringValue
                self.data = anyObject
                self.statusCode = statusCode
            }
            // Something else so not sure what the object is
            else {
                if (statusCode == 200) {
                    status = "Ok"
                    statusInfo = ""
                }
                else {
                    status = "Error"
                    statusInfo = "Unknown"
                }

                self.data = anyObject
                self.statusCode = statusCode
            }
        }

    }
}