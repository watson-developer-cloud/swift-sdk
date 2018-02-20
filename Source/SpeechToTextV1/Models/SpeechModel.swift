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
public struct SpeechModel {

    /// The name of the model for use as an identifier in calls to the service (for example, `en-US_BroadbandModel`).
    public var name: String

    /// The language identifier for the model (for example, `en-US`).
    public var language: String

    /// The sampling rate (minimum acceptable rate for audio) used by the model in Hertz.
    public var rate: Int

    /// The URI for the model.
    public var url: String

    /// Describes the additional service features supported with the model.
    public var supportedFeatures: SupportedFeatures

    /// Brief description of the model.
    public var description: String

    /// The URI for the model for use with the `POST /v1/sessions` method. (Returned only for requests for a single model with the `GET /v1/models/{model_id}` method.).
    public var sessions: String?

    /**
     Initialize a `SpeechModel` with member variables.

     - parameter name: The name of the model for use as an identifier in calls to the service (for example, `en-US_BroadbandModel`).
     - parameter language: The language identifier for the model (for example, `en-US`).
     - parameter rate: The sampling rate (minimum acceptable rate for audio) used by the model in Hertz.
     - parameter url: The URI for the model.
     - parameter supportedFeatures: Describes the additional service features supported with the model.
     - parameter description: Brief description of the model.
     - parameter sessions: The URI for the model for use with the `POST /v1/sessions` method. (Returned only for requests for a single model with the `GET /v1/models/{model_id}` method.).

     - returns: An initialized `SpeechModel`.
    */
    public init(name: String, language: String, rate: Int, url: String, supportedFeatures: SupportedFeatures, description: String, sessions: String? = nil) {
        self.name = name
        self.language = language
        self.rate = rate
        self.url = url
        self.supportedFeatures = supportedFeatures
        self.description = description
        self.sessions = sessions
    }
}

extension SpeechModel: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case language = "language"
        case rate = "rate"
        case url = "url"
        case supportedFeatures = "supported_features"
        case description = "description"
        case sessions = "sessions"
        static let allValues = [name, language, rate, url, supportedFeatures, description, sessions]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        language = try container.decode(String.self, forKey: .language)
        rate = try container.decode(Int.self, forKey: .rate)
        url = try container.decode(String.self, forKey: .url)
        supportedFeatures = try container.decode(SupportedFeatures.self, forKey: .supportedFeatures)
        description = try container.decode(String.self, forKey: .description)
        sessions = try container.decodeIfPresent(String.self, forKey: .sessions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(language, forKey: .language)
        try container.encode(rate, forKey: .rate)
        try container.encode(url, forKey: .url)
        try container.encode(supportedFeatures, forKey: .supportedFeatures)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(sessions, forKey: .sessions)
    }

}
