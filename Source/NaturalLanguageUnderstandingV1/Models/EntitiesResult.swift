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

/** The important people, places, geopolitical entities and other types of entities in your content. */
public struct EntitiesResult: JSONDecodable {
    
    /// The type of entity found in the content.
    public let type: String?
    
    /// Relevance score from 0 to 1. Higher values indicate greater relevance
    public let relevance: Double?
    
    /// The number of times the entity was mentioned in the text.
    public let count: Int?
    
    /// The name of the entity
    public let text: String?
    
    /// The sentiment of the entity.
    public let sentiment: EntitySentiment?

    /// Used internally to initialize an `EntitiesResult` model from JSON.
    public init(json: JSON) throws {
        type = try? json.getString(at: "type")
        relevance = try? json.getDouble(at: "relevance")
        count = try? json.getInt(at: "count")
        text = try? json.getString(at: "text")
        sentiment = try? json.decode(at: "sentiment", type: EntitySentiment.self)
    }
    
    /** The sentiment of the entity. */
    public struct EntitySentiment: JSONDecodable {
        
        /// The sentiment value of the found entity within the text from 0 to 1.
        public let score: Double?
        
        /// Used internally to initialize an `EntitySentiment` model from JSON.
        public init(json: JSON) throws {
            score = try? json.getDouble(at: "score")
        }
    }
}
