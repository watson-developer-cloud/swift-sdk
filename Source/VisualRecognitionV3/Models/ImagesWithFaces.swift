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

/** The results of detecting faces in one or more images. */
public struct ImagesWithFaces: JSONDecodable {
    
    /// The number of images processed.
    public let imagesProcessed: Int
    
    /// The images that were processed.
    public let images: [ImageWithFaces]
    
    /// Any warnings produced during processing.
    public let warnings: [WarningInfo]?
    
    /// Used internally to initialize an `ImagesWithFaces` model from JSON.
    public init(json: JSON) throws  {
        imagesProcessed = try json.getInt(at: "images_processed")
        images = try json.decodedArray(at: "images", type: ImageWithFaces.self)
        warnings = try? json.decodedArray(at: "warnings", type: WarningInfo.self)
    }
}

/** An image with detected faces. */
public struct ImageWithFaces: JSONDecodable {
    
    /// The source URL of the image, before any redirects. This is omitted if the image was uploaded.
    public let sourceURL: String?
    
    /// The fully-resolved URL of the image, after redirects are followed.
    /// This is omitted if the image was uploaded.
    public let resolvedURL: String?
    
    /// The relative path of the image file. This is omitted if the image was passed by URL.
    public let image: String?
    
    /// Information about what might have caused a failure, such as an image
    /// that is too large. This omitted if there is no error or warning.
    public let error: ErrorInfo?
    
    /// The faces identified in the given image.
    public let faces: [Face]
    
    /// Used internally to initialize an `ImageWithFaces` model from JSON.
    public init(json: JSON) throws {
        sourceURL = try? json.getString(at: "source_url")
        resolvedURL = try? json.getString(at: "resolved_url")
        image = try? json.getString(at: "image")
        error = try? json.decode(at: "error")
        faces = try json.decodedArray(at: "faces", type: Face.self)
    }
}

/** A face identified in an image. */
public struct Face: JSONDecodable {
    
    /// The age of the identified face.
    public let age: Age
    
    /// The gender of the identified face.
    public let gender: Gender
    
    /// The location of the identified face in the image.
    public let location: FaceLocation
    
    /// The identity of the identified face, if a known celebrity.
    public let identity: Identity?
    
    /// Used internally to initialize a `Face` model from JSON.
    public init(json: JSON) throws {
        age = try json.decode(at: "age")
        gender = try json.decode(at: "gender")
        location = try json.decode(at: "face_location")
        identity = try? json.decode(at: "identity")
    }
}

/** The age of an identified face. */
public struct Age: JSONDecodable {
    
    /// The estimated minimum age of the identified individual.
    public let min: Int?
    
    /// The estimated maximum age of the identified individual.
    public let max: Int?
    
    /// The confidence score of the given age range. If there are more than
    /// 10 faces in an image, age confidence scores may return a score of 0.
    public let score: Double
    
    /// Used internally to initialize an `Age` model from JSON.
    public init(json: JSON) throws {
        min = try? json.getInt(at: "min")
        max = try? json.getInt(at: "max")
        score = try json.getDouble(at: "score")
    }
}

/** The gender of an identified face. */
public struct Gender: JSONDecodable {
    
    /// The predicted gender of the identified individual.
    public let gender: String
    
    /// The confidence score of the given gender prediction. If there are more than
    /// 10 faces in an image, gender confidence scores may return a score of 0.
    public let score: Double
    
    /// Used internally to initialize a `Gender` model from JSON.
    public init(json: JSON) throws {
        gender = try json.getString(at: "gender")
        score = try json.getDouble(at: "score")
    }
}

/** The location of an identified face. */
public struct FaceLocation: JSONDecodable {
    
    /// The width in pixels of the face region.
    public let width: Int
    
    /// The height in pixels of the face region.
    public let height: Int
    
    /// The x-position of the top-left pixel of the face region.
    public let left: Int
    
    /// The y-position of the top-left pixel of the face region.
    public let top: Int
    
    /// Used internally to initialize a `FaceLocation` model from JSON.
    public init(json: JSON) throws {
        width = try json.getInt(at: "width")
        height = try json.getInt(at: "height")
        left = try json.getInt(at: "left")
        top = try json.getInt(at: "top")
    }
}

/** The identity of an identified face. */
public struct Identity: JSONDecodable {
    
    /// The name of the identified celebrity.
    public let name: String
    
    /// The confidence score of the given identification.
    public let score: Double
    
    /// The type hierarchy of the identified celebrity.
    public let typeHierarchy: String?
    
    /// Used internally to initialize an `Identity` model from JSON.
    public init(json: JSON) throws {
        name = try json.getString(at: "name")
        score = try json.getDouble(at: "score")
        typeHierarchy = try? json.getString(at: "type_hierarchy")
    }
}
