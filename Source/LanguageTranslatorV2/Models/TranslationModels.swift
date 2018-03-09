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

/** The response type for listing existing translation models. */
public struct TranslationModels {

    /// An array of available models.
    public var models: [TranslationModel]

    /**
     Initialize a `TranslationModels` with member variables.

     - parameter models: An array of available models.

     - returns: An initialized `TranslationModels`.
    */
    public init(models: [TranslationModel]) {
        self.models = models
    }
}

extension TranslationModels: Codable {

    private enum CodingKeys: String, CodingKey {
        case models = "models"
        static let allValues = [models]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        models = try container.decode([TranslationModel].self, forKey: .models)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(models, forKey: .models)
    }

}
