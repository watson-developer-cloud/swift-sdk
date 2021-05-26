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
 Custom models for which the speaker has defined prompts.
 */
public struct SpeakerCustomModels: Codable, Equatable {

    /**
     An array of `SpeakerCustomModel` objects. Each object provides information about the prompts that are defined for a
     specified speaker in the custom models that are owned by a specified service instance. The array is empty if no
     prompts are defined for the speaker.
     */
    public var customizations: [SpeakerCustomModel]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case customizations = "customizations"
    }

}
