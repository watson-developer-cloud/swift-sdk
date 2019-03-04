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

/**
 Emotion analysis results for the entity, enabled with the `emotion` option.
 */
public struct EntitiesResultEmotion: Codable, Equatable {

    /**
     Anger score from 0 to 1. A higher score means that the text is more likely to convey anger.
     */
    public var anger: Double?

    /**
     Disgust score from 0 to 1. A higher score means that the text is more likely to convey disgust.
     */
    public var disgust: Double?

    /**
     Fear score from 0 to 1. A higher score means that the text is more likely to convey fear.
     */
    public var fear: Double?

    /**
     Joy score from 0 to 1. A higher score means that the text is more likely to convey joy.
     */
    public var joy: Double?

    /**
     Sadness score from 0 to 1. A higher score means that the text is more likely to convey sadness.
     */
    public var sadness: Double?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case anger = "anger"
        case disgust = "disgust"
        case fear = "fear"
        case joy = "joy"
        case sadness = "sadness"
    }

}
