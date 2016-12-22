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

/**
 The attitude, opinion or feeling toward something, such as a person, organization,
 product or location.
 */
public struct Sentiment: JSONDecodable {
    
    /// Whether sentiment is mixed (both positive and negative) (1 == mixed)
    public let mixed: String?
    
    /// sentiment strength (0.0 == neutral)
    public let score: String?
    
    /// sentiment polarity - "positive", "negative", "neutral"
    public let type: String?
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a Sentiment object from JSON.
    public init(json: JSON) throws {
        mixed = try? json.getString(at: "mixed")
        score = try? json.getString(at: "score")
        type = try? json.getString(at: "type")
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize an 'Sentiment' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
