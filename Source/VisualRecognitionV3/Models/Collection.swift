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

/** A collection of images to search. */
public struct Collection: JSONDecodable {
    
    /// The unique ID of the collection.
    public let collectionID: String
    
    /// The name of the collection.
    public let name: String
    
    /// The date the collection was created.
    public let created: String
    
    /// The number of images in the collection.
    public let images: Int
    
    /// The status of the collection. Returns 'available' when images can be added
    /// to the collection. Returns 'unavailable' when the collection is being created
    /// or trained.
    public let status: String
    
    /// The number of images possible in the collection. Each collection can contain
    /// 1000000 images.
    public let capacity: String
    
    /// Used internally to initialize a 'Collection' model from JSON.
    public init(json: JSON) throws {
        collectionID = try json.getString(at: "collection_id")
        name = try json.getString(at: "name")
        created = try json.getString(at: "created")
        images = try json.getInt(at: "images")
        status = try json.getString(at: "status")
        capacity = try json.getString(at: "capacity")
    }
}

