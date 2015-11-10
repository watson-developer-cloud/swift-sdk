//
//  Entity.swift
//  AlchemyLanguage
//
//  Created by Ruslan Ardashev on 11/9/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation

public final class Entity {
    
    var count: Int!
    var disambiguated: DisambiguatedLinks!
    var knowledgeGraph: KnowledgeGraph!
    var quotations: [Quotation]! = []
    var relevance: Double!
    var sentiment: Sentiment!
    var text: String!
    var type: String!
    
}
