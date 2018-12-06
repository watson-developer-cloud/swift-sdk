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
 Results for all images.
 */
public struct ClassifiedImages: Codable, Equatable {

    /**
     Number of custom classes identified in the images.
     */
    public var customClasses: Int?

    /**
     Number of images processed for the API call.
     */
    public var imagesProcessed: Int?

    /**
     Classified images.
     */
    public var images: [ClassifiedImage]

    /**
     Information about what might cause less than optimal output. For example, a request sent with a corrupt .zip file
     and a list of image URLs will still complete, but does not return the expected output. Not returned when there is
     no warning.
     */
    public var warnings: [WarningInfo]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case customClasses = "custom_classes"
        case imagesProcessed = "images_processed"
        case images = "images"
        case warnings = "warnings"
    }

}
