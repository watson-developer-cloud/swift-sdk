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

/** RelationArgument. */
public struct RelationArgument: Codable, Equatable {

    /**
     An array of extracted entities.
     */
    public var entities: [RelationEntity]?

    /**
     Character offsets indicating the beginning and end of the mention in the analyzed text.
     */
    public var location: [Int]?

    /**
     Text that corresponds to the argument.
     */
    public var text: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case entities = "entities"
        case location = "location"
        case text = "text"
    }

}
