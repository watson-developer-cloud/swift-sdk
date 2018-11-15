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
 Object that defines a Microsoft SharePoint site collection to crawl with this configuration.
 */
public struct SourceOptionsSiteColl: Codable, Equatable {

    /**
     The Microsoft SharePoint Online site collection path to crawl. The path must be be relative to the
     **organization_url** that was specified in the credentials associated with this source configuration.
     */
    public var siteCollectionPath: String

    /**
     The maximum number of documents to crawl for this site collection. By default, all documents in the site collection
     are crawled.
     */
    public var limit: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case siteCollectionPath = "site_collection_path"
        case limit = "limit"
    }

    /**
     Initialize a `SourceOptionsSiteColl` with member variables.

     - parameter siteCollectionPath: The Microsoft SharePoint Online site collection path to crawl. The path must be
       be relative to the **organization_url** that was specified in the credentials associated with this source
       configuration.
     - parameter limit: The maximum number of documents to crawl for this site collection. By default, all documents
       in the site collection are crawled.

     - returns: An initialized `SourceOptionsSiteColl`.
    */
    public init(
        siteCollectionPath: String,
        limit: Int? = nil
    )
    {
        self.siteCollectionPath = siteCollectionPath
        self.limit = limit
    }

}
