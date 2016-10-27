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
 
 **Sentiment**
 
 Sentiment is the attitude, opinion or feeling toward something, such as a person, organization,
 product or location.
 
 */

public struct Sentiment: JSONDecodable {
    
    /** whether sentiment is mixed (both positive and negative) (1 == mixed) */
    public let mixed: Int?
    
    /** sentiment strength (0.0 == neutral) */
    public let score: Double?
    
    /** sentiment polarity - "positive", "negative", "neutral" */
    public let type: String?
    
    /// Used internally to initialize a Sentiment object
    public init(json: JSON) throws {
        if let mixString = try? json.getString(at: "mixed") {
            mixed = Int(mixString)
        } else {
            mixed = nil
        }
        if let scoreString = try? json.getString(at: "score") {
            score = Double(scoreString)
        } else {
            score = nil
        }
        type = try? json.getString(at: "type")
    }
}

