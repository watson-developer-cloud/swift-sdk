/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import RestKit

/**
 
 **SAORelation**
 
 Extracted Subject, Action, and Object parts of a sentence
 
 */

public struct SAORelation: JSONDecodable {
    
    /// see Action
    public let action: Action?
    
    /// an extracted Sentence
    public let sentence: String?
    
    /// see Subject
    public let subject: Subject?
    
    /// see RelationObject
    public let object: RelationObject?
    
    /// Used internally to initialize a SAORelation object
    public init(json: [String: Any]) throws {
        action = try? json.object(at: "action")
        sentence = try? json.getString(at: "sentence")
        subject = try? json.object(at: "subject")
        object = try? json.object(at: "object")
    }
    
}

/**
 An action as defined by the AlchemyLanguage service
 */
public struct Action: JSONDecodable {
    
    /// text the action was extracted from
    public let text: String?
    
    /// the base or dictionary form of the word
    public let lemmatized: String?
    
    /// see Verb
    public let verb: Verb?
    
    /// Used internally to initialize an Action object
    public init(json: [String: Any]) throws {
        text = try? json.getString(at: "text")
        lemmatized = try? json.getString(at: "lemmatized")
        verb = try? json.object(at: "verb")
    }
    
    /**
     A verb as defined by the AlchemyLanguage service
     */
    public struct Verb: JSONDecodable {
        
        /// text the verb was extracted from
        public let text: String?
        
        /// the tense of the verb
        public let tense: String?
        
        /// was the verb negated
        public let negated: Int?
        
        /// Used internally to initalize a Verb object
        public init(json: [String: Any]) throws {
            text = try? json.getString(at: "text")
            tense = try? json.getString(at: "tense")
            if let negatedString = try? json.getString(at: "negated") {
                negated = Int(negatedString)
            } else {
                negated = 0
            }
        }
    }
}

/**
 A subjet extracted by the AlchemyLanguage service
 */
public struct Subject: JSONDecodable {
    
    /// text the subject was extracted from
    public let text: String?
    
    /// see **Sentiment**
    public let sentiment: Sentiment?
    
    /// see **Entity**
    public let entity: Entity?
    
    /// Used internally to initialize a Subject object
    public init(json: [String: Any]) throws {
        text = try? json.getString(at: "text")
        sentiment = try? json.object(at: "sentiment")
        entity = try? json.object(at: "entity")
    }
}

/**
 **Sentiment** related to the Subject-Action-Object extraction
 */
public struct RelationObject: JSONDecodable {
    
    /// text the relation object was extracted from
    public let text: String?
    
    /// see **Sentiment**
    public let sentiment: Sentiment?
    
    /// see **Sentiment**
    public let sentimentFromSubject: Sentiment?
    
    /// see **Entity**
    public let entity: Entity?
    
    /// Used internally to initialize a RelationObject object
    public init(json: [String: Any]) throws {
        text = try? json.getString(at: "text")
        sentiment = try? json.object(at: "sentiment")
        sentimentFromSubject = try? json.object(at: "sentimentFromSubject")
        entity = try? json.object(at: "entity")
    }
}


