/**
 * Copyright IBM Corporation 2019
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

/**
 Returns tokens and sentences from the input text.
 */
public struct SyntaxOptions: Codable, Equatable {

    /**
     Tokenization options.
     */
    public var tokens: SyntaxOptionsTokens?

    /**
     Set this to `true` to return sentence information.
     */
    public var sentences: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case tokens = "tokens"
        case sentences = "sentences"
    }

    /**
     Initialize a `SyntaxOptions` with member variables.

     - parameter tokens: Tokenization options.
     - parameter sentences: Set this to `true` to return sentence information.

     - returns: An initialized `SyntaxOptions`.
    */
    public init(
        tokens: SyntaxOptionsTokens? = nil,
        sentences: Bool? = nil
    )
    {
        self.tokens = tokens
        self.sentences = sentences
    }

}
