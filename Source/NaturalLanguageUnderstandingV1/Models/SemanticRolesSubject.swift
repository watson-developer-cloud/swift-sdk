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

/** SemanticRolesSubject. */
public struct SemanticRolesSubject {

    /// Text that corresponds to the subject role.
    public var text: String?

    public var entities: [SemanticRolesEntity]?

    public var keywords: [SemanticRolesKeyword]?

    /**
     Initialize a `SemanticRolesSubject` with member variables.

     - parameter text: Text that corresponds to the subject role.
     - parameter entities:
     - parameter keywords:

     - returns: An initialized `SemanticRolesSubject`.
    */
    public init(text: String? = nil, entities: [SemanticRolesEntity]? = nil, keywords: [SemanticRolesKeyword]? = nil) {
        self.text = text
        self.entities = entities
        self.keywords = keywords
    }
}

extension SemanticRolesSubject: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case entities = "entities"
        case keywords = "keywords"
        static let allValues = [text, entities, keywords]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        entities = try container.decodeIfPresent([SemanticRolesEntity].self, forKey: .entities)
        keywords = try container.decodeIfPresent([SemanticRolesKeyword].self, forKey: .keywords)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(entities, forKey: .entities)
        try container.encodeIfPresent(keywords, forKey: .keywords)
    }

}
