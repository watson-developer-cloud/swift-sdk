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
 Object containing result information that was returned by the query used to create this log entry. Only returned with
 logs of type `query`.
 */
public struct LogQueryResponseResultDocuments: Codable, Equatable {

    public var results: [LogQueryResponseResultDocumentsResult]?

    /**
     The number of results returned in the query associate with this log.
     */
    public var count: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case results = "results"
        case count = "count"
    }

}
