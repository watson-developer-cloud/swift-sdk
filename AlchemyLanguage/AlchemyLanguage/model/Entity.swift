//
//  Entity.swift
//  AlchemyLanguage
//
//  Created by Ruslan Ardashev on 11/9/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation

public final class Entity {
    
    public var count: Int!
    public var disambiguated: DisambiguatedLinks!
    public var knowledgeGraph: KnowledgeGraph!
    public var quotations: [Quotation]! = []
    public var relevance: Double!
    public var sentiment: Sentiment!
    public var text: String!
    public var type: String!
    
}
