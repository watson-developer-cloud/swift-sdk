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
public struct Utterance: Codable, Equatable {

    /**
     An utterance contributed by a user in the conversation that is to be analyzed. The utterance can contain multiple
     sentences.
     */
    public var text: String

    /**
     A string that identifies the user who contributed the utterance specified by the `text` parameter.
     */
    public var user: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case user = "user"
    }

    /**
     Initialize a `Utterance` with member variables.

     - parameter text: An utterance contributed by a user in the conversation that is to be analyzed. The utterance
       can contain multiple sentences.
     - parameter user: A string that identifies the user who contributed the utterance specified by the `text`
       parameter.

     - returns: An initialized `Utterance`.
    */
    public init(
        text: String,
        user: String? = nil
    )
    {
        self.text = text
        self.user = user
    }

}
