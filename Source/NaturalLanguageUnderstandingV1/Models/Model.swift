/**
 * Copyright IBM Corporation 2017
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

/** Model. */
public struct Model {

    /// Shows as available if the model is ready for use.
    public var status: String?

    /// Unique model ID.
    public var modelID: String?

    /// ISO 639-1 code indicating the language of the model.
    public var language: String?

    /// Model description.
    public var description: String?

    /**
     Initialize a `Model` with member variables.

     - parameter status: Shows as available if the model is ready for use.
     - parameter modelID: Unique model ID.
     - parameter language: ISO 639-1 code indicating the language of the model.
     - parameter description: Model description.

     - returns: An initialized `Model`.
    */
    public init(status: String? = nil, modelID: String? = nil, language: String? = nil, description: String? = nil) {
        self.status = status
        self.modelID = modelID
        self.language = language
        self.description = description
    }
}

extension Model: Codable {

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case modelID = "model_id"
        case language = "language"
        case description = "description"
        static let allValues = [status, modelID, language, description]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        modelID = try container.decodeIfPresent(String.self, forKey: .modelID)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(modelID, forKey: .modelID)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(description, forKey: .description)
    }

}
