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
 An object defining a single tokenizaion rule.
 */
public struct TokenDictRule: Codable, Equatable {

    /**
     The string to tokenize.
     */
    public var text: String

    /**
     Array of tokens that the `text` field is split into when found.
     */
    public var tokens: [String]

    /**
     Array of tokens that represent the content of the `text` field in an alternate character set.
     */
    public var readings: [String]?

    /**
     The part of speech that the `text` string belongs to. For example `noun`. Custom parts of speech can be specified.
     */
    public var partOfSpeech: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case tokens = "tokens"
        case readings = "readings"
        case partOfSpeech = "part_of_speech"
    }

    /**
     Initialize a `TokenDictRule` with member variables.

     - parameter text: The string to tokenize.
     - parameter tokens: Array of tokens that the `text` field is split into when found.
     - parameter partOfSpeech: The part of speech that the `text` string belongs to. For example `noun`. Custom parts
       of speech can be specified.
     - parameter readings: Array of tokens that represent the content of the `text` field in an alternate character
       set.

     - returns: An initialized `TokenDictRule`.
    */
    public init(
        text: String,
        tokens: [String],
        partOfSpeech: String,
        readings: [String]? = nil
    )
    {
        self.text = text
        self.tokens = tokens
        self.partOfSpeech = partOfSpeech
        self.readings = readings
    }

}
