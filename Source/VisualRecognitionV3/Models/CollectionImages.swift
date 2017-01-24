/**
 * Copyright IBM Corporation 2016-2017
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

/** A collection of images. */
public struct CollectionImages: JSONDecodable {
    
    /// The images within a collection.
    public let collectionImages: [CollectionImage]
    
    /// The number of images processed.
    public let imagesProcessed: Int
    
    /// Used internally to initialize a `CollectionImages` model from JSON.
    public init(json: JSON) throws {
        collectionImages = try json.decodedArray(at: "images", type: CollectionImage.self)
        imagesProcessed = try json.getInt(at: "images_processed")
    }
}

/** A collection image. */
public struct CollectionImage: JSONDecodable {
    
    /// The ID of the image. Can be used to add or remove from the collection.
    public let imageID: String
    
    /// The date the image was added to the collection.
    public let created: String
    
    /// The name of the image.
    public let imageFile: String
    
    /// The metadata associated with the image.
    public let metadata: Metadata?
    
    /// The confidence level of the match with similar images. Provided only when searching for similar images.
    public let score: Double?
    
    /// Used internally to initialize a 'CollectionImage' model from JSON.
    public init(json: JSON) throws {
        imageID = try json.getString(at: "image_id")
        created = try json.getString(at: "created")
        imageFile = try json.getString(at: "image_file")
        metadata = try? json.decode(at: "metadata", type: Metadata.self)
        score = try? json.getDouble(at: "score")
    }
}

/** Metadata object to handle updating, viewing metadata per image within a collection. */
public struct Metadata: JSONDecodable {
    
    /// The metadata associated with the image.
    public let metadata: [String: Any]?
    
    /// Used internally to intialize a 'Metadata' model from JSON.
    public init(json: JSON) throws {
        self.metadata = try? json.getDictionaryObject()
    }
    
    /// Used internally to serialize metadata to JSON.
    public func toJSONObject() -> Any? {
        return metadata
    }
}

/** Similar images found by the service. */
public struct SimilarImages: JSONDecodable {
    
    /// The file name of the image used to search against other images in the collection.
    public let imageFile: String
    
    /// The array of similar images.
    public let similarImages: [CollectionImage]
    
    /// The number of images processed.
    public let imagesProcessed: Int
    
    /// Used internally to initialize a `CollectionImages` model from JSON.
    public init(json: JSON) throws {
        imageFile = try json.getString(at: "image_file")
        similarImages = try json.decodedArray(at: "similar_images", type: CollectionImage.self)
        imagesProcessed = try json.getInt(at: "images_processed")
    }
}
