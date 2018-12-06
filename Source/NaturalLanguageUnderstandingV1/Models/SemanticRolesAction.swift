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

/** SemanticRolesAction. */
public struct SemanticRolesAction: Codable, Equatable {

    /**
     Analyzed text that corresponds to the action.
     */
    public var text: String?

    /**
     normalized version of the action.
     */
    public var normalized: String?

    public var verb: SemanticRolesVerb?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case normalized = "normalized"
        case verb = "verb"
    }

}
