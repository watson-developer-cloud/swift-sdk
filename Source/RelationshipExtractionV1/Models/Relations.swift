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

public struct Relations: JSONDecodable {
    public let relations: [Relation]
    public let version: String
    
    public init(json: JSON) throws {
        relations = try json.arrayOf("relations", "relation", type: Relation.self)
        version = try json.string("version")
    }
}

public struct Relation: JSONDecodable {
    public let relationID: String
    public let type: String
    public let subtype: String
    public let relationEntityArgument: RelationEntityArgument
    public let relatedMentions: RelatedMentions
    
    public init(json: JSON) throws {
        relationID = try json.string("rid")
        type = try json.string("type")
        subtype = try json.string("subtype")
        relationEntityArgument = try json.decode("rel_entity_arg")
        relatedMentions = try json.decode("relmentions")
    }
}

public struct RelationEntityArgument: JSONDecodable {
    public let entityID: String
    public let argumentNumber: Int
    
    public init(json: JSON) throws {
        entityID = try json.string("eid")
        argumentNumber = try json.int("argnum")
    }
}

public struct RelatedMentions: JSONDecodable {
    public let relatedMentionID: String
    public let score: Double
    public let relatedMentionClass: String
    public let modality: String
    public let tense: String
    public let relatedMentionArgument: RelatedMentionArgument
    
    public init(json: JSON) throws {
        relatedMentionID = try json.string("rmid")
        score = try json.double("score")
        relatedMentionClass = try json.string("class")
        modality = try json.string("modality")
        tense = try json.string("tense")
        relatedMentionArgument = try json.decode("rel_mention_arg")
    }
}

public struct RelatedMentionArgument: JSONDecodable {
    public let mentionID: String
    public let argumentNumber: Int
    public let text: String
    
    public init(json: JSON) throws {
        mentionID = try json.string("mid")
        argumentNumber = try json.int("argnum")
        text = try json.string("text")
    }
}
