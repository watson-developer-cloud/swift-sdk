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
    public let responseStatusCode: Int
    public let serviceStatusCode: Int

    /**
    Initialize core response by the caller
    
    - parameter status:     Status of the http respose
    - parameter statusInfo: Additional information that complements status
    - parameter statusCode: Status code returned from HTTP response
    - parameter data:       Payload returned from HTTP response
    */
    init(status: String, statusInfo: String, responseStatusCode: Int = 0, serviceStatusCode: Int = 0, data: AnyObject = "") {
        self.status = status
        self.statusInfo = statusInfo
        self.responseStatusCode = responseStatusCode
        self.serviceStatusCode = serviceStatusCode
        self.data = data
    }
    
    /**
    Initialize core response based on Aggregate anyObject passed in
    
    - parameter anyObject:  Aggregate data of status and payload to be
    - parameter statusCode: Status code returned from HTTP response
    */
    init(anyObject: AnyObject, responseStatusCode: Int) {
        self.responseStatusCode = responseStatusCode
        self.data = anyObject
        Log.sharedLogger.verbose("\(anyObject)")
        if (anyObject is String) {
            self.status = CoreResponseEnum.Empty.rawValue
            self.statusInfo = CoreResponseEnum.Empty.rawValue
            self.serviceStatusCode = 0
        }
        else if (anyObject is NSError) {
            let nsError = (anyObject as! NSError)
            self.status = nsError.userInfo.description
            self.statusInfo = nsError.description
            self.serviceStatusCode = 0
            
        }
        else {
            var returnData = JSON(anyObject)
            // Alchemy
            if let status = returnData[CoreResponseEnum.Status.rawValue].string {
                self.status = status
                self.statusInfo = returnData[CoreResponseEnum.StatusInfo.rawValue].stringValue
                self.serviceStatusCode = 0
            }
            // Language
            else if let error_message = returnData[CoreResponseEnum.ErrorCode.rawValue].int {
                self.status = error_message.description
                self.statusInfo = returnData[CoreResponseEnum.ErrorMessage.rawValue].stringValue
                self.serviceStatusCode = error_message
            }
            // Something else so not sure what the object is
            else {
                if (responseStatusCode == 200) {
                    status = CoreResponseEnum.Ok.rawValue
                    statusInfo = ""
                    self.serviceStatusCode = 0
                }
                else {
                    Log.sharedLogger.error("\(anyObject)")
                    status = CoreResponseEnum.Error.rawValue
                    statusInfo = CoreResponseEnum.Unknown.rawValue
                    self.serviceStatusCode = 0
                }
            }
        }

    }
}