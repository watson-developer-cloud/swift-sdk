//
//  BaseModel.swift
//  Alchemy
//
//  Created by Vincent Herrin on 10/1/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

public class BaseModel {
    
    internal var modelError: String = ""
    internal var rawData: NSData = NSData()
    
    init(rawData: NSData, modelError: String?) {
        
        self.modelError = modelError!
        self.rawData = rawData
    }
    
    init() { }
    
    //TODO: create a method to determine the output type
    
    
}