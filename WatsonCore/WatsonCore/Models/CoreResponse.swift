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

private enum CoreResponseEnum: String {
    case Status = "status"
    case StatusInfo = "statusInfo"
    case ErrorCode = "error_code"
    case ErrorMessage = "error_message"
    case Ok = "Ok"
    case Error = "Error"
    case Unknown = "Unknown"
    case Empty = ""
}

/**
*  The Main response back for Watson Core.  It will contain the status, status info
   and the status code for the http response.
*/
public struct CoreResponse{

    /// The data returned by the server.
    public let data: AnyObject!

    public let status: String
    public let statusInfo: String
    public let statusCode: Int

    /**
    Initialize core response by the caller
    
    - parameter status:     Status of the http respose
    - parameter statusInfo: Additional information that complements status
    - parameter statusCode: Status code returned from HTTP response
    - parameter data:       Payload returned from HTTP response
    */
    init(status: String, statusInfo: String, statusCode: Int = 0, data: AnyObject = "") {
        self.status = status
        self.statusInfo = statusInfo
        self.statusCode = statusCode
        self.data = data
    }
    
    /**
    Initialize core response based on Aggregate anyObject passed in
    
    - parameter anyObject:  Aggregate data of status and payload to be
    - parameter statusCode: Status code returned from HTTP response
    */
    init(anyObject: AnyObject, statusCode: Int) {
        self.statusCode = statusCode
        self.data = anyObject
        
        if (anyObject is String) {
            self.status = CoreResponseEnum.Empty.rawValue
            self.statusInfo = CoreResponseEnum.Empty.rawValue
        }
        else if (anyObject is NSError) {
            let nsError = (anyObject as! NSError)
            self.status = nsError.userInfo.description
            self.statusInfo = nsError.description
            
        }
        else {
            var returnData = JSON(anyObject)
            // Alchemy
            if let status = returnData[CoreResponseEnum.Status.rawValue].string {
                self.status = status
                self.statusInfo = returnData[CoreResponseEnum.StatusInfo.rawValue].stringValue
            }
            // Language
            else if let error_message = returnData[CoreResponseEnum.ErrorCode.rawValue].string {
                self.status = error_message
                self.statusInfo = returnData[CoreResponseEnum.ErrorMessage.rawValue].stringValue
            }
            // Something else so not sure what the object is
            else {
                if (statusCode == 200) {
                    status = CoreResponseEnum.Ok.rawValue
                    statusInfo = ""
                }
                else {
                    status = CoreResponseEnum.Error.rawValue
                    statusInfo = CoreResponseEnum.Unknown.rawValue
                }
            }
        }

    }
}