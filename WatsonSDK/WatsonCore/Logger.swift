//
//  WatsonLog.swift
//  WatsonCore
//
//  Created by Glenn Fisher on 9/20/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

/**
The WatsonLog function abstracts error-handling for all Watson SDK services.

WatsonLog("Could not connect to endpoint.", "[WatsonSpeechToText] ")

- parameter message: A string that describes the error
- parameter prefix: Prefix, such as a class name
*/
public func WatsonLog(message: String,prefix: String = "[WatsonSDK] ") {
    print(prefix + message)
}

/**
The WatsonDebug function invokes the Watson Log when the DEBUG symbol is turned on

WatsonDebug("Could not connect to endpoint.", "[WatsonSpeechToText] ")

- parameter message: A string that describes the error
- parameter prefix: Prefix, such as a class name
*/
public func WatsonDebug(message: String,prefix: String = "[WatsonSDK] ") {
    #if DEBUG
    WatsonLog(message,prefix: prefix)
    #endif
}