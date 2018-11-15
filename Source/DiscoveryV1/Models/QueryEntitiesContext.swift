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
 Entity text to provide context for the queried entity and rank based on that association. For example, if you wanted to
 query the city of London in England your query would look for `London` with the context of `England`.
 */
public struct QueryEntitiesContext: Codable, Equatable {

    /**
     Entity text to provide context for the queried entity and rank based on that association. For example, if you
     wanted to query the city of London in England your query would look for `London` with the context of `England`.
     */
    public var text: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
    }

    /**
     Initialize a `QueryEntitiesContext` with member variables.

     - parameter text: Entity text to provide context for the queried entity and rank based on that association. For
       example, if you wanted to query the city of London in England your query would look for `London` with the context
       of `England`.

     - returns: An initialized `QueryEntitiesContext`.
    */
    public init(
        text: String? = nil
    )
    {
        self.text = text
    }

}
