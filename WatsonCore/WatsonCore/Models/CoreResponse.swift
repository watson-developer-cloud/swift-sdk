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
import ObjectMapper
import Foundation

/**
*  The Main response back for Watson Core.  It will contain the status, status info
and the status code for the http response.
*/
public struct CoreResponse: Mappable, CustomStringConvertible {
    public var data:AnyObject?
    public var code:Int?
    public var info:String?
    public var help:String?
    
    //Alchemy
    public var totalTransactions:Int?
    public var usage:String?
    public var status:String?
    
    //Concept Expansion
    public var developer:String?
    
    //NSError
    public var domain:String?
    
    public var description: String {
        var desc = ""
        if let code = code {
            desc += "\nCode: \(code)"
        }
        if let status = status {
            desc += "\nStatus: \(status)"
        }
        if let domain = domain {
            desc += "\nDomain: \(domain)"
        }
        if let info = info {
            desc += "\nInfo: \(info)"
        }
        if let developer = developer {
            desc += "\nDeveloper: \(developer)"
        }
        if let help = help {
            desc += "\nHelp: \(help)"
        }
        return desc
    }

    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        //Maps most verbose information last, so that it takes precedence in case of overlapping information

        //NSError
        code                <-  map["errorCode"]
        domain              <-  map["errorDomain"]
        info                <-  map["errorLocalizedDescription"]

        //NSURLHTTPResponse
        code                <-  map["responseStatusCode"]
        info                <-  map["responseInfo"]
        
        //Standard
        data                <-  map["data"]
        code                <- (map["data.code"], Transformation.stringToInt)
        info                <-  map["data.error"]
        info                <-  map["data.error_message"]
        
        //Personality Insights
        help                <-  map["data.help"]
        info                <-  map["data.description"]
        
        //Concept Expansion
        code                <-  map["data.error.error_code"]
        info                <-  map["data.message"]
        info                <-  map["data.error.user_message"]
        developer           <-  map["data.error.dev_message"]
        help                <-  map["data.error.doc"]

        //Alchemy
        totalTransactions   <- (map["data.totalTransactions"], Transformation.stringToInt)
        status              <-  map["data.status"]
        usage               <-  map["data.usage"]
        info                <-  map["data.statusInfo"]
        
    }
}