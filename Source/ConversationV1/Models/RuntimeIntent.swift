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

/** An intent identified in the user input. */
public struct RuntimeIntent {

    /// The name of the recognized intent.
    public let intent: String

    /// A decimal percentage that represents Watson's confidence in the intent.
    public let confidence: Double

    /// Additional properties associated with this model.
    public let additionalProperties: [String: JSON]?

    /**
     Initialize a `RuntimeIntent` with member variables.

     - parameter intent: The name of the recognized intent.
     - parameter confidence: A decimal percentage that represents Watson's confidence in the intent.

     - returns: An initialized `RuntimeIntent`.
    */
    public init(intent: String, confidence: Double, additionalProperties: [String: JSON]? = nil) {
        self.intent = intent
        self.confidence = confidence
        self.additionalProperties = additionalProperties
    }
}

extension RuntimeIntent: Codable {

    private enum CodingKeys: String, CodingKey {
        case intent = "intent"
        case confidence = "confidence"
        static let allValues = [intent, confidence]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dynamic = try decoder.container(keyedBy: DynamicKeys.self)
        intent = try container.decode(String.self, forKey: .intent)
        confidence = try container.decode(Double.self, forKey: .confidence)
        additionalProperties = try dynamic.decodeIfPresent([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var dynamic = encoder.container(keyedBy: DynamicKeys.self)
        try container.encode(intent, forKey: .intent)
        try container.encode(confidence, forKey: .confidence)
        try dynamic.encodeIfPresent(additionalProperties)
    }

}
