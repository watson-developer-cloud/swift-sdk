/**
 * (C) Copyright IBM Corp. 2020.
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
 Basic information about an updated object.
 */
public struct UpdateObjectMetadata: Codable, Equatable {

    /**
     The updated name of the object. The name can contain alphanumeric, underscore, hyphen, space, and dot characters.
     It cannot begin with the reserved prefix `sys-`.
     */
    public var object: String

    /**
     Number of bounding boxes in the collection with the updated object name.
     */
    public var count: Int

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case object = "object"
        case count = "count"
    }

    /**
     Initialize a `UpdateObjectMetadata` with member variables.

     - parameter object: The updated name of the object. The name can contain alphanumeric, underscore, hyphen,
       space, and dot characters. It cannot begin with the reserved prefix `sys-`.
     - parameter count: Number of bounding boxes in the collection with the updated object name.

     - returns: An initialized `UpdateObjectMetadata`.
     */
    public init(
        object: String,
        count: Int
    )
    {
        self.object = object
        self.count = count
    }

}
