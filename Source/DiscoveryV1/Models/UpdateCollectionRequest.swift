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

/** UpdateCollectionRequest. */
internal struct UpdateCollectionRequest: Codable, Equatable {

    /**
     The name of the collection.
     */
    public var name: String

    /**
     A description of the collection.
     */
    public var description: String?

    /**
     The ID of the configuration in which the collection is to be updated.
     */
    public var configurationID: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case configurationID = "configuration_id"
    }

    /**
     Initialize a `UpdateCollectionRequest` with member variables.

     - parameter name: The name of the collection.
     - parameter description: A description of the collection.
     - parameter configurationID: The ID of the configuration in which the collection is to be updated.

     - returns: An initialized `UpdateCollectionRequest`.
    */
    public init(
        name: String,
        description: String? = nil,
        configurationID: String? = nil
    )
    {
        self.name = name
        self.description = description
        self.configurationID = configurationID
    }

}
