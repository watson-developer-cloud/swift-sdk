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

/** Defines the location of the bounding box around the face. */
public struct FaceLocation {

    /// Width in pixels of face region.
    public var width: Double

    /// Height in pixels of face region.
    public var height: Double

    /// X-position of top-left pixel of face region.
    public var left: Double

    /// Y-position of top-left pixel of face region.
    public var top: Double

    /**
     Initialize a `FaceLocation` with member variables.

     - parameter width: Width in pixels of face region.
     - parameter height: Height in pixels of face region.
     - parameter left: X-position of top-left pixel of face region.
     - parameter top: Y-position of top-left pixel of face region.

     - returns: An initialized `FaceLocation`.
    */
    public init(width: Double, height: Double, left: Double, top: Double) {
        self.width = width
        self.height = height
        self.left = left
        self.top = top
    }
}

extension FaceLocation: Codable {

    private enum CodingKeys: String, CodingKey {
        case width = "width"
        case height = "height"
        case left = "left"
        case top = "top"
        static let allValues = [width, height, left, top]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        width = try container.decode(Double.self, forKey: .width)
        height = try container.decode(Double.self, forKey: .height)
        left = try container.decode(Double.self, forKey: .left)
        top = try container.decode(Double.self, forKey: .top)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(left, forKey: .left)
        try container.encode(top, forKey: .top)
    }

}
