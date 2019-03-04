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
 The location of the bounding box around the face.
 */
public struct FaceLocation: Codable, Equatable {

    /**
     Width in pixels of face region.
     */
    public var width: Double

    /**
     Height in pixels of face region.
     */
    public var height: Double

    /**
     X-position of top-left pixel of face region.
     */
    public var left: Double

    /**
     Y-position of top-left pixel of face region.
     */
    public var top: Double

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case width = "width"
        case height = "height"
        case left = "left"
        case top = "top"
    }

}
