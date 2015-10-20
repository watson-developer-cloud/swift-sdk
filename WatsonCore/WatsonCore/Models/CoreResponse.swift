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


public enum CoreResponseEnum: String {
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
    
    // private capture of the response to report back with certain values to the caller
    let httpResponse: NSHTTPURLResponse
    
    /// The data returned by the server.
    public let data: AnyObject!
    
    public var statusCode:Int {
        get {
            return HTTPStatusCode(HTTPResponse: httpResponse)!.rawValue
        }
    }
    
    private var _statusInfo: String! = nil
    
    public var statusInfo: String {
        get {
            
            if(_statusInfo == nil) {
                return HTTPStatusCode(HTTPResponse: httpResponse)!.description
            }
            return _statusInfo
        }
    }

    init(anyObject: AnyObject, httpresponse: NSHTTPURLResponse) {
        self.httpResponse = httpresponse
        self.data = anyObject
        Log.sharedLogger.verbose("\(anyObject)")

        if (anyObject is NSError) {
            _statusInfo = (anyObject as! NSError).description
        }
        else {
            var returnData = JSON(anyObject)
            // Alchemy
            if let _statusInfo = returnData[CoreResponseEnum.StatusInfo.rawValue].string {}
            // Language
            else if let _statusInfo = returnData[CoreResponseEnum.ErrorMessage.rawValue].string {}
        }
        
    }
}