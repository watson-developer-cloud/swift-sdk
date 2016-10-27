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

/** An analysis of the input text, produced by the Relationship Extraction service. */
public struct Document: JSONDecodable {
    
    /// An optional identifier for the input text.
    public let id: String
    
    /// The input text that was analyzed.
    public let text: String
    
    /// An analysis of each sentence in the input text.
    public let sentences: [Sentence]
    
    /// A list of items of interest referred to in the input text.
    public let mentions: [Mention]
    
    /// A list of uniquely identified entities and their descriptions.
    public let entities: [Entity]
    
    /// The relationships that exist between different entities in the input text.
    public let relations: Relations
    
    /// Used internally to initialize a `Document` model from JSON.
    public init(json: JSON) throws {
        id = try json.getString(at: "id")
        text = try json.getString(at: "text")
        sentences = try json.decodedArray(at: "sents", "sent", type: Sentence.self)
        mentions = try json.decodedArray(at: "mentions", "mention", type: Mention.self)
        entities = try json.decodedArray(at: "entities", "entity", type: Entity.self)
        relations = try json.decode(at: "relations", type: Relations.self)
    }
}
