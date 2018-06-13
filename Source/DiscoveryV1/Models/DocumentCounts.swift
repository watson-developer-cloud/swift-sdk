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

/** DocumentCounts. */
public struct DocumentCounts: Decodable {

    /**
     The total number of available documents in the collection.
     */
    public var available: Int?

    /**
     The number of documents in the collection that are currently being processed.
     */
    public var processing: Int?

    /**
     The number of documents in the collection that failed to be ingested.
     */
    public var failed: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case available = "available"
        case processing = "processing"
        case failed = "failed"
    }

}
