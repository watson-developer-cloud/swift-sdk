//
//  NSError.swift
//  WatsonSDK
//
//  Created by Robert Dickerson on 11/18/15.
//  Copyright © 2015 IBM Watson Developer Cloud. All rights reserved.
//

import Foundation

extension NSError
{
    public static func createWatsonError(code: Int, description: String) -> NSError {
    
        let domain = "com.ibm.mil"
        var userInfo =  [String: AnyObject]()
        userInfo["localizedDescription"] = description
    
        let newError = NSError(domain: domain, code: code, userInfo: userInfo )
        return newError
    }
}