/**
 * Copyright 2015 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import WatsonCore
import ObjectMapper

/**
 
 **SAORelation**
 
 Returned by the AlchemyLanguage service.
 
 */
public struct SAORelation: AlchemyLanguageGenericModel, Mappable {
    
    // MARK: AlchemyGenericModel
    public var totalTransactions: Int!
    
    // MARK: AlchemyLanguageGenericModel
    public var language: String!
    public var url: String!
    
    // MARK: SAORelation
    public var action: Action!
    public var object: RelationObject!
    public var sentence: String!
    public var subject: Subject!
    
}


// MARK: **Action**
extension SAORelation {
    
    public struct Action {
        
        public var lemmatized: String!
        public var text: String!
        public var verb: Verb!
        
    }
    
    // MARK: Verb
    public struct Verb {
        
        public var negated: Int!
        public var tense: String!
        public var text: String!
        
    }
    
}


// MARK: **RelationObject**
extension SAORelation {
    
    public struct RelationObject {

        public var entity: Entity!
        public var keywords: Keywords!
        public var sentiment: Sentiment!
        public var sentimentFromSubject: Sentiment!
        public var text: String!
        
    }
    
}


// MARK: **Subject**
extension SAORelation {
    
    public struct Subject {
        
        public var entity: Entity!
        public var keywords: Keywords!
        public var sentiment: Sentiment!
        public var text: String!
        
    }
    
}

