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

/** Voice. */
public struct Voice {

    /// The URI of the voice.
    public var url: String

    /// The gender of the voice: `male` or `female`.
    public var gender: String

    /// The name of the voice. Use this as the voice identifier in all requests.
    public var name: String

    /// The language and region of the voice (for example, `en-US`).
    public var language: String

    /// A textual description of the voice.
    public var description: String

    /// If `true`, the voice can be customized; if `false`, the voice cannot be customized. (Same as `custom_pronunciation`; maintained for backward compatibility.).
    public var customizable: Bool

    /// Describes the additional service features supported with the voice.
    public var supportedFeatures: SupportedFeatures

    /// Returns information about a specified custom voice model. **Note:** This field is returned only when you list information about a specific voice and specify the GUID of a custom voice model that is based on that voice.
    public var customization: VoiceModel?

    /**
     Initialize a `Voice` with member variables.

     - parameter url: The URI of the voice.
     - parameter gender: The gender of the voice: `male` or `female`.
     - parameter name: The name of the voice. Use this as the voice identifier in all requests.
     - parameter language: The language and region of the voice (for example, `en-US`).
     - parameter description: A textual description of the voice.
     - parameter customizable: If `true`, the voice can be customized; if `false`, the voice cannot be customized. (Same as `custom_pronunciation`; maintained for backward compatibility.).
     - parameter supportedFeatures: Describes the additional service features supported with the voice.
     - parameter customization: Returns information about a specified custom voice model. **Note:** This field is returned only when you list information about a specific voice and specify the GUID of a custom voice model that is based on that voice.

     - returns: An initialized `Voice`.
    */
    public init(url: String, gender: String, name: String, language: String, description: String, customizable: Bool, supportedFeatures: SupportedFeatures, customization: VoiceModel? = nil) {
        self.url = url
        self.gender = gender
        self.name = name
        self.language = language
        self.description = description
        self.customizable = customizable
        self.supportedFeatures = supportedFeatures
        self.customization = customization
    }
}

extension Voice: Codable {

    private enum CodingKeys: String, CodingKey {
        case url = "url"
        case gender = "gender"
        case name = "name"
        case language = "language"
        case description = "description"
        case customizable = "customizable"
        case supportedFeatures = "supported_features"
        case customization = "customization"
        static let allValues = [url, gender, name, language, description, customizable, supportedFeatures, customization]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
        gender = try container.decode(String.self, forKey: .gender)
        name = try container.decode(String.self, forKey: .name)
        language = try container.decode(String.self, forKey: .language)
        description = try container.decode(String.self, forKey: .description)
        customizable = try container.decode(Bool.self, forKey: .customizable)
        supportedFeatures = try container.decode(SupportedFeatures.self, forKey: .supportedFeatures)
        customization = try container.decodeIfPresent(VoiceModel.self, forKey: .customization)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(gender, forKey: .gender)
        try container.encode(name, forKey: .name)
        try container.encode(language, forKey: .language)
        try container.encode(description, forKey: .description)
        try container.encode(customizable, forKey: .customizable)
        try container.encode(supportedFeatures, forKey: .supportedFeatures)
        try container.encodeIfPresent(customization, forKey: .customization)
    }

}
