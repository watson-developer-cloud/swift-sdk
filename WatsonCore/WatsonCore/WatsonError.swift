//
//  WatsonError.swift
//  WatsonCore
//
//  Created by Glenn Fisher on 9/20/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

/**
The WatsonError function abstracts error-handling for all Watson SDK services.

WatsonError("WatsonSpeechToText: Could not connect to endpoint.")

:param: message A String that describes the error.
*/
public func WatsonError(message: String) {
    
    // todo: add support for logging, etc.
    
    print(message)
    
}