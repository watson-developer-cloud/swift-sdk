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


public struct DocumentSentimentResults: JSONDecodable,JSONEncodable {
    /// Sentiment score from -1 (negative) to 1 (positive)
    public let score: Double?

    /**
     Initialize a `DocumentSentimentResults` with required member variables.


     - returns: An initialized `DocumentSentimentResults`.
    */
    public init() {
    }

    /**
    Initialize a `DocumentSentimentResults` with all member variables.

     - parameter score: Sentiment score from -1 (negative) to 1 (positive)

    - returns: An initialized `DocumentSentimentResults`.
    */
    public init(score: Double) {
        self.score = score
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `DocumentSentimentResults` model from JSON.
    public init(json: JSON) throws {
        score = try? json.getString(at: "score")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `DocumentSentimentResults` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let score = score { json["score"] = score }
        return json
    }
}
