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

/** A result produced by the Discovery service to analyze the input provided. */
public struct Result: JSONDecodable {
    /// The unique identifier of the document ID
    public let documentID: String?
    
    /// The score of the result.
    public let score: Double?
    
    public let extractedMetadata: String?
    
    public let html: String?
    
    public let text: String?
    
    public let enrichedText: EnrichedText?
    
    /// The enriched title of the result.
    public let enrichedTitle: String?
    
    /// The URL of the result.
    public let resultURL: String?
    
    public let key: String?
    
    public let matchingResults: Int?
    
    public let keyAsString: String?
    
    public let aggregations: [Aggregation]?
    
    /// Used internally to initialize a `Notice` model from JSON.
    public init(json: JSON) throws {
        documentID = try? json.getString(at: "id")
        score = try? json.getDouble(at: "score")
        extractedMetadata = try? json.getString(at: "extracted_metadata", "title")
        html = try? json.getString(at: "html")
        text = try? json.getString(at: "text")
        enrichedText = try? json.decode(at: "enriched_text", type: EnrichedText.self)
        enrichedTitle = try? json.getString(at: "enrichedTitle", "text")
        resultURL = try? json.getString(at: "url")
        key = try? json.getString(at: "key")
        matchingResults = try? json.getInt(at: "matching_results")
        keyAsString = try? json.getString(at: "key_as_string")
        aggregations = try? json.decodedArray(at: "aggregations", type: Aggregation.self)
    }
}
