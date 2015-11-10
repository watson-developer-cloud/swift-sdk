//
//  Concept.swift
//  AlchemyLanguage
//
//  Created by Ruslan Ardashev on 11/9/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import WatsonCore

public final class Concept: AlchemyLanguageGenericModel {

    // MARK: AlchemyLanguageGenericModel
    public var totalTransactions: Int!
    
    // MARK: AlchemyLanguageGenericModel
    public var language: String!
    public var url: String!
    
    // MARK: Concept
    public var census: String!
    public var ciaFactbook: String!
    public var crunchbase: String!
    public var dbpedia: String!
    public var freebase: String!
    public var geo: String!
    public var geonames: String!
    
}
