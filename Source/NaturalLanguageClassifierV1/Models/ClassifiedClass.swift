/**
 * Copyright IBM Corporation 2018
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

/** Class and confidence. */
public struct ClassifiedClass {

    /// A decimal percentage that represents the confidence that Watson has in this class. Higher values represent higher confidences.
    public var confidence: Double?

    /// Class label.
    public var className: String?

    /**
     Initialize a `ClassifiedClass` with member variables.

     - parameter confidence: A decimal percentage that represents the confidence that Watson has in this class. Higher values represent higher confidences.
     - parameter className: Class label.

     - returns: An initialized `ClassifiedClass`.
    */
    public init(confidence: Double? = nil, className: String? = nil) {
        self.confidence = confidence
        self.className = className
    }
}

extension ClassifiedClass: Codable {

    private enum CodingKeys: String, CodingKey {
        case confidence = "confidence"
        case className = "class_name"
        static let allValues = [confidence, className]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        confidence = try container.decodeIfPresent(Double.self, forKey: .confidence)
        className = try container.decodeIfPresent(String.self, forKey: .className)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(confidence, forKey: .confidence)
        try container.encodeIfPresent(className, forKey: .className)
    }

}
