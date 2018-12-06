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
 A collection for storing documents.
 */
public struct Collection: Codable, Equatable {

    /**
     The status of the collection.
     */
    public enum Status: String {
        case active = "active"
        case pending = "pending"
        case maintenance = "maintenance"
    }

    /**
     The unique identifier of the collection.
     */
    public var collectionID: String?

    /**
     The name of the collection.
     */
    public var name: String?

    /**
     The description of the collection.
     */
    public var description: String?

    /**
     The creation date of the collection in the format yyyy-MM-dd'T'HH:mmcon:ss.SSS'Z'.
     */
    public var created: Date?

    /**
     The timestamp of when the collection was last updated in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     */
    public var updated: Date?

    /**
     The status of the collection.
     */
    public var status: String?

    /**
     The unique identifier of the collection's configuration.
     */
    public var configurationID: String?

    /**
     The language of the documents stored in the collection. Permitted values include `en` (English), `de` (German), and
     `es` (Spanish).
     */
    public var language: String?

    /**
     The object providing information about the documents in the collection. Present only when retrieving details of a
     collection.
     */
    public var documentCounts: DocumentCounts?

    /**
     Summary of the disk usage statistics for this collection.
     */
    public var diskUsage: CollectionDiskUsage?

    /**
     Provides information about the status of relevance training for collection.
     */
    public var trainingStatus: TrainingStatus?

    /**
     Object containing source crawl status information.
     */
    public var sourceCrawl: SourceStatus?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case collectionID = "collection_id"
        case name = "name"
        case description = "description"
        case created = "created"
        case updated = "updated"
        case status = "status"
        case configurationID = "configuration_id"
        case language = "language"
        case documentCounts = "document_counts"
        case diskUsage = "disk_usage"
        case trainingStatus = "training_status"
        case sourceCrawl = "source_crawl"
    }

}
