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
 Details about the training event.
 */
public struct TrainingEvent: Codable, Equatable {

    /**
     Trained object type. Only `objects` is currently supported.
     */
    public enum TypeEnum: String {
        case objects = "objects"
    }

    /**
     Training status of the training event.
     */
    public enum Status: String {
        case failed = "failed"
        case succeeded = "succeeded"
    }

    /**
     Trained object type. Only `objects` is currently supported.
     */
    public var type: String?

    /**
     Identifier of the trained collection.
     */
    public var collectionID: String?

    /**
     Date and time in Coordinated Universal Time (UTC) that training on the collection finished.
     */
    public var completionTime: Date?

    /**
     Training status of the training event.
     */
    public var status: String?

    /**
     The total number of images that were used in training for this training event.
     */
    public var imageCount: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case collectionID = "collection_id"
        case completionTime = "completion_time"
        case status = "status"
        case imageCount = "image_count"
    }

}
