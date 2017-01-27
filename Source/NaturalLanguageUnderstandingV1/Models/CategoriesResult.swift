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

public struct CategoriesResult: JSONDecodable,JSONEncodable {
    /// The path to the category through the taxonomy hierarchy
    public let label: String?
    /// Confidence score for the category classification. Higher values indicate greater confidence.
    public let score: Double?

    /**
     Initialize a `CategoriesResult` with required member variables.

     - returns: An initialized `CategoriesResult`.
    */
    public init() {
        self.label = nil
        self.score = nil
    }

    /**
    Initialize a `CategoriesResult` with all member variables.

     - parameter label: The path to the category through the taxonomy hierarchy
     - parameter score: Confidence score for the category classification. Higher values indicate greater confidence.

    - returns: An initialized `CategoriesResult`.
    */
    public init(label: String, score: Double) {
        self.label = label
        self.score = score
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `CategoriesResult` model from JSON.
    public init(json: JSON) throws {
        label = try? json.getString(at: "label")
        score = try? json.getDouble(at: "score")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `CategoriesResult` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let label = label { json["label"] = label }
        if let score = score { json["score"] = score }
        return json
    }
}
