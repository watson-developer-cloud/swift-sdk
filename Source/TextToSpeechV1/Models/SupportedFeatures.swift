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

    /// If `true`, the voice can be customized; if `false`, the voice cannot be customized. (Same as `customizable`.).
    public var customPronunciation: Bool

    /// If `true`, the voice can be transformed by using the SSML &lt;voice-transformation&gt; element; if `false`, the voice cannot be transformed.
    public var voiceTransformation: Bool

    /**
     Initialize a `SupportedFeatures` with member variables.

     - parameter customPronunciation: If `true`, the voice can be customized; if `false`, the voice cannot be customized. (Same as `customizable`.).
     - parameter voiceTransformation: If `true`, the voice can be transformed by using the SSML &lt;voice-transformation&gt; element; if `false`, the voice cannot be transformed.

     - returns: An initialized `SupportedFeatures`.
    */
    public init(customPronunciation: Bool, voiceTransformation: Bool) {
        self.customPronunciation = customPronunciation
        self.voiceTransformation = voiceTransformation
    }
}

extension SupportedFeatures: Codable {

    private enum CodingKeys: String, CodingKey {
        case customPronunciation = "custom_pronunciation"
        case voiceTransformation = "voice_transformation"
        static let allValues = [customPronunciation, voiceTransformation]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        customPronunciation = try container.decode(Bool.self, forKey: .customPronunciation)
        voiceTransformation = try container.decode(Bool.self, forKey: .voiceTransformation)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(customPronunciation, forKey: .customPronunciation)
        try container.encode(voiceTransformation, forKey: .voiceTransformation)
    }

}
