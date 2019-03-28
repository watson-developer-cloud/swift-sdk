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
 Information about faces in the image.
 */
public struct ImageWithFaces: Codable, Equatable {

    /**
     Faces detected in the images.
     */
    public var faces: [Face]

    /**
     Relative path of the image file if uploaded directly. Not returned when the image is passed by URL.
     */
    public var image: String?

    /**
     Source of the image before any redirects. Not returned when the image is uploaded.
     */
    public var sourceURL: String?

    /**
     Fully resolved URL of the image after redirects are followed. Not returned when the image is uploaded.
     */
    public var resolvedURL: String?

    /**
     Information about what might have caused a failure, such as an image that is too large. Not returned when there is
     no error.
     */
    public var error: ErrorInfo?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case faces = "faces"
        case image = "image"
        case sourceURL = "source_url"
        case resolvedURL = "resolved_url"
        case error = "error"
    }

}
