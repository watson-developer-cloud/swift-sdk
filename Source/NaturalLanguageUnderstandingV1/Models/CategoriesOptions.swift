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
 Returns a five-level taxonomy of the content. The top three categories are returned.
 Supported languages: Arabic, English, French, German, Italian, Japanese, Korean, Portuguese, Spanish.
 */
public struct CategoriesOptions: Codable, Equatable {

    /**
     Maximum number of categories to return.
     */
    public var limit: Int?

    /**
     Enter a [custom model](https://cloud.ibm.com/docs/services/natural-language-understanding/customizing.html) ID to
     override the standard categories model.
     */
    public var model: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case model = "model"
    }

    /**
     Initialize a `CategoriesOptions` with member variables.

     - parameter limit: Maximum number of categories to return.
     - parameter model: Enter a [custom
       model](https://cloud.ibm.com/docs/services/natural-language-understanding/customizing.html) ID to override the
       standard categories model.

     - returns: An initialized `CategoriesOptions`.
    */
    public init(
        limit: Int? = nil,
        model: String? = nil
    )
    {
        self.limit = limit
        self.model = model
    }

}
