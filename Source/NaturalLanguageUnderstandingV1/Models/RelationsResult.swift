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
 The relations between entities found in the content.
 */
public struct RelationsResult: Decodable {

    /**
     Confidence score for the relation. Higher values indicate greater confidence.
     */
    public var score: Double?

    /**
     The sentence that contains the relation.
     */
    public var sentence: String?

    /**
     The type of the relation.
     */
    public var type: String?

    /**
     The extracted relation objects from the text.
     */
    public var arguments: [RelationArgument]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case score = "score"
        case sentence = "sentence"
        case type = "type"
        case arguments = "arguments"
    }

}
