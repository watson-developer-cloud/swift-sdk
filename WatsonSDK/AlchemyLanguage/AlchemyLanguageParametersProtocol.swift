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
        
        let property = mirror.children.first

        return returnDictionary
        
    }
    
}
