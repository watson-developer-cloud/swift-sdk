/**
 * Copyright IBM Corporation 2016
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
import RestKit

/** A collection for storing documents. */
public struct Collection: JSONDecodable {
    
    /// The unique identifier of the collection.
    public let collectionID: String?
    
    /// The name of the collection with a maximum length of 255 characters.
    public let name: String
    
    /// The description of the collection.
    public let description: String?
    
    /// The creation date of the collection in the format yyyy-MM-dd'T'HH:mmcon:ss.SSS'Z'.
    public let created: String
    
    /// The timestamp of when the collection was last updated in the format
    /// yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public let updated: String
    
    /// The status of the collection.
    public let status: CollectionStatus
    
    /// The unique identifier of the collection's configuration.
    public let configurationID: String
    
    /// The language of the collection's documents.
    public let language: String?
    
    /// The object providing information about the documents in the collection.
    /// Seen only when retrieving details of a colleciton.
    public let documentCounts: DocumentCounts?
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a `Collection` model from JSON.
    public init(json: JSON) throws {
        collectionID = try? json.getString(at: "collection_id")
        name = try json.getString(at: "name")
        description = try? json.getString(at: "description")
        created = try json.getString(at: "created")
        updated = try json.getString(at: "updated")
        
        guard let collectionStatus = CollectionStatus(rawValue: try json.getString(at: "status")) else {
            throw JSON.Error.valueNotConvertible(value: json, to: CollectionStatus.self)
        }
        status = collectionStatus
        configurationID = try json.getString(at: "configuration_id")
        language = try? json.getString(at: "langauge")
        documentCounts = try? json.decode(at: "document_counts", type: DocumentCounts.self)
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize an 'Collection' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}

/** The information about documents in a collection. */
public struct DocumentCounts: JSONDecodable {
    
    /// Number of available documents.
    public let available: Int?
    
    /// Number of processing documents.
    public let processing: Int?
    
    /// Number of failed documents.
    public let failed: Int?
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a 'DocumentCounts' model from JSON.
    public init(json: JSON) throws {
        available = try? json.getInt(at: "available")
        processing = try? json.getInt(at: "processing")
        failed = try? json.getInt(at: "failed")
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize a 'DocumentCounts' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}

/** The field of a collection. */
public struct Field: JSONDecodable {
    
    /// The name of the field.
    public let field: String
    
    /// The type of the field.
    public let type: String
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a 'Field' model from JSON.
    public init (json: JSON) throws {
        field = try json.getString(at: "field")
        type = try json.getString(at: "type")
        self.json = try json.getDictionaryObject()
    }
}

/** A deleted collection. */
public struct DeletedCollection: JSONDecodable {
    
    /// The ID of the deleted collection.
    public let collectionID: String
    
    /// The status of the collection.
    public let status: CollectionStatus
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a 'DeletedCollection' model from JSON.
    public init(json: JSON) throws {
        collectionID = try json.getString(at: "collection_id")
        guard let collectionStatus = CollectionStatus(rawValue: try json.getString(at: "status")) else {
            throw JSON.Error.valueNotConvertible(value: json, to: CollectionStatus.self)
        }
        status = collectionStatus
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize a 'DeletedCollectoin' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}

/** The status of a collection. */
public enum CollectionStatus: String {
    /// Active
    case active = "active"
    
    /// Pending
    case pending = "pending"
    
    /// Deleted
    case deleted = "deleted"
}
