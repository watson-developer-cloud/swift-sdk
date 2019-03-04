/**
 * Copyright IBM Corporation 2019
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
 Object defining a cloud object store bucket to crawl.
 */
public struct SourceOptionsBuckets: Codable, Equatable {

    /**
     The name of the cloud object store bucket to crawl.
     */
    public var name: String

    /**
     The number of documents to crawl from this cloud object store bucket. If not specified, all documents in the bucket
     are crawled.
     */
    public var limit: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case limit = "limit"
    }

    /**
     Initialize a `SourceOptionsBuckets` with member variables.

     - parameter name: The name of the cloud object store bucket to crawl.
     - parameter limit: The number of documents to crawl from this cloud object store bucket. If not specified, all
       documents in the bucket are crawled.

     - returns: An initialized `SourceOptionsBuckets`.
    */
    public init(
        name: String,
        limit: Int? = nil
    )
    {
        self.name = name
        self.limit = limit
    }

}
