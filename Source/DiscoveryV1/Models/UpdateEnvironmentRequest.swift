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

/** UpdateEnvironmentRequest. */
internal struct UpdateEnvironmentRequest: Codable, Equatable {

    /**
     Size that the environment should be increased to. Environment size cannot be modified when using a Lite plan.
     Environment size can only increased and not decreased.
     */
    public enum Size: String {
        case s = "S"
        case ms = "MS"
        case m = "M"
        case ml = "ML"
        case l = "L"
        case xl = "XL"
        case xxl = "XXL"
        case xxxl = "XXXL"
    }

    /**
     Name that identifies the environment.
     */
    public var name: String?

    /**
     Description of the environment.
     */
    public var description: String?

    /**
     Size that the environment should be increased to. Environment size cannot be modified when using a Lite plan.
     Environment size can only increased and not decreased.
     */
    public var size: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case size = "size"
    }

    /**
     Initialize a `UpdateEnvironmentRequest` with member variables.

     - parameter name: Name that identifies the environment.
     - parameter description: Description of the environment.
     - parameter size: Size that the environment should be increased to. Environment size cannot be modified when
       using a Lite plan. Environment size can only increased and not decreased.

     - returns: An initialized `UpdateEnvironmentRequest`.
    */
    public init(
        name: String? = nil,
        description: String? = nil,
        size: String? = nil
    )
    {
        self.name = name
        self.description = description
        self.size = size
    }

}
