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
 Object containing source crawl status information.
 */
public struct SourceStatus: Codable, Equatable {

    /**
     The current status of the source crawl for this collection. This field returns `not_configured` if the default
     configuration for this source does not have a **source** object defined.
     -  `running` indicates that a crawl to fetch more documents is in progress.
     -  `complete` indicates that the crawl has completed with no errors.
     -  `complete_with_notices` indicates that some notices were generated during the crawl. Notices can be checked by
     using the **notices** query method.
     -  `stopped` indicates that the crawl has stopped but is not complete.
     */
    public enum Status: String {
        case running = "running"
        case complete = "complete"
        case completeWithNotices = "complete_with_notices"
        case stopped = "stopped"
        case notConfigured = "not_configured"
    }

    /**
     The current status of the source crawl for this collection. This field returns `not_configured` if the default
     configuration for this source does not have a **source** object defined.
     -  `running` indicates that a crawl to fetch more documents is in progress.
     -  `complete` indicates that the crawl has completed with no errors.
     -  `complete_with_notices` indicates that some notices were generated during the crawl. Notices can be checked by
     using the **notices** query method.
     -  `stopped` indicates that the crawl has stopped but is not complete.
     */
    public var status: String?

    /**
     Date in UTC format indicating when the last crawl was attempted. If `null`, no crawl was completed.
     */
    public var lastUpdated: Date?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case lastUpdated = "last_updated"
    }

}
