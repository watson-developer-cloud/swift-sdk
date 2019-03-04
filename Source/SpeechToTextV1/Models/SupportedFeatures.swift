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

/**
 Describes the additional service features that are supported with the model.
 */
public struct SupportedFeatures: Codable, Equatable {

    /**
     Indicates whether the customization interface can be used to create a custom language model based on the language
     model.
     */
    public var customLanguageModel: Bool

    /**
     Indicates whether the `speaker_labels` parameter can be used with the language model.
     */
    public var speakerLabels: Bool

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case customLanguageModel = "custom_language_model"
        case speakerLabels = "speaker_labels"
    }

}
