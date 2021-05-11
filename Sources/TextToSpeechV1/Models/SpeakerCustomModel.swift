/**
 * (C) Copyright IBM Corp. 2021.
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
 A custom models for which the speaker has defined prompts.
 */
public struct SpeakerCustomModel: Codable, Equatable {

    /**
     The customization ID (GUID) of a custom model for which the speaker has defined one or more prompts.
     */
    public var customizationID: String

    /**
     An array of `SpeakerPrompt` objects that provides information about each prompt that the user has defined for the
     custom model.
     */
    public var prompts: [SpeakerPrompt]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case customizationID = "customization_id"
        case prompts = "prompts"
    }

}
