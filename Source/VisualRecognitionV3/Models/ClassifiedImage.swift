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

/** Classifier results for one image. */
public struct ClassifiedImage {

    /// Source of the image before any redirects. Not returned when the image is uploaded.
    public var sourceUrl: String?

    /// Fully resolved URL of the image after redirects are followed. Not returned when the image is uploaded.
    public var resolvedUrl: String?

    /// Relative path of the image file if uploaded directly. Not returned when the image is passed by URL.
    public var image: String?

    public var error: ErrorInfo?

    public var classifiers: [ClassifierResult]

    /**
     Initialize a `ClassifiedImage` with member variables.

     - parameter classifiers:
     - parameter sourceUrl: Source of the image before any redirects. Not returned when the image is uploaded.
     - parameter resolvedUrl: Fully resolved URL of the image after redirects are followed. Not returned when the image is uploaded.
     - parameter image: Relative path of the image file if uploaded directly. Not returned when the image is passed by URL.
     - parameter error:

     - returns: An initialized `ClassifiedImage`.
    */
    public init(classifiers: [ClassifierResult], sourceUrl: String? = nil, resolvedUrl: String? = nil, image: String? = nil, error: ErrorInfo? = nil) {
        self.classifiers = classifiers
        self.sourceUrl = sourceUrl
        self.resolvedUrl = resolvedUrl
        self.image = image
        self.error = error
    }
}

extension ClassifiedImage: Codable {

    private enum CodingKeys: String, CodingKey {
        case sourceUrl = "source_url"
        case resolvedUrl = "resolved_url"
        case image = "image"
        case error = "error"
        case classifiers = "classifiers"
        static let allValues = [sourceUrl, resolvedUrl, image, error, classifiers]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceUrl = try container.decodeIfPresent(String.self, forKey: .sourceUrl)
        resolvedUrl = try container.decodeIfPresent(String.self, forKey: .resolvedUrl)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        error = try container.decodeIfPresent(ErrorInfo.self, forKey: .error)
        classifiers = try container.decode([ClassifierResult].self, forKey: .classifiers)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sourceUrl, forKey: .sourceUrl)
        try container.encodeIfPresent(resolvedUrl, forKey: .resolvedUrl)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(error, forKey: .error)
        try container.encode(classifiers, forKey: .classifiers)
    }

}
