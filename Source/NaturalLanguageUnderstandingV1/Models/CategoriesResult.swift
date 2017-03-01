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

/** The hierarchical 5-level taxonomy the content is categorized into. */
public struct CategoriesResult: JSONDecodable {
    
    /// The path to the category through the taxonomy hierarchy.
    public let label: String?
    
    /// Confidence score for the category classification. Higher values indicate greater confidence.
    public let score: Double?

    /// Used internally to initialize a `CategoriesResult` model from JSON.
    public init(json: JSON) throws {
        label = try? json.getString(at: "label")
        score = try? json.getDouble(at: "score")
    }
}
