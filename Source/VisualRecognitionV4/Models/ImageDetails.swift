/**
 * (C) Copyright IBM Corp. 2019.
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
 Details about an image.
 */
public struct ImageDetails: Codable, Equatable {

    /**
     The identifier of the image.
     */
    public var imageID: String?

    /**
     Date and time in Coordinated Universal Time (UTC) that the image was most recently updated.
     */
    public var updated: Date?

    /**
     Date and time in Coordinated Universal Time (UTC) that the image was created.
     */
    public var created: Date?

    /**
     The source type of the image.
     */
    public var source: ImageSource

    /**
     Height and width of an image.
     */
    public var dimensions: ImageDimensions?

    public var errors: [Error]?

    /**
     Training data for all objects.
     */
    public var trainingData: TrainingDataObjects?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case imageID = "image_id"
        case updated = "updated"
        case created = "created"
        case source = "source"
        case dimensions = "dimensions"
        case errors = "errors"
        case trainingData = "training_data"
    }

}
