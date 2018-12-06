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

/**
 Tokenization dictionary describing how words are tokenized during ingestion and at query time.
 */
internal struct TokenDict: Codable, Equatable {

    /**
     An array of tokenization rules. Each rule contains, the original `text` string, component `tokens`, any alternate
     character set `readings`, and which `part_of_speech` the text is from.
     */
    public var tokenizationRules: [TokenDictRule]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case tokenizationRules = "tokenization_rules"
    }

    /**
     Initialize a `TokenDict` with member variables.

     - parameter tokenizationRules: An array of tokenization rules. Each rule contains, the original `text` string,
       component `tokens`, any alternate character set `readings`, and which `part_of_speech` the text is from.

     - returns: An initialized `TokenDict`.
    */
    public init(
        tokenizationRules: [TokenDictRule]? = nil
    )
    {
        self.tokenizationRules = tokenizationRules
    }

}
