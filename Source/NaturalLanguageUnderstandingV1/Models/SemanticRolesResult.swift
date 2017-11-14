/**
 * Copyright IBM Corporation 2017
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

/** The object containing the actions and the objects the actions act upon. */
public struct SemanticRolesResult {

    /// Sentence from the source that contains the subject, action, and object.
    public var sentence: String?

    /// The extracted subject from the sentence.
    public var subject: SemanticRolesSubject?

    /// The extracted action from the sentence.
    public var action: SemanticRolesAction?

    /// The extracted object from the sentence.
    public var object: SemanticRolesObject?

    /**
     Initialize a `SemanticRolesResult` with member variables.

     - parameter sentence: Sentence from the source that contains the subject, action, and object.
     - parameter subject: The extracted subject from the sentence.
     - parameter action: The extracted action from the sentence.
     - parameter object: The extracted object from the sentence.

     - returns: An initialized `SemanticRolesResult`.
    */
    public init(sentence: String? = nil, subject: SemanticRolesSubject? = nil, action: SemanticRolesAction? = nil, object: SemanticRolesObject? = nil) {
        self.sentence = sentence
        self.subject = subject
        self.action = action
        self.object = object
    }
}

extension SemanticRolesResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case sentence = "sentence"
        case subject = "subject"
        case action = "action"
        case object = "object"
        static let allValues = [sentence, subject, action, object]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sentence = try container.decodeIfPresent(String.self, forKey: .sentence)
        subject = try container.decodeIfPresent(SemanticRolesSubject.self, forKey: .subject)
        action = try container.decodeIfPresent(SemanticRolesAction.self, forKey: .action)
        object = try container.decodeIfPresent(SemanticRolesObject.self, forKey: .object)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sentence, forKey: .sentence)
        try container.encodeIfPresent(subject, forKey: .subject)
        try container.encodeIfPresent(action, forKey: .action)
        try container.encodeIfPresent(object, forKey: .object)
    }

}
