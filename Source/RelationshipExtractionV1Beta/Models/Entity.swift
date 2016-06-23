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
import Freddy

/** An entity object contains information about a specific entity in the input text. An entity is a 
 person, location, or event that is referred to by one or more mentions. */
public struct Entity: JSONDecodable {
    
    /// The alphanumeric identifier of the entity.
    public let entityID: String
    
    /// The type of the entity. This value is context-free. For a context-sensitive annotation, 
    /// refer to the 'entityRole' attribute of specific mentions to this entity.
    public let type: String
    
    /// Currently a placeholder for future enhancements.
    public let generic: Bool
    
    /// The class of the entity. Should be the same as the `mentionClass` of its primary mention.
    public let entityClass: EntityClass
    
    /// The level of the entity. Should be the same as the `mentionType` of its primary mention.
    public let level: EntityLevel
    
    /// Context-free subtype of the entity.
    public let subtype: String
    
    /// A confidence level for the accuracy of the entity annotation, ranging from 0 to 1.
    public let score: Double
    
    /// A list of mentions that reference this entity.
    public let mentions: [ReferencingMentions]
    
    /// Used internally to initialize an `Entity` model from JSON.
    public init(json: JSON) throws {
        entityID = try json.string("eid")
        type = try json.string("type")
        generic = try json.bool("generic")
        subtype = try json.string("subtype")
        score = try json.double("score")
        mentions = try json.arrayOf("mentref", type: ReferencingMentions.self)
        
        guard let eClass = EntityClass(rawValue: try json.string("class")) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: EntityClass.self)
        }
        entityClass = eClass
        
        guard let entityLevel = EntityLevel(rawValue: try json.string("level")) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: EntityLevel.self)
        }
        level = entityLevel
    }
}

/** A mention that references an identity. */
public struct ReferencingMentions: JSONDecodable {
    
    /// The alphanumeric identifier of the mention.
    public let mentionID: String
    
    /// The specific text of the mention.
    public let text: String
    
    /// Used internally to initialize a `ReferencingMentions` model from JSON.
    public init(json: JSON) throws {
        mentionID = try json.string("mid")
        text = try json.string("text")
    }
}

/** The class of the entity. */
public enum EntityClass: String {
    
    /// A reference to a specific thing.
    case Specific = "SPC"
    
    /// A negated reference to a specific thing.
    case Negated = "NEG"
    
    /// A generic reference that does not fit the other class types.
    case Generic = "GEN"
}

/** The level of the entity. */
public enum EntityLevel: String {
    
    /// A named entity, in the form of a proper name.
    case Named = "NAM"
    
    /// A nominal entity, not composed solely of a named entity or pronoun.
    case Nominal = "NOM"
    
    /// A pronoun.
    case Pronoun = "PRO"
    
    /// An entity that does not match any of the other types.
    case None = "NONE"
}
