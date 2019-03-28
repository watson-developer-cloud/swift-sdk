/**
 * Copyright IBM Corporation 2019
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
 An intent identified in the user input.
 */
public struct RuntimeIntent: Codable, Equatable {

    /**
     The name of the recognized intent.
     */
    public var intent: String

    /**
     A decimal percentage that represents Watson's confidence in the intent.
     */
    public var confidence: Double

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case intent = "intent"
        case confidence = "confidence"
        static let allValues = [intent, confidence]
    }

    /**
     Initialize a `RuntimeIntent` with member variables.

     - parameter intent: The name of the recognized intent.
     - parameter confidence: A decimal percentage that represents Watson's confidence in the intent.

     - returns: An initialized `RuntimeIntent`.
    */
    public init(
        intent: String,
        confidence: Double,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.intent = intent
        self.confidence = confidence
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        intent = try container.decode(String.self, forKey: .intent)
        confidence = try container.decode(Double.self, forKey: .confidence)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(intent, forKey: .intent)
        try container.encode(confidence, forKey: .confidence)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
