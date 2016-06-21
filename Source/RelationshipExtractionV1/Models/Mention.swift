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

/** A Mention object contains annotations about a word or phrase that refers to an actual thing, or 
 entity, such as a person or location. */
public struct Mention: JSONDecodable {
    
    /// The alphanumberic identifier of the mention. The identifier consist of the id from the doc
    /// tag, followed by `-M` and the numeric identifier for the mention: doc_id-Mn.
    public let mentionID: String
    
    /// The type of the mention.
    public let type: MentionType
    
    /// The beginning character offset of the mention among all the text in the input.
    public let begin: Int
    
    /// The ending character offset of the mention among all the text in the input.
    public let end: Int
    
    /// The beginning character offset of the head word of the phrase. This will usually be the same
    /// as the value for begin.
    public let headBegin: Int
    
    /// The ending character offset of the head word of the phrase. This will usually be the same as
    /// the value for end.
    public let headEnd: Int
    
    /// The alphanumeric identifier of the specific entity referred to by this mention. Multiple
    /// mentions can refer to the same entity.
    public let entityID: String
    
    /// The type of the entity that this mention refers to.
    public let entityType: String
    
    /// The role the entity holds within this mention.
    public let entityRole: String
    
    /// Indicates whether this mention is a substitution used to refer to another entity.
    public let metonymy: Bool
    
    /// The class of this mention.
    public let mentionClass: MentionClass
    
    /// The confidence level for the accuracy of the mention annotation, on a range from 0 to 1.
    public let score: Double
    
    /// The confidence level for the accuracy of a mention that coreferences, or refers to, another
    /// mention, on a range from 0 to 1. Mentions that don't refer to other mentions will always
    /// have a corefScore of 1.
    public let corefScore: Double
    
    /// The specific text for this mention.
    public let text: String
    
    /// Used internally to initialize a `Mention` model from JSON.
    public init(json: JSON) throws {
        mentionID = try json.string("mid")
        begin = try json.int("begin")
        end = try json.int("end")
        headBegin = try json.int("head-begin")
        headEnd = try json.int("head-end")
        entityID = try json.string("eid")
        entityType = try json.string("etype")
        entityRole = try json.string("role")
        metonymy = try json.bool("metonymy")
        score = try json.double("score")
        corefScore = try json.double("corefScore")
        text = try json.string("text")
        
        guard let mentionType = MentionType(rawValue: try json.string("mtype")) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: MentionType.self)
        }
        type = mentionType
        
        guard let mClass = MentionClass(rawValue: try json.string("class")) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: MentionClass.self)
        }
        mentionClass = mClass
    }
}

/** The type of mention. */
public enum MentionType: String {
    
    /// A named entity mention, in the form of a proper name.
    case Named = "NAM"
    
    /// A nominal entity mention, not composed solely of a named entity or pronoun.
    case Nominal = "NOM"
    
    /// A pronoun mention.
    case Pronoun = "PRO"
    
    /// A mention that does not match any of the other types.
    case None = "NONE"
}

/** The class of the mention. */
public enum MentionClass: String {
    
    /// The mention is a reference to a specific thing.
    case Specific = "SPC"
    
    /// The mention is a negated reference to a specific thing.
    case Negated = "NEG"
    
    /// A generic mention that does not fit the other class types.
    case Generic = "GEN"
}
