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
 An option specifying if the relationships found between entities in the analyzed content should be returned.
 */
public struct RelationsOptions: Encodable {

    /**
     Enter a custom model ID to override the default model.
     */
    public var model: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case model = "model"
    }

    /**
     Initialize a `RelationsOptions` with member variables.

     - parameter model: Enter a custom model ID to override the default model.

     - returns: An initialized `RelationsOptions`.
    */
    public init(
        model: String? = nil
    )
    {
        self.model = model
    }

}
