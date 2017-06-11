/**
 * Copyright IBM Corporation 2016
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
import RestKit

/** A response from the Conversation service. */
public struct MessageResponse: JSONDecodable {

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// The user input from the request.
    public let input: Input?

    /// Whether to return more than one intent.
    /// Included in the response only when sent with the request.
    public let alternateIntents: Bool?

    /// Information about the state of the conversation.
    public let context: Context

    /// An array of terms from the request that were identified as entities.
    /// The array is empty if no entities were identified.
    public let entities: [Entity]

    /// An array of terms from the request that were identified as intents. Each intent has an
    /// associated confidence. The list is sorted in descending order of confidence. If there are
    /// 10 or fewer intents then the sum of the confidence values is 100%. The array is empty if
    /// no intents were identified.
    public let intents: [Intent]

    /// An output object that includes the response to the user,
    /// the nodes that were hit, and messages from the log.
    public let output: Output

    /// Used internally to initialize a `MessageResponse` model from JSON.
    public init(json: JSON) throws {
        self.json = try json.getDictionaryObject()
        input = try? json.decode(at: "input")
        alternateIntents = try? json.getBool(at: "alternate_intents")
        context = try json.decode(at: "context")
        entities = try json.decodedArray(at: "entities", type: Entity.self)
        intents = try json.decodedArray(at: "intents",  type: Intent.self)
        output = try json.decode(at: "output")
    }
}
