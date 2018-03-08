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

/** VoiceModels. */
public struct VoiceModels {

    /// An array of `VoiceModel` objects that provides information about each available custom voice model. The array is empty if the requesting service credentials own no custom voice models (if no language is specified) or own no custom voice models for the specified language.
    public var customizations: [VoiceModel]

    /**
     Initialize a `VoiceModels` with member variables.

     - parameter customizations: An array of `VoiceModel` objects that provides information about each available custom voice model. The array is empty if the requesting service credentials own no custom voice models (if no language is specified) or own no custom voice models for the specified language.

     - returns: An initialized `VoiceModels`.
    */
    public init(customizations: [VoiceModel]) {
        self.customizations = customizations
    }
}

extension VoiceModels: Codable {

    private enum CodingKeys: String, CodingKey {
        case customizations = "customizations"
        static let allValues = [customizations]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        customizations = try container.decode([VoiceModel].self, forKey: .customizations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(customizations, forKey: .customizations)
    }

}
