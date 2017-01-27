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

/** Results of the analysis, organized by feature */
public struct AnalysisResults: JSONDecodable,JSONEncodable {
    /// Language used to analyze the text
    public let language: String?
    /// Text that was used in the analysis
    public let analyzedText: String?
    /// URL that was used to retrieve HTML content
    public let retrievedUrl: String?
    public let usage: Any?
    public let features: Any?

    /**
     Initialize a `AnalysisResults` with required member variables.

     - returns: An initialized `AnalysisResults`.
    */
    public init() {
        self.language = nil
        self.analyzedText = nil
        self.retrievedUrl = nil
        self.usage = nil
        self.features = nil
    }

    /**
    Initialize a `AnalysisResults` with all member variables.

     - parameter language: Language used to analyze the text
     - parameter analyzedText: Text that was used in the analysis
     - parameter retrievedUrl: URL that was used to retrieve HTML content
     - parameter usage: 
     - parameter features: 

    - returns: An initialized `AnalysisResults`.
    */
    public init(language: String, analyzedText: String, retrievedUrl: String, usage: Any, features: Any) {
        self.language = language
        self.analyzedText = analyzedText
        self.retrievedUrl = retrievedUrl
        self.usage = usage
        self.features = features
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `AnalysisResults` model from JSON.
    public init(json: JSON) throws {
        language = try? json.getString(at: "language")
        analyzedText = try? json.getString(at: "analyzed_text")
        retrievedUrl = try? json.getString(at: "retrieved_url")
        usage = try? json.getJSON(at: "usage")
        features = try? json.getJSON(at: "features")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `AnalysisResults` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let language = language { json["language"] = language }
        if let analyzedText = analyzedText { json["analyzed_text"] = analyzedText }
        if let retrievedUrl = retrievedUrl { json["retrieved_url"] = retrievedUrl }
        if let usage = usage { json["usage"] = usage }
        if let features = features { json["features"] = features }
        return json
    }
}
