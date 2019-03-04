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

/** AudioResources. */
public struct AudioResources: Codable, Equatable {

    /**
     The total minutes of accumulated audio summed over all of the valid audio resources for the custom acoustic model.
     You can use this value to determine whether the custom model has too little or too much audio to begin training.
     */
    public var totalMinutesOfAudio: Double

    /**
     An array of `AudioResource` objects that provides information about the audio resources of the custom acoustic
     model. The array is empty if the custom model has no audio resources.
     */
    public var audio: [AudioResource]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case totalMinutesOfAudio = "total_minutes_of_audio"
        case audio = "audio"
    }

}
