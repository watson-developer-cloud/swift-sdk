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
 Training status for the objects in the collection.
 */
public struct ObjectTrainingStatus: Codable, Equatable {

    /**
     Whether you can analyze images in the collection with the **objects** feature.
     */
    public var ready: Bool

    /**
     Whether training is in progress.
     */
    public var inProgress: Bool

    /**
     Whether there are changes to the training data since the most recent training.
     */
    public var dataChanged: Bool

    /**
     Whether the most recent training failed.
     */
    public var latestFailed: Bool

    /**
     Details about the training. If training is in progress, includes information about the status. If training is not
     in progress, includes a success message or information about why training failed.
     */
    public var description: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case ready = "ready"
        case inProgress = "in_progress"
        case dataChanged = "data_changed"
        case latestFailed = "latest_failed"
        case description = "description"
    }

    /**
     Initialize a `ObjectTrainingStatus` with member variables.

     - parameter ready: Whether you can analyze images in the collection with the **objects** feature.
     - parameter inProgress: Whether training is in progress.
     - parameter dataChanged: Whether there are changes to the training data since the most recent training.
     - parameter latestFailed: Whether the most recent training failed.
     - parameter description: Details about the training. If training is in progress, includes information about the
       status. If training is not in progress, includes a success message or information about why training failed.

     - returns: An initialized `ObjectTrainingStatus`.
     */
    public init(
        ready: Bool,
        inProgress: Bool,
        dataChanged: Bool,
        latestFailed: Bool,
        description: String
    )
    {
        self.ready = ready
        self.inProgress = inProgress
        self.dataChanged = dataChanged
        self.latestFailed = latestFailed
        self.description = description
    }

}
