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

/** Behavior. */
public struct Behavior: Decodable {

    /**
     The unique, non-localized identifier of the characteristic to which the results pertain. IDs have the form
     `behavior_{value}`.
     */
    public var traitID: String

    /**
     The user-visible, localized name of the characteristic.
     */
    public var name: String

    /**
     The category of the characteristic: `behavior` for temporal data.
     */
    public var category: String

    /**
     For JSON content that is timestamped, the percentage of timestamped input data that occurred during that day of the
     week or hour of the day. The range is 0 to 1.
     */
    public var percentage: Double

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case traitID = "trait_id"
        case name = "name"
        case category = "category"
        case percentage = "percentage"
    }

}
