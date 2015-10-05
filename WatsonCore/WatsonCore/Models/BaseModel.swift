//
//  BaseModel.swift
//  Alchemy
//
//  Created by Vincent Herrin on 10/1/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

public class BaseModel {
    
    /// TODO: Why in the world does this need to be public??  INVESTIGATE
    public var modelError: String = ""
    public var rawData: NSData = NSData()
    
    public init(rawData: NSData, modelError: String?) {
        
        self.modelError = modelError!
        self.rawData = rawData
    }
    
    public init() { }
    
    //TODO: create a method to determine the output type
    
    
}