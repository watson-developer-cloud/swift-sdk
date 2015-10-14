//
//  Result.swift
//  WatsonCore
//
//  Created by Vincent Herrin on 10/12/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

public enum CoreResult<Value, Error: ErrorType> {
    case Success(Value)
    case Failure(Error)
    
    public var value: Value? {
        switch self {
        case .Success(let value):
            return value
        case .Failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .Success:
            return nil
        case .Failure(let error):
            return error
        }
    }
}

