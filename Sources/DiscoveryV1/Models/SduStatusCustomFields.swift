/**
 * (C) Copyright IBM Corp. 2019.
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
 Information about custom smart document understanding fields that exist in this collection.
 */
public struct SduStatusCustomFields: Codable, Equatable {

    /**
     The number of custom fields defined for this collection.
     */
    public var defined: Int?

    /**
     The maximum number of custom fields that are allowed in this collection.
     */
    public var maximumAllowed: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case defined = "defined"
        case maximumAllowed = "maximum_allowed"
    }

}
