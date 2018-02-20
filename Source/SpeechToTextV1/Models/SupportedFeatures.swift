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

/** SupportedFeatures. */
public struct SupportedFeatures {

    /// Indicates whether the customization interface can be used to create a custom language model based on the language model.
    public var customLanguageModel: Bool

    /// Indicates whether the `speaker_labels` parameter can be used with the language model.
    public var speakerLabels: Bool

    /**
     Initialize a `SupportedFeatures` with member variables.

     - parameter customLanguageModel: Indicates whether the customization interface can be used to create a custom language model based on the language model.
     - parameter speakerLabels: Indicates whether the `speaker_labels` parameter can be used with the language model.

     - returns: An initialized `SupportedFeatures`.
    */
    public init(customLanguageModel: Bool, speakerLabels: Bool) {
        self.customLanguageModel = customLanguageModel
        self.speakerLabels = speakerLabels
    }
}

extension SupportedFeatures: Codable {

    private enum CodingKeys: String, CodingKey {
        case customLanguageModel = "custom_language_model"
        case speakerLabels = "speaker_labels"
        static let allValues = [customLanguageModel, speakerLabels]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        customLanguageModel = try container.decode(Bool.self, forKey: .customLanguageModel)
        speakerLabels = try container.decode(Bool.self, forKey: .speakerLabels)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(customLanguageModel, forKey: .customLanguageModel)
        try container.encode(speakerLabels, forKey: .speakerLabels)
    }

}
