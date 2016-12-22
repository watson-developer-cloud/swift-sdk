/**
 * Copyright IBM Corporation 2015
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

/** 
  Extracted topic categories. Can be up to five levels deeps. For example:
  /finance/personal finance/lending/credit cards
*/

public struct Taxonomy: JSONDecodable {
    
    /// will be "no" if categorization doesn't meet confidence standards
    public let confident: String?
    
    /// The detected topic category.
    public let label: String?
    
    /// The confidence score, 0.0 - 1.0 (higher is better).
    public let score: String?
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a Taxonomy object from JSON.
    public init(json: JSON) throws {
        confident = try? json.getString(at: "confident")
        label = try? json.getString(at: "label")
        score = try? json.getString(at: "score")
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize an 'Taxonomy' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}

