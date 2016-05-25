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
import Freddy

/**
 
 **SAORelation**
 
 Returned by the AlchemyLanguage service.
 
 */
extension AlchemyLanguageV1 {
    public struct SAORelation: JSONDecodable {
        public let action: Action?
        public let sentence: String?
        public let subject: Subject?
        public let object: RelationObject?
        
        public init(json: JSON) throws {
            action = try? json.decode("action", type: Action.self)
            sentence = try? json.string("sentence")
            subject = try? json.decode("subject", type: Subject.self)
            object = try? json.decode("object", type: RelationObject.self)
        }
        
    }
    
    public struct Action: JSONDecodable {
        public let text: String?
        public let lemmatized: String?
        public let verb: Verb?
        
        public init(json: JSON) throws {
            text = try? json.string("text")
            lemmatized = try? json.string("lemmatized")
            verb = try? json.decode("verb", type: Verb.self)
        }
        
        public struct Verb: JSONDecodable {
            public let text: String?
            public let tense: String?
            public let negated: Int?
            
            public init(json: JSON) throws {
                text = try? json.string("text")
                tense = try? json.string("tense")
                if let negatedString = try? json.string("negated") {
                    negated = Int(negatedString)
                } else {
                    negated = 0
                }
            }
        }
    }
    
    public struct Subject: JSONDecodable {
        public let text: String?
        public let sentiment: Sentiment?
        public let entity: Entity?
        
        public init(json: JSON) throws {
            text = try? json.string("text")
            sentiment = try? json.decode("sentiment", type: Sentiment.self)
            entity = try? json.decode("entity", type: Entity.self)
        }
    }
    
    public struct RelationObject: JSONDecodable {
        public let text: String?
        public let sentiment: Sentiment?
        public let sentimentFromSubject: Sentiment?
        public let entity: Entity?
        
        public init(json: JSON) throws {
            text = try? json.string("text")
            sentiment = try? json.decode("sentiment", type: Sentiment.self)
            sentimentFromSubject = try? json.decode("sentimentFromSubject", type: Sentiment.self)
            entity = try? json.decode("entity", type: Entity.self)
        }
    }
    
}
