/**
 * Copyright IBM Corporation 2016
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

/** Extracted relationships between the subject, action and object parts of a sentence. */
public struct Relation: JSONDecodable {
    
    /// Action 
    public let action: Action?
    
    /// Object
    public let object: RelationObject?
    
    /// Entities
    public let entities: [Entity]?
    
    /// Subject
    public let subject: Subject?
    
    /// Sentence of the extracted Subject, Action, Object parts
    public let sentence: String?
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a Relation object from JSON.
    public init(json: JSON) throws {
        action = try? json.decode(at: "action", type: Action.self)
        object = try? json.decode(at: "object", type: RelationObject.self)
        entities = try? json.decodedArray(at: "entities", type: Entity.self)
        subject = try? json.decode(at: "subject", type: Subject.self)
        sentence = try? json.getString(at: "sentence")
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize a 'Relation' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}

/** The action as defined by the AlchemyLanguage service. */
public struct Action: JSONDecodable {
    
    /// Text the action was extracted from.
    public let text: String?
    
    /// see Verb
    public let verb: Verb?

    /// The base or dictionary form of the word.
    public let lemmatized: String?
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize an Action object from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        verb = try? json.decode(at: "verb", type: Verb.self)
        lemmatized = try? json.getString(at: "lemmatized")
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize an 'Action' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
    
    /** A verb as defined by the AlchemyLanguage service. */
    public struct Verb: JSONDecodable {
        
        /// Text the verb was extracted from.
        public let text: String?
        
        /// The tense of the verb.
        public let tense: String?
        
        /// Used internally to initalize a Verb object.
        public init(json: JSON) throws {
            text = try? json.getString(at: "text")
            tense = try? json.getString(at: "tense")
        }
    }
}

/** Object related to the Subject-Action-Object extraction. */
public struct RelationObject: JSONDecodable {
    
    /// keywords found by the SAO extraction
    public let keywords: [Keyword]?
    
    /// see **Entity**
    public let entities: [Entity]?
    
    /// text the relation object was extracted from
    public let text: String?
    
    /// see **Sentiment**
    public let sentiment: Sentiment?
    
    /// see **Sentiment**
    public let sentimentFromSubject: Sentiment?
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a RelationObject object from JSON.
    public init(json: JSON) throws {
        keywords = try? json.decodedArray(at: "keywords", type: Keyword.self)
        text = try? json.getString(at: "text")
        sentiment = try? json.decode(at: "sentiment", type: Sentiment.self)
        sentimentFromSubject = try? json.decode(at: "sentimentFromSubject", type: Sentiment.self)
        entities = try? json.decodedArray(at: "entities", type: Entity.self)
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize a 'RelationObject' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
    
    /** A keyword. */
    public struct Keyword: JSONDecodable {
        
        /// Text of the extracted keyword.
        public let text: String?
        
        /// How keywords are determined. Can be multiple levels deep.
        /// e.g. /companies/organizations/google finance
        public let knowledgeGraph: KnowledgeGraph?
        
        /// Used internally to initialize a Keyword object.
        public init(json: JSON) throws {
            text = try? json.getString(at: "text")
            knowledgeGraph = try? json.decode(at: "knowledgeGraph", type: KnowledgeGraph.self)
        }
    }
}

/** A subject extracted by the AlchemyLanguage service. */
public struct Subject: JSONDecodable {
    /// Keywords found by the extraction in the subject.
    public let keywords: [Keyword]?
    
    /// text the subject was extracted from
    public let text: String?
    
    /// see **Sentiment**
    public let sentiment: Sentiment?
    
    /// see **Entity**
    public let entities: [Entity]?
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a Subject object from JSON.
    public init(json: JSON) throws {
        keywords = try? json.decodedArray(at: "keywords", type: Keyword.self)
        text = try? json.getString(at: "text")
        sentiment = try? json.decode(at: "sentiment", type: Sentiment.self)
        entities = try? json.decodedArray(at: "entities", type: Entity.self)
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize a 'Subject' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
