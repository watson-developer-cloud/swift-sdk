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


public struct KeywordsResult: JSONDecodable,JSONEncodable {
    /// Relevance score from 0 to 1. Higher values indicate greater relevance
    public let relevance: Double?
    /// The keyword text
    public let text: String?

    /**
     Initialize a `KeywordsResult` with required member variables.


     - returns: An initialized `KeywordsResult`.
    */
    public init() {
    }

    /**
    Initialize a `KeywordsResult` with all member variables.

     - parameter relevance: Relevance score from 0 to 1. Higher values indicate greater relevance
     - parameter text: The keyword text

    - returns: An initialized `KeywordsResult`.
    */
    public init(relevance: Double, text: String) {
        self.relevance = relevance
        self.text = text
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `KeywordsResult` model from JSON.
    public init(json: JSON) throws {
        relevance = try? json.getString(at: "relevance")
        text = try? json.getString(at: "text")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `KeywordsResult` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let relevance = relevance { json["relevance"] = relevance }
        if let text = text { json["text"] = text }
        return json
    }
}
