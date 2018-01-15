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

/** Utterance. */
public struct Utterance {

    /// An utterance contributed by a user in the conversation that is to be analyzed. The utterance can contain multiple sentences.
    public var text: String

    /// A string that identifies the user who contributed the utterance specified by the `text` parameter.
    public var user: String?

    /**
     Initialize a `Utterance` with member variables.

     - parameter text: An utterance contributed by a user in the conversation that is to be analyzed. The utterance can contain multiple sentences.
     - parameter user: A string that identifies the user who contributed the utterance specified by the `text` parameter.

     - returns: An initialized `Utterance`.
    */
    public init(text: String, user: String? = nil) {
        self.text = text
        self.user = user
    }
}

extension Utterance: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case user = "user"
        static let allValues = [text, user]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        user = try container.decodeIfPresent(String.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(user, forKey: .user)
    }

}
