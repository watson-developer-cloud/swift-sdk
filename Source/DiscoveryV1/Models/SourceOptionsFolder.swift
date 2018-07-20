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
 Object that defines a box folder to crawl with this configuration.
 */
public struct SourceOptionsFolder: Codable {

    /**
     The Box user ID of the user who owns the folder to crawl.
     */
    public var ownerUserID: String

    /**
     The Box folder ID of the folder to crawl.
     */
    public var folderID: String

    /**
     The maximum number of documents to crawl for this folder. By default, all documents in the folder are crawled.
     */
    public var limit: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case ownerUserID = "owner_user_id"
        case folderID = "folder_id"
        case limit = "limit"
    }

    /**
     Initialize a `SourceOptionsFolder` with member variables.

     - parameter ownerUserID: The Box user ID of the user who owns the folder to crawl.
     - parameter folderID: The Box folder ID of the folder to crawl.
     - parameter limit: The maximum number of documents to crawl for this folder. By default, all documents in the
       folder are crawled.

     - returns: An initialized `SourceOptionsFolder`.
    */
    public init(
        ownerUserID: String,
        folderID: String,
        limit: Int? = nil
    )
    {
        self.ownerUserID = ownerUserID
        self.folderID = folderID
        self.limit = limit
    }

}
