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

/** Usage information. */
public struct Usage {

    /// Number of features used in the API call.
    public var features: Int?

    /// Number of text characters processed.
    public var textCharacters: Int?

    /// Number of 10,000-character units processed.
    public var textUnits: Int?

    /**
     Initialize a `Usage` with member variables.

     - parameter features: Number of features used in the API call.
     - parameter textCharacters: Number of text characters processed.
     - parameter textUnits: Number of 10,000-character units processed.

     - returns: An initialized `Usage`.
    */
    public init(features: Int? = nil, textCharacters: Int? = nil, textUnits: Int? = nil) {
        self.features = features
        self.textCharacters = textCharacters
        self.textUnits = textUnits
    }
}

extension Usage: Codable {

    private enum CodingKeys: String, CodingKey {
        case features = "features"
        case textCharacters = "text_characters"
        case textUnits = "text_units"
        static let allValues = [features, textCharacters, textUnits]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        features = try container.decodeIfPresent(Int.self, forKey: .features)
        textCharacters = try container.decodeIfPresent(Int.self, forKey: .textCharacters)
        textUnits = try container.decodeIfPresent(Int.self, forKey: .textUnits)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(features, forKey: .features)
        try container.encodeIfPresent(textCharacters, forKey: .textCharacters)
        try container.encodeIfPresent(textUnits, forKey: .textUnits)
    }

}
