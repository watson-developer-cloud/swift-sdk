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
 The **options** object defines which items to crawl from the source system.
 */
public struct SourceOptions: Codable, Equatable {

    /**
     Array of folders to crawl from the Box source. Only valid, and required, when the **type** field of the **source**
     object is set to `box`.
     */
    public var folders: [SourceOptionsFolder]?

    /**
     Array of Salesforce document object types to crawl from the Salesforce source. Only valid, and required, when the
     **type** field of the **source** object is set to `salesforce`.
     */
    public var objects: [SourceOptionsObject]?

    /**
     Array of Microsoft SharePointoint Online site collections to crawl from the SharePoint source. Only valid and
     required when the **type** field of the **source** object is set to `sharepoint`.
     */
    public var siteCollections: [SourceOptionsSiteColl]?

    /**
     Array of Web page URLs to begin crawling the web from. Only valid and required when the **type** field of the
     **source** object is set to `web_crawl`.
     */
    public var urls: [SourceOptionsWebCrawl]?

    /**
     Array of cloud object store buckets to begin crawling. Only valid and required when the **type** field of the
     **source** object is set to `cloud_object_store`, and the **crawl_all_buckets** field is `false` or not specified.
     */
    public var buckets: [SourceOptionsBuckets]?

    /**
     When `true`, all buckets in the specified cloud object store are crawled. If set to `true`, the **buckets** array
     must not be specified.
     */
    public var crawlAllBuckets: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case folders = "folders"
        case objects = "objects"
        case siteCollections = "site_collections"
        case urls = "urls"
        case buckets = "buckets"
        case crawlAllBuckets = "crawl_all_buckets"
    }

    /**
     Initialize a `SourceOptions` with member variables.

     - parameter folders: Array of folders to crawl from the Box source. Only valid, and required, when the **type**
       field of the **source** object is set to `box`.
     - parameter objects: Array of Salesforce document object types to crawl from the Salesforce source. Only valid,
       and required, when the **type** field of the **source** object is set to `salesforce`.
     - parameter siteCollections: Array of Microsoft SharePointoint Online site collections to crawl from the
       SharePoint source. Only valid and required when the **type** field of the **source** object is set to
       `sharepoint`.
     - parameter urls: Array of Web page URLs to begin crawling the web from. Only valid and required when the
       **type** field of the **source** object is set to `web_crawl`.
     - parameter buckets: Array of cloud object store buckets to begin crawling. Only valid and required when the
       **type** field of the **source** object is set to `cloud_object_store`, and the **crawl_all_buckets** field is
       `false` or not specified.
     - parameter crawlAllBuckets: When `true`, all buckets in the specified cloud object store are crawled. If set to
       `true`, the **buckets** array must not be specified.

     - returns: An initialized `SourceOptions`.
    */
    public init(
        folders: [SourceOptionsFolder]? = nil,
        objects: [SourceOptionsObject]? = nil,
        siteCollections: [SourceOptionsSiteColl]? = nil,
        urls: [SourceOptionsWebCrawl]? = nil,
        buckets: [SourceOptionsBuckets]? = nil,
        crawlAllBuckets: Bool? = nil
    )
    {
        self.folders = folders
        self.objects = objects
        self.siteCollections = siteCollections
        self.urls = urls
        self.buckets = buckets
        self.crawlAllBuckets = crawlAllBuckets
    }

}
