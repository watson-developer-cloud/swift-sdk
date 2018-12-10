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
 Returns a five-level taxonomy of the content. The top three categories are returned.
 Supported languages: Arabic, English, French, German, Italian, Japanese, Korean, Portuguese, Spanish.
 */
public struct CategoriesOptions: Codable, Equatable {

    /**
     Maximum number of categories to return.
     Maximum value: **10**.
     */
    public var limit: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case limit = "limit"
    }

    /**
     Initialize a `CategoriesOptions` with member variables.

     - parameter limit: Maximum number of categories to return.
       Maximum value: **10**.

     - returns: An initialized `CategoriesOptions`.
    */
    public init(
        limit: Int? = nil
    )
    {
        self.limit = limit
    }

}
