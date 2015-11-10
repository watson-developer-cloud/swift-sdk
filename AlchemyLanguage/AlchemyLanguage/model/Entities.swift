//
//  Entities.swift
//  AlchemyLanguage
//
//  Created by Ruslan Ardashev on 11/9/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation

/** 
 
 **Entities**
 
 Entities returned by the AlchemyLanguage service.
 
*/
public final class Entities: AlchemyLanguageGenericModel {
    
    // MARK: AlchemyLanguageGenericModel
    public var totalTransactions: Int!
    
    // MARK: AlchemyLanguageGenericModel
    public var language: String!
    public var url: String!
    
    // MARK: Entities
    public var entities: [Entity]! = []
    
}
