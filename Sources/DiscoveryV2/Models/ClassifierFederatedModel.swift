/**
 * (C) Copyright IBM Corp. 2022.
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
 An object with details for creating federated document classifier models.
 */
public struct ClassifierFederatedModel: Codable, Equatable {

    /**
     Name of the field that contains the values from which multiple classifier models are defined. For example, you can
     specify a field that lists product lines to create a separate model per product line.
     */
    public var field: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case field = "field"
    }

    /**
      Initialize a `ClassifierFederatedModel` with member variables.

      - parameter field: Name of the field that contains the values from which multiple classifier models are defined.
        For example, you can specify a field that lists product lines to create a separate model per product line.

      - returns: An initialized `ClassifierFederatedModel`.
     */
    public init(
        field: String
    )
    {
        self.field = field
    }

}
