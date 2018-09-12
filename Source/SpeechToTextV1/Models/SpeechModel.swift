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

/** SpeechModel. */
public struct SpeechModel: Decodable {

    /**
     The name of the model for use as an identifier in calls to the service (for example, `en-US_BroadbandModel`).
     */
    public var name: String

    /**
     The language identifier of the model (for example, `en-US`).
     */
    public var language: String

    /**
     The sampling rate (minimum acceptable rate for audio) used by the model in Hertz.
     */
    public var rate: Int

    /**
     The URI for the model.
     */
    public var url: String

    /**
     Describes the additional service features supported with the model.
     */
    public var supportedFeatures: SupportedFeatures

    /**
     Brief description of the model.
     */
    public var description: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case language = "language"
        case rate = "rate"
        case url = "url"
        case supportedFeatures = "supported_features"
        case description = "description"
    }

}
