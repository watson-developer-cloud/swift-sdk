/**
 * (C) Copyright IBM Corp. 2018, 2019.
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
 Object containing source crawl status information.
 */
public struct SourceStatus: Codable, Equatable {

    /**
     The current status of the source crawl for this collection. This field returns `not_configured` if the default
     configuration for this source does not have a **source** object defined.
     -  `running` indicates that a crawl to fetch more documents is in progress.
     -  `complete` indicates that the crawl has completed with no errors.
     -  `queued` indicates that the crawl has been paused by the system and will automatically restart when possible.
     -  `unknown` indicates that an unidentified error has occured in the service.
     */
    public enum Status: String {
        case running = "running"
        case complete = "complete"
        case notConfigured = "not_configured"
        case queued = "queued"
        case unknown = "unknown"
    }

    /**
     The current status of the source crawl for this collection. This field returns `not_configured` if the default
     configuration for this source does not have a **source** object defined.
     -  `running` indicates that a crawl to fetch more documents is in progress.
     -  `complete` indicates that the crawl has completed with no errors.
     -  `queued` indicates that the crawl has been paused by the system and will automatically restart when possible.
     -  `unknown` indicates that an unidentified error has occured in the service.
     */
    public var status: String?

    /**
     Date in `RFC 3339` format indicating the time of the next crawl attempt.
     */
    public var nextCrawl: Date?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case nextCrawl = "next_crawl"
    }

}
