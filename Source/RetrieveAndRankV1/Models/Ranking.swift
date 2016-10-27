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

/** Search results returned by the Retrieve and Rank service, ordered by their ranking. */
public struct Ranking: JSONDecodable {
    
    /// The unique ID of the ranker used.
    public let rankerID: String
    
    /// The name of the ranker.
    public let name: String?
    
    /// The link to the ranker.
    public let url: String
    
    /// The answer with the highest ranking score.
    public let topAnswer: String
    
    /// An array of up to 10 answers, sorted in descending order of ranking score.
    public let answers: [RankedAnswer]
    
    /// Used internally to initialize a `Ranking` model from JSON.
    public init(json: JSON) throws {
        rankerID = try json.getString(at: "ranker_id")
        name = try? json.getString(at: "name")
        url = try json.getString(at: "url")
        topAnswer = try json.getString(at: "top_answer")
        answers = try json.decodedArray(at: "answers", type: RankedAnswer.self)
    }
}

/** An answer and its associated ranking score. */
public struct RankedAnswer: JSONDecodable {
    
    /// The unique identifier of the answer in the collection.
    public let answerID: String
    
    /// The rank of this answer, compared to other answers. A higher value represents a higher
    /// relevance. The highest score is the sum of the number of potential answers.
    public let score: Double
    
    /// A decimal percentage from 0 to 1, describing the preference for this answer. A higher value
    /// represents a higher confidence.
    public let confidence: Double
    
    /// Used internally to initialize an `RankedAnswer` model from JSON.
    public init(json: JSON) throws {
        answerID = try json.getString(at: "answer_id")
        score = try json.getDouble(at: "score")
        confidence = try json.getDouble(at: "confidence")
    }
}
