//
//  AlchemyLanguage.swift
//  AlchemyLanguage
//
//  Created by Ruslan Ardashev on 11/4/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import WatsonCore


// MARK: AlchemyLanguage
// http://www.alchemyapi.com/products/alchemylanguage
// Entity Extraction
// Sentiment Analysis
// Keyword Extraction
// Concept Tagging
// Relation Extraction
// Taxonomy Classification
// Author Extraction
// Language Detection
// Text Extraction
// Microformats Parsing
// Feed Detection
// Linked Data Support
public final class AlchemyLanguage: Service {}


/**
 
 MARK: Entity Extraction
 
 http://www.alchemyapi.com/api/entity/proc.html

 public func URLGetRankedNamedEntities() {}
 public func HTMLGetRankedNamedEntities() {}
 public func TextGetRankedNamedEntities() {}

 */
public extension AlchemyLanguage {

    public func URLGetRankedNamedEntities() {}
    public func HTMLGetRankedNamedEntities() {}
    public func TextGetRankedNamedEntities() {}

}


/**
 
 MARK: Sentiment Analysis
 
 // http://www.alchemyapi.com/api/sentiment/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetTextSentiment() {}
    public func HTMLGetTextSentiment() {}
    public func TextGetTextSentiment() {}
    
    public func URLGetTargetedSentiment() {}
    public func HTMLGetTargetedSentiment() {}
    public func TextGetTargetedSentiment() {}
    
}


/**
 
 MARK: Keyword Extraction
 
 // http://www.alchemyapi.com/api/keyword/proc.html
 
 */
public extension AlchemyLanguage {

    public func URLGetRankedKeywords() {}
    public func HTMLGetRankedKeywords() {}
    public func TextGetRankedKeywords() {}

}


/**
 
 MARK: Concept Tagging
 
 // http://www.alchemyapi.com/api/concept/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetRankedConcepts() {}
    public func HTMLGetRankedConcepts() {}
    public func TextGetRankedConcepts() {}
    
}


/**
 
 MARK: Relation Extraction
 
 // http://www.alchemyapi.com/api/relation/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetRelations() {}
    public func HTMLGetRelations() {}
    public func TextGetRelations() {}
    
}


/**
 
 MARK: Taxonomy Classification
 
 // http://www.alchemyapi.com/api/taxonomy_calls/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetRankedTaxonomy() {}
    public func HTMLGetRankedTaxonomy() {}
    public func TextGetRankedTaxonomy() {}
    
}


/**
 
 MARK: Author Extraction
 
 // http://www.alchemyapi.com/api/author/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetAuthor() {}
    public func HTMLGetAuthor() {}
    public func TextGetAuthor() {}
    
}


/**
 
 MARK: Language Detection
 
 // http://www.alchemyapi.com/api/lang/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetLanguage() {}
    public func HTMLGetLanguage() {}
    public func TextGetLanguage() {}
    
}


/**
 
 MARK: Text Extraction
 
 // http://www.alchemyapi.com/api/text/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetText() {}
    public func HTMLGetText() {}
    
    public func URLGetRawText() {}
    public func HTMLGetRawText() {}
    
    public func URLGetTitle() {}
    public func HTMLGetTitle() {}
    
}


/**
 
 MARK: Microformats Parsing
 
 // http://www.alchemyapi.com/api/mformat/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetMicroformatData() {}
    public func HTMLGetMicroformatData() {}
    
}


/**
 
 MARK: Feed Detection
 
 // http://www.alchemyapi.com/api/feed-detection/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetFeedLinks() {}
    public func HTMLGetFeedLinks() {}
    
}
