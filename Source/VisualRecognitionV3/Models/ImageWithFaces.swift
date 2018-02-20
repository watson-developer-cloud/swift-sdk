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

/** ImageWithFaces. */
public struct ImageWithFaces {

    /// An array of the faces detected in the images.
    public var faces: [Face]

    /// Relative path of the image file if uploaded directly. Not returned when the image is passed by URL.
    public var image: String?

    /// Source of the image before any redirects. Not returned when the image is uploaded.
    public var sourceUrl: String?

    /// Fully resolved URL of the image after redirects are followed. Not returned when the image is uploaded.
    public var resolvedUrl: String?

    public var error: ErrorInfo?

    /**
     Initialize a `ImageWithFaces` with member variables.

     - parameter faces: An array of the faces detected in the images.
     - parameter image: Relative path of the image file if uploaded directly. Not returned when the image is passed by URL.
     - parameter sourceUrl: Source of the image before any redirects. Not returned when the image is uploaded.
     - parameter resolvedUrl: Fully resolved URL of the image after redirects are followed. Not returned when the image is uploaded.
     - parameter error:

     - returns: An initialized `ImageWithFaces`.
    */
    public init(faces: [Face], image: String? = nil, sourceUrl: String? = nil, resolvedUrl: String? = nil, error: ErrorInfo? = nil) {
        self.faces = faces
        self.image = image
        self.sourceUrl = sourceUrl
        self.resolvedUrl = resolvedUrl
        self.error = error
    }
}

extension ImageWithFaces: Codable {

    private enum CodingKeys: String, CodingKey {
        case faces = "faces"
        case image = "image"
        case sourceUrl = "source_url"
        case resolvedUrl = "resolved_url"
        case error = "error"
        static let allValues = [faces, image, sourceUrl, resolvedUrl, error]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        faces = try container.decode([Face].self, forKey: .faces)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        sourceUrl = try container.decodeIfPresent(String.self, forKey: .sourceUrl)
        resolvedUrl = try container.decodeIfPresent(String.self, forKey: .resolvedUrl)
        error = try container.decodeIfPresent(ErrorInfo.self, forKey: .error)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(faces, forKey: .faces)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(sourceUrl, forKey: .sourceUrl)
        try container.encodeIfPresent(resolvedUrl, forKey: .resolvedUrl)
        try container.encodeIfPresent(error, forKey: .error)
    }

}
