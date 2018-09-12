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
 An object defining the message input, intents, and entities to be sent to the Watson Assistant service if the user
 selects the corresponding disambiguation option.
 */
public struct DialogSuggestionValue: Codable {

    /**
     The user input.
     */
    public var input: InputData?

    /**
     An array of intents to be sent along with the user input.
     */
    public var intents: [RuntimeIntent]?

    /**
     An array of entities to be sent along with the user input.
     */
    public var entities: [RuntimeEntity]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case input = "input"
        case intents = "intents"
        case entities = "entities"
    }

    /**
     Initialize a `DialogSuggestionValue` with member variables.

     - parameter input: The user input.
     - parameter intents: An array of intents to be sent along with the user input.
     - parameter entities: An array of entities to be sent along with the user input.

     - returns: An initialized `DialogSuggestionValue`.
    */
    public init(
        input: InputData? = nil,
        intents: [RuntimeIntent]? = nil,
        entities: [RuntimeEntity]? = nil
    )
    {
        self.input = input
        self.intents = intents
        self.entities = entities
    }

}
