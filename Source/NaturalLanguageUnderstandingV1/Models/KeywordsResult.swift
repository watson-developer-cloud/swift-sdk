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

/** The most important keywords in the content, organized by relevance. */
public struct KeywordsResult: JSONDecodable {
    
    /// Relevance score from 0 to 1. Higher values indicate greater relevance.
    public let relevance: Double?
    
    /// The text of the keyword.
    public let text: String?
    
    /// The sentiment value of the keyword.
    public let sentiment: KeywordSentiment?

    /// Used internally to initialize a `KeywordsResult` model from JSON.
    public init(json: JSON) throws {
        relevance = try? json.getDouble(at: "relevance")
        text = try? json.getString(at: "text")
        sentiment = try? json.decode(at: "sentiment", type: KeywordSentiment.self)
    }
    
    /** The sentiment of the entity. */
    public struct KeywordSentiment: JSONDecodable {
        
        /// The sentiment value of the found entity within the text from 0 to 1.
        public let score: Double?
        
        /// Used internally to initialize an `EntitySentiment` model from JSON.
        public init(json: JSON) throws {
            score = try? json.getDouble(at: "score")
        }
    }
}
