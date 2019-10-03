/**
 * (C) Copyright IBM Corp. 2019.
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
 Defines the location of the bounding box around the object.
 */
public struct Location: Codable, Equatable {

    /**
     Y-position of top-left pixel of the bounding box.
     */
    public var top: Int

    /**
     X-position of top-left pixel of the bounding box.
     */
    public var left: Int

    /**
     Width in pixels of of the bounding box.
     */
    public var width: Int

    /**
     Height in pixels of the bounding box.
     */
    public var height: Int

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case top = "top"
        case left = "left"
        case width = "width"
        case height = "height"
    }

    /**
     Initialize a `Location` with member variables.

     - parameter top: Y-position of top-left pixel of the bounding box.
     - parameter left: X-position of top-left pixel of the bounding box.
     - parameter width: Width in pixels of of the bounding box.
     - parameter height: Height in pixels of the bounding box.

     - returns: An initialized `Location`.
     */
    public init(
        top: Int,
        left: Int,
        width: Int,
        height: Int
    )
    {
        self.top = top
        self.left = left
        self.width = width
        self.height = height
    }

}
