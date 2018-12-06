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

/** ToneCategory. */
public struct ToneCategory: Codable, Equatable {

    /**
     An array of `ToneScore` objects that provides the results for the tones of the category.
     */
    public var tones: [ToneScore]

    /**
     The unique, non-localized identifier of the category for the results. The service can return results for the
     following category IDs: `emotion_tone`, `language_tone`, and `social_tone`.
     */
    public var categoryID: String

    /**
     The user-visible, localized name of the category.
     */
    public var categoryName: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case tones = "tones"
        case categoryID = "category_id"
        case categoryName = "category_name"
    }

}
