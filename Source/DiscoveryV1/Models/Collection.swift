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

/** A collection for storing documents. */
public struct Collection {

    /// The status of the collection.
    public enum Status: String {
        case active = "active"
        case pending = "pending"
        case maintenance = "maintenance"
    }

    /// The unique identifier of the collection.
    public var collectionID: String?

    /// The name of the collection.
    public var name: String?

    /// The description of the collection.
    public var description: String?

    /// The creation date of the collection in the format yyyy-MM-dd'T'HH:mmcon:ss.SSS'Z'.
    public var created: String?

    /// The timestamp of when the collection was last updated in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public var updated: String?

    /// The status of the collection.
    public var status: String?

    /// The unique identifier of the collection's configuration.
    public var configurationID: String?

    /// The language of the documents stored in the collection. Permitted values include `en` (English), `de` (German), and `es` (Spanish).
    public var language: String?

    /// The object providing information about the documents in the collection. Present only when retrieving details of a collection.
    public var documentCounts: DocumentCounts?

    /// The object providing information about the disk usage of the collection. Present only when retrieving details of a collection.
    public var diskUsage: CollectionDiskUsage?

    /// Provides information about the status of relevance training for collection.
    public var trainingStatus: TrainingStatus?

    /**
     Initialize a `Collection` with member variables.

     - parameter collectionID: The unique identifier of the collection.
     - parameter name: The name of the collection.
     - parameter description: The description of the collection.
     - parameter created: The creation date of the collection in the format yyyy-MM-dd'T'HH:mmcon:ss.SSS'Z'.
     - parameter updated: The timestamp of when the collection was last updated in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     - parameter status: The status of the collection.
     - parameter configurationID: The unique identifier of the collection's configuration.
     - parameter language: The language of the documents stored in the collection. Permitted values include `en` (English), `de` (German), and `es` (Spanish).
     - parameter documentCounts: The object providing information about the documents in the collection. Present only when retrieving details of a collection.
     - parameter diskUsage: The object providing information about the disk usage of the collection. Present only when retrieving details of a collection.
     - parameter trainingStatus: Provides information about the status of relevance training for collection.

     - returns: An initialized `Collection`.
    */
    public init(collectionID: String? = nil, name: String? = nil, description: String? = nil, created: String? = nil, updated: String? = nil, status: String? = nil, configurationID: String? = nil, language: String? = nil, documentCounts: DocumentCounts? = nil, diskUsage: CollectionDiskUsage? = nil, trainingStatus: TrainingStatus? = nil) {
        self.collectionID = collectionID
        self.name = name
        self.description = description
        self.created = created
        self.updated = updated
        self.status = status
        self.configurationID = configurationID
        self.language = language
        self.documentCounts = documentCounts
        self.diskUsage = diskUsage
        self.trainingStatus = trainingStatus
    }
}

extension Collection: Codable {

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
        static let allValues = [collectionID, name, description, created, updated, status, configurationID, language, documentCounts, diskUsage, trainingStatus]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        collectionID = try container.decodeIfPresent(String.self, forKey: .collectionID)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        updated = try container.decodeIfPresent(String.self, forKey: .updated)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        configurationID = try container.decodeIfPresent(String.self, forKey: .configurationID)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        documentCounts = try container.decodeIfPresent(DocumentCounts.self, forKey: .documentCounts)
        diskUsage = try container.decodeIfPresent(CollectionDiskUsage.self, forKey: .diskUsage)
        trainingStatus = try container.decodeIfPresent(TrainingStatus.self, forKey: .trainingStatus)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(collectionID, forKey: .collectionID)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(updated, forKey: .updated)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(configurationID, forKey: .configurationID)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(documentCounts, forKey: .documentCounts)
        try container.encodeIfPresent(diskUsage, forKey: .diskUsage)
        try container.encodeIfPresent(trainingStatus, forKey: .trainingStatus)
    }

}
