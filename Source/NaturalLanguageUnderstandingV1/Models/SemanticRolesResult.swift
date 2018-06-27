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
 The object containing the actions and the objects the actions act upon.
 */
public struct SemanticRolesResult: Decodable {

    /**
     Sentence from the source that contains the subject, action, and object.
     */
    public var sentence: String?

    /**
     The extracted subject from the sentence.
     */
    public var subject: SemanticRolesSubject?

    /**
     The extracted action from the sentence.
     */
    public var action: SemanticRolesAction?

    /**
     The extracted object from the sentence.
     */
    public var object: SemanticRolesObject?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case sentence = "sentence"
        case subject = "subject"
        case action = "action"
        case object = "object"
    }

}
