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

/** Classify results for multiple images. */
public struct ClassifiedImages {

    /// The number of custom classes identified in the images.
    public var customClasses: Int?

    /// Number of images processed for the API call.
    public var imagesProcessed: Int?

    /// The array of classified images.
    public var images: [ClassifiedImage]

    /// Information about what might cause less than optimal output. For example, a request sent with a corrupt .zip file and a list of image URLs will still complete, but does not return the expected output. Not returned when there is no warning.
    public var warnings: [WarningInfo]?

    /**
     Initialize a `ClassifiedImages` with member variables.

     - parameter images: The array of classified images.
     - parameter customClasses: The number of custom classes identified in the images.
     - parameter imagesProcessed: Number of images processed for the API call.
     - parameter warnings: Information about what might cause less than optimal output. For example, a request sent with a corrupt .zip file and a list of image URLs will still complete, but does not return the expected output. Not returned when there is no warning.

     - returns: An initialized `ClassifiedImages`.
    */
    public init(images: [ClassifiedImage], customClasses: Int? = nil, imagesProcessed: Int? = nil, warnings: [WarningInfo]? = nil) {
        self.images = images
        self.customClasses = customClasses
        self.imagesProcessed = imagesProcessed
        self.warnings = warnings
    }
}

extension ClassifiedImages: Codable {

    private enum CodingKeys: String, CodingKey {
        case customClasses = "custom_classes"
        case imagesProcessed = "images_processed"
        case images = "images"
        case warnings = "warnings"
        static let allValues = [customClasses, imagesProcessed, images, warnings]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        customClasses = try container.decodeIfPresent(Int.self, forKey: .customClasses)
        imagesProcessed = try container.decodeIfPresent(Int.self, forKey: .imagesProcessed)
        images = try container.decode([ClassifiedImage].self, forKey: .images)
        warnings = try container.decodeIfPresent([WarningInfo].self, forKey: .warnings)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(customClasses, forKey: .customClasses)
        try container.encodeIfPresent(imagesProcessed, forKey: .imagesProcessed)
        try container.encode(images, forKey: .images)
        try container.encodeIfPresent(warnings, forKey: .warnings)
    }

}
