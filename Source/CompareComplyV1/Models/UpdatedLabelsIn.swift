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

/**
 The updated labeling from the input document, accounting for the submitted feedback.
 */
public struct UpdatedLabelsIn: Codable, Equatable {

    /**
     Description of the action specified by the element and whom it affects.
     */
    public var types: [TypeLabel]

    /**
     List of functional categories into which the element falls; in other words, the subject matter of the element.
     */
    public var categories: [Category]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case types = "types"
        case categories = "categories"
    }

    /**
     Initialize a `UpdatedLabelsIn` with member variables.

     - parameter types: Description of the action specified by the element and whom it affects.
     - parameter categories: List of functional categories into which the element falls; in other words, the subject
       matter of the element.

     - returns: An initialized `UpdatedLabelsIn`.
    */
    public init(
        types: [TypeLabel],
        categories: [Category]
    )
    {
        self.types = types
        self.categories = categories
    }

}
