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

/** UpdateVoiceModel. */
public struct UpdateVoiceModel {

    /// A new name for the custom voice model.
    public var name: String?

    /// A new description for the custom voice model.
    public var description: String?

    /// An array of words and their translations that are to be added or updated for the custom voice model. Pass an empty array to make no additions or updates.
    public var words: [Word]?

    /**
     Initialize a `UpdateVoiceModel` with member variables.

     - parameter name: A new name for the custom voice model.
     - parameter description: A new description for the custom voice model.
     - parameter words: An array of words and their translations that are to be added or updated for the custom voice model. Pass an empty array to make no additions or updates.

     - returns: An initialized `UpdateVoiceModel`.
    */
    public init(name: String? = nil, description: String? = nil, words: [Word]? = nil) {
        self.name = name
        self.description = description
        self.words = words
    }
}

extension UpdateVoiceModel: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case words = "words"
        static let allValues = [name, description, words]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        words = try container.decodeIfPresent([Word].self, forKey: .words)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(words, forKey: .words)
    }

}
