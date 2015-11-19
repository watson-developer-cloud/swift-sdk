//
//  AlchemyLanguageParametersProtocol.swift
//  WatsonSDK
//
//  Created by Ruslan Ardashev on 11/18/15.
//  Copyright © 2015 IBM Watson Developer Cloud. All rights reserved.
//

import Foundation

protocol AlchemyLanguageParameters {}

extension AlchemyLanguageParameters {
    
    func asDictionary() -> [String : String] {
        
        var returnDictionary = [String : String]()
        
        let mirror = Mirror(reflecting: self)
        
        for property in mirror.children {
            
            if let label = property.label {
                
                let value = property.value
                let unwrappedValue = unwrap(value)
                returnDictionary.updateValue("\(unwrappedValue)", forKey: label)
                
            }
            
        }
        
        return returnDictionary
        
    }
    
    // Reference [1]
    func unwrap(any:Any) -> Any {
        
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .Optional {
            return any
        }
        
        if mi.children.count == 0 { return NSNull() }
        let (_, some) = mi.children.first!
        return some
        
    }
    
}

// REFERENCES
// [1] http://stackoverflow.com/questions/27989094/how-to-unwrap-an-optional-value-from-any-type
