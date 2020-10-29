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
 Details about the training events.
 */
public struct TrainingEvents: Codable, Equatable {

    /**
     The starting day for the returned training events in Coordinated Universal Time (UTC). If not specified in the
     request, it identifies the earliest training event.
     */
    public var startTime: Date?

    /**
     The ending day for the returned training events in Coordinated Universal Time (UTC). If not specified in the
     request, it lists the current time.
     */
    public var endTime: Date?

    /**
     The total number of training events in the response for the start and end times.
     */
    public var completedEvents: Int?

    /**
     The total number of images that were used in training for the start and end times.
     */
    public var trainedImages: Int?

    /**
     The completed training events for the start and end time.
     */
    public var events: [TrainingEvent]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case completedEvents = "completed_events"
        case trainedImages = "trained_images"
        case events = "events"
    }

}
