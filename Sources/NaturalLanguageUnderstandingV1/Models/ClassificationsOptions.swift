/**
 * (C) Copyright IBM Corp. 2021.
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
 Returns text classifications for the content.
 Supported languages: English only.
 */
public struct ClassificationsOptions: Codable, Equatable {

    /**
     Enter a [custom
     model](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-customizing)
     ID of the classification model to be used.
     */
    public var model: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case model = "model"
    }

    /**
      Initialize a `ClassificationsOptions` with member variables.

      - parameter model: Enter a [custom
        model](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-customizing)
        ID of the classification model to be used.

      - returns: An initialized `ClassificationsOptions`.
     */
    public init(
        model: String? = nil
    )
    {
        self.model = model
    }

}
