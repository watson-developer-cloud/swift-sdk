/**
 * (C) Copyright IBM Corp. 2018, 2022.
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
 Indicates whether select service features are supported with the model.
 */
public struct SupportedFeatures: Codable, Equatable {

    /**
     Indicates whether the customization interface can be used to create a custom language model based on the language
     model.
     */
    public var customLanguageModel: Bool

    /**
     Indicates whether the customization interface can be used to create a custom acoustic model based on the language
     model.
     */
    public var customAcousticModel: Bool

    /**
     Indicates whether the `speaker_labels` parameter can be used with the language model.
     **Note:** The field returns `true` for all models. However, speaker labels are supported for use only with the
     following languages and models:
     * _For previous-generation models,_ the parameter can be used with Australian English, US English, German,
     Japanese, Korean, and Spanish (both broadband and narrowband models) and UK English (narrowband model)
     transcription only.
     * _For next-generation models,_ the parameter can be used with Czech, English (Australian, Indian, UK, and US),
     German, Japanese, Korean, and Spanish transcription only.
     Speaker labels are not supported for use with any other languages or models.
     */
    public var speakerLabels: Bool

    /**
     Indicates whether the `low_latency` parameter can be used with a next-generation language model. The field is
     returned only for next-generation models. Previous-generation models do not support the `low_latency` parameter.
     */
    public var lowLatency: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case customLanguageModel = "custom_language_model"
        case customAcousticModel = "custom_acoustic_model"
        case speakerLabels = "speaker_labels"
        case lowLatency = "low_latency"
    }

}
