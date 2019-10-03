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
 Base details about a collection.
 */
internal struct BaseCollection: Codable, Equatable {

    /**
     The identifier of the collection.
     */
    public var collectionID: String?

    /**
     The name of the collection. The name can contain alphanumeric, underscore, hyphen, and dot characters. It cannot
     begin with the reserved prefix `sys-`.
     */
    public var name: String?

    /**
     The description of the collection.
     */
    public var description: String?

    /**
     Date and time in Coordinated Universal Time (UTC) that the collection was created.
     */
    public var created: Date?

    /**
     Date and time in Coordinated Universal Time (UTC) that the collection was most recently updated.
     */
    public var updated: Date?

    /**
     Number of images in the collection.
     */
    public var imageCount: Int?

    /**
     Training status information for the collection.
     */
    public var trainingStatus: TrainingStatus?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case collectionID = "collection_id"
        case name = "name"
        case description = "description"
        case created = "created"
        case updated = "updated"
        case imageCount = "image_count"
        case trainingStatus = "training_status"
    }

    /**
     Initialize a `BaseCollection` with member variables.

     - parameter collectionID: The identifier of the collection.
     - parameter name: The name of the collection. The name can contain alphanumeric, underscore, hyphen, and dot
       characters. It cannot begin with the reserved prefix `sys-`.
     - parameter description: The description of the collection.
     - parameter created: Date and time in Coordinated Universal Time (UTC) that the collection was created.
     - parameter updated: Date and time in Coordinated Universal Time (UTC) that the collection was most recently
       updated.
     - parameter imageCount: Number of images in the collection.
     - parameter trainingStatus: Training status information for the collection.

     - returns: An initialized `BaseCollection`.
     */
    public init(
        collectionID: String? = nil,
        name: String? = nil,
        description: String? = nil,
        created: Date? = nil,
        updated: Date? = nil,
        imageCount: Int? = nil,
        trainingStatus: TrainingStatus? = nil
    )
    {
        self.collectionID = collectionID
        self.name = name
        self.description = description
        self.created = created
        self.updated = updated
        self.imageCount = imageCount
        self.trainingStatus = trainingStatus
    }

}
