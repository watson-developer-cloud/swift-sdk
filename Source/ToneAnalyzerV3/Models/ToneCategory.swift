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
public struct ToneCategory {

    /// An array of `ToneScore` objects that provides the results for the tones of the category.
    public var tones: [ToneScore]

    /// The unique, non-localized identifier of the category for the results. The service can return results for the following category IDs: `emotion_tone`, `language_tone`, and `social_tone`.
    public var categoryID: String

    /// The user-visible, localized name of the category.
    public var categoryName: String

    /**
     Initialize a `ToneCategory` with member variables.

     - parameter tones: An array of `ToneScore` objects that provides the results for the tones of the category.
     - parameter categoryID: The unique, non-localized identifier of the category for the results. The service can return results for the following category IDs: `emotion_tone`, `language_tone`, and `social_tone`.
     - parameter categoryName: The user-visible, localized name of the category.

     - returns: An initialized `ToneCategory`.
    */
    public init(tones: [ToneScore], categoryID: String, categoryName: String) {
        self.tones = tones
        self.categoryID = categoryID
        self.categoryName = categoryName
    }
}

extension ToneCategory: Codable {

    private enum CodingKeys: String, CodingKey {
        case tones = "tones"
        case categoryID = "category_id"
        case categoryName = "category_name"
        static let allValues = [tones, categoryID, categoryName]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tones = try container.decode([ToneScore].self, forKey: .tones)
        categoryID = try container.decode(String.self, forKey: .categoryID)
        categoryName = try container.decode(String.self, forKey: .categoryName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tones, forKey: .tones)
        try container.encode(categoryID, forKey: .categoryID)
        try container.encode(categoryName, forKey: .categoryName)
    }

}
