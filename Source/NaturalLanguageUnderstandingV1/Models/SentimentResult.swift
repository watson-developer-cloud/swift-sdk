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

/** The sentiment of the content. */
public struct SentimentResult: JSONDecodable {
    
    /// The document level sentiment.
    public let document: DocumentSentimentResults?
    
    /// The targeted sentiment to analyze.
    public let targets: [TargetedSentimentResults]?

    /// Used internally to initialize a `SentimentResult` model from JSON.
    public init(json: JSON) throws {
        document = try? json.decode(at: "document", type: DocumentSentimentResults.self)
        targets = try? json.decodedArray(at: "targets", type: TargetedSentimentResults.self)
    }
}

/** The sentiment results of the document. */
public struct DocumentSentimentResults: JSONDecodable {
    
    /// Sentiment score from -1 (negative) to 1 (positive).
    public let score: Double?
    
    /// Used internally to initialize a `DocumentSentimentResults` model from JSON.
    public init(json: JSON) throws {
        score = try? json.getDouble(at: "score")
    }
}

/** The targeted sentiment results of the document. */
public struct TargetedSentimentResults: JSONDecodable {
    
    /// Targeted text.
    public let text: String?
    
    /// Sentiment score from -1 (negative) to 1 (positive).
    public let score: Double?
    
    /// Used internally to initialize a `TargetedSentimentResults` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        score = try? json.getDouble(at: "score")
    }
}
