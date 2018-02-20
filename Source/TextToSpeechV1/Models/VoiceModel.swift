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

/** VoiceModel. */
public struct VoiceModel {

    /// The customization ID (GUID) of the custom voice model. **Note:** When you create a new custom voice model, the service returns only the GUID of the new custom model; it does not return the other fields of this object.
    public var customizationID: String

    /// The name of the custom voice model.
    public var name: String?

    /// The language identifier of the custom voice model (for example, `en-US`).
    public var language: String?

    /// The GUID of the service credentials for the instance of the service that owns the custom voice model.
    public var owner: String?

    /// The date and time in Coordinated Universal Time (UTC) at which the custom voice model was created. The value is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
    public var created: String?

    /// The date and time in Coordinated Universal Time (UTC) at which the custom voice model was last modified. Equals `created` when a new voice model is first added but has yet to be updated. The value is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
    public var lastModified: String?

    /// The description of the custom voice model.
    public var description: String?

    /// An array of words and their translations from the custom voice model. The words are listed in alphabetical order, with uppercase letters listed before lowercase letters. The array is empty if the custom model contains no words. **Note:** This field is returned only when you list information about a specific custom voice model.
    public var words: [Word]?

    /**
     Initialize a `VoiceModel` with member variables.

     - parameter customizationID: The customization ID (GUID) of the custom voice model. **Note:** When you create a new custom voice model, the service returns only the GUID of the new custom model; it does not return the other fields of this object.
     - parameter name: The name of the custom voice model.
     - parameter language: The language identifier of the custom voice model (for example, `en-US`).
     - parameter owner: The GUID of the service credentials for the instance of the service that owns the custom voice model.
     - parameter created: The date and time in Coordinated Universal Time (UTC) at which the custom voice model was created. The value is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
     - parameter lastModified: The date and time in Coordinated Universal Time (UTC) at which the custom voice model was last modified. Equals `created` when a new voice model is first added but has yet to be updated. The value is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
     - parameter description: The description of the custom voice model.
     - parameter words: An array of words and their translations from the custom voice model. The words are listed in alphabetical order, with uppercase letters listed before lowercase letters. The array is empty if the custom model contains no words. **Note:** This field is returned only when you list information about a specific custom voice model.

     - returns: An initialized `VoiceModel`.
    */
    public init(customizationID: String, name: String? = nil, language: String? = nil, owner: String? = nil, created: String? = nil, lastModified: String? = nil, description: String? = nil, words: [Word]? = nil) {
        self.customizationID = customizationID
        self.name = name
        self.language = language
        self.owner = owner
        self.created = created
        self.lastModified = lastModified
        self.description = description
        self.words = words
    }
}

extension VoiceModel: Codable {

    private enum CodingKeys: String, CodingKey {
        case customizationID = "customization_id"
        case name = "name"
        case language = "language"
        case owner = "owner"
        case created = "created"
        case lastModified = "last_modified"
        case description = "description"
        case words = "words"
        static let allValues = [customizationID, name, language, owner, created, lastModified, description, words]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        customizationID = try container.decode(String.self, forKey: .customizationID)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        owner = try container.decodeIfPresent(String.self, forKey: .owner)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        lastModified = try container.decodeIfPresent(String.self, forKey: .lastModified)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        words = try container.decodeIfPresent([Word].self, forKey: .words)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(customizationID, forKey: .customizationID)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(owner, forKey: .owner)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(lastModified, forKey: .lastModified)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(words, forKey: .words)
    }

}
