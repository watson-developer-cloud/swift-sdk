/**
 * Copyright IBM Corporation 2017
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

/** The object containing the actions and the objects the actions act upon. */
public struct SemanticRolesResult: JSONDecodable {
    
    /// Sentence from the source that contains the subject, action, and object.
    public let sentence: String?
    
    /// The extracted subject from the sentence.
    public let subject: SemanticRolesSubject?
    
    /// The extracted action from the sentence.
    public let action: SemanticRolesAction?
    
    /// The extracted object from the sentence.
    public let object: SemanticRolesObject?

    /// Used internally to initialize a `SemanticRolesResult` model from JSON.
    public init(json: JSON) throws {
        sentence = try? json.getString(at: "sentence")
        subject = try? json.decode(at: "subject", type: SemanticRolesSubject.self)
        action = try? json.decode(at: "action", type: SemanticRolesAction.self)
        object = try? json.decode(at: "object", type: SemanticRolesObject.self)
    }
}

/** The subject extracted from the text. */
public struct SemanticRolesSubject: JSONDecodable {
    
    /// Text that corresponds to the subject role.
    public let text: String?
    
    /// The entity of the subject.
    public let entities: [SemanticRolesEntity]?
    
    /// The keywords that provide context for the chosen entity.
    public let keywords: [SemanticRolesKeyword]?
    
    /// Used internally to initialize a `SemanticRolesSubject` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        entities = try? json.decodedArray(at: "entities", type: SemanticRolesEntity.self)
        keywords = try? json.decodedArray(at: "keywords", type: SemanticRolesKeyword.self)
    }
    
    /** The entity extracted from the text. */
    public struct SemanticRolesEntity: JSONDecodable {
        
        /// The entity type.
        public let type: String?
        
        /// The entity text.
        public let text: String?
        
        /// Used internally to initialize a `SemanticRolesEntity` model from JSON.
        public init(json: JSON) throws {
            type = try? json.getString(at: "type")
            text = try? json.getString(at: "text")
        }
    }
}

/** The action extracted from the text. */
public struct SemanticRolesAction: JSONDecodable {
    
    /// Analyzed text that corresponds to the action.
    public let text: String?
    
    /// The normalized version of the action.
    public let normalized: String?
    
    /// The extracted action.
    public let verb: SemanticRolesVerb?
    
    /// Used internally to initialize a `SemanticRolesAction` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        normalized = try? json.getString(at: "normalized")
        verb = try? json.decode(at: "verb", type: SemanticRolesVerb.self)
    }
    
    /** The verb extracted from the action. */
    public struct SemanticRolesVerb: JSONDecodable {
        
        /// The keyword text.
        public let text: String?
        
        /// Verb tense.
        public let tense: String?
        
        /// Used internally to initialize a `SemanticRolesVerb` model from JSON.
        public init(json: JSON) throws {
            text = try? json.getString(at: "text")
            tense = try? json.getString(at: "tense")
        }
    }
}

/** The object extracted from the text. */
public struct SemanticRolesObject: JSONDecodable {
    
    /// The text the relation object was extracted from.
    public let text: String?
    
    /// The keywords of the text.
    public let keywords: [SemanticRolesKeyword]?
    
    /// Used internally to initialize a `SemanticRolesObject` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        keywords = try? json.decodedArray(at: "keywords", type: SemanticRolesKeyword.self)
    }
}

/** The keywords extrated from the text. */
public struct SemanticRolesKeyword: JSONDecodable {
    
    /// The keyword text.
    public let text: String?
    
    /// Used internally to initialize a `SemanticRolesKeyword` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
    }
}
