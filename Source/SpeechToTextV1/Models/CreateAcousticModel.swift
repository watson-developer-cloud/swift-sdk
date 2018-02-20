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

/** CreateAcousticModel. */
public struct CreateAcousticModel {

    /// A user-defined name for the new custom acoustic model. Use a name that is unique among all custom acoustic models that you own. Use a localized name that matches the language of the custom model. Use a name that describes the acoustic environment of the custom model, such as `Mobile custom model` or `Noisy car custom model`.
    public var name: String

    /// The name of the base language model that is to be customized by the new custom acoustic model. The new custom model can be used only with the base model that it customizes. To determine whether a base model supports acoustic model customization, refer to [Language support for customization](https://console.bluemix.net/docs/services/speech-to-text/custom.html#languageSupport).
    public var baseModelName: String

    /// A description of the new custom acoustic model. Use a localized description that matches the language of the custom model.
    public var description: String?

    /**
     Initialize a `CreateAcousticModel` with member variables.

     - parameter name: A user-defined name for the new custom acoustic model. Use a name that is unique among all custom acoustic models that you own. Use a localized name that matches the language of the custom model. Use a name that describes the acoustic environment of the custom model, such as `Mobile custom model` or `Noisy car custom model`.
     - parameter baseModelName: The name of the base language model that is to be customized by the new custom acoustic model. The new custom model can be used only with the base model that it customizes. To determine whether a base model supports acoustic model customization, refer to [Language support for customization](https://console.bluemix.net/docs/services/speech-to-text/custom.html#languageSupport).
     - parameter description: A description of the new custom acoustic model. Use a localized description that matches the language of the custom model.

     - returns: An initialized `CreateAcousticModel`.
    */
    public init(name: String, baseModelName: String, description: String? = nil) {
        self.name = name
        self.baseModelName = baseModelName
        self.description = description
    }
}

extension CreateAcousticModel: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case baseModelName = "base_model_name"
        case description = "description"
        static let allValues = [name, baseModelName, description]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        baseModelName = try container.decode(String.self, forKey: .baseModelName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(baseModelName, forKey: .baseModelName)
        try container.encodeIfPresent(description, forKey: .description)
    }

}
