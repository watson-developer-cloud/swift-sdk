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
    
    /// The result of response serialization.
   // public let result: CoreResult<Value, Error>
    
    public let coreResultStatus: CoreResultStatus
   // public let coreResult: CoreResult<Value, Error>
    

    public init(data: AnyObject = "", coreResultStatus: CoreResultStatus /* coreResult: CoreResult<Value, Error> */) {
        self.data = data
        self.coreResultStatus = coreResultStatus
     //   self.coreResult = coreResult
    }
    
    init(anyObject: AnyObject) {
        self.data = anyObject
        self.coreResultStatus = CoreResultStatus(anyObject: anyObject)
    }
}