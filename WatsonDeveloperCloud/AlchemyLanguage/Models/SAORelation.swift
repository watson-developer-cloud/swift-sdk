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
import ObjectMapper

/**
 
 **SAORelation**
 
 Returned by the AlchemyLanguage service.
 
 */
public struct SAORelation: Mappable {
    
    /** how an object relates */
    public var action: Action?

    /** sentence in which it's used */
    public var sentence: String?

    /** object that acts upon another */
    public var object: RelationObject?

    /** subject of object's action */
    public var subject: Subject?
    
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        
        action <- map["action"]
        object <- map["object"]
        sentence <- map["sentence"]
        subject <- map["subject"]
        
    }
    
}


// MARK: **Action**
extension SAORelation {
    
    public struct Action: Mappable {
        
        public var lemmatized: String?
        public var text: String?
        public var verb: Verb?
        
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            
            lemmatized <- map["lemmatized"]
            text <- map["text"]
            verb <- map["verb"]
            
        }
        
    }
    
    // MARK: Verb
    public struct Verb: Mappable {
        
        public var negated: Int?
        public var tense: String?
        public var text: String?
        
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {

            negated <- (map["negated"], Transformation.stringToInt)
            tense <- map["tense"]
            text <- map["text"]
            
        }
        
    }
    
}


// MARK: **RelationObject**
extension SAORelation {
    
    public struct RelationObject: Mappable {

        public var entity: Entity?
        public var keywords: Keywords?
        public var sentiment: Sentiment?
        public var sentimentFromSubject: Sentiment?
        public var text: String?
        
        
        public init?(_ map: Map) {}

        public mutating func mapping(map: Map) {

            entity <- map["entity"]
            keywords <- map["keywords"]
            sentiment <- map["sentiment"]
            sentimentFromSubject <- map["sentimentFromSubject"]
            text <- map["text"]

        }
        
    }
    
}


// MARK: **Subject**
extension SAORelation {
    
    public struct Subject: Mappable {
        
        public var entity: Entity?
        public var keywords: Keywords?
        public var sentiment: Sentiment?
        public var text: String?
        
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            
            entity <- map["entity"]
            keywords <- map["keywords"]
            sentiment <- map["sentiment"]
            text <- map["text"]
            
        }
        
    }
    
}

