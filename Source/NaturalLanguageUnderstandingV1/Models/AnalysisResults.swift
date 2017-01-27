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

/** An object containing the results returned by the NLU service. */
public struct AnalysisResults: JSONDecodable {
    
    /// Language used to analyze the text.
    public let language: String?
    
    /// Text that was used in the analysis.
    public let analyzedText: String?
    
    /// URL that was used to retrieve HTML content.
    public let retrievedUrl: String?
    
    /// The number of features used in the API call.
    public let usage: Usage?
    
    /// The results returned by the features used to analyze the text.
    public let features: FeaturesResults?

    /// Used internally to initialize a `AnalysisResults` model from JSON.
    public init(json: JSON) throws {
        language = try? json.getString(at: "language")
        analyzedText = try? json.getString(at: "analyzed_text")
        retrievedUrl = try? json.getString(at: "retrieved_url")
        usage = try? json.decode(at: "usage", type: Usage.self)
        features = try? json.decode(at: "features", type: FeaturesResults.self)
    }
}

/** An object containing how many features used. */
public struct Usage: JSONDecodable {
    
    /// The number of features used in the API call.
    public let features: Int
    
    /// Used internally to initialize a 'Usage' model from JSON.
    public init(json: JSON) throws {
        features = try json.getInt(at: "features")
    }
}
