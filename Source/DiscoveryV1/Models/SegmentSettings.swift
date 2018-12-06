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

/**
 A list of Document Segmentation settings.
 */
public struct SegmentSettings: Codable, Equatable {

    /**
     Enables/disables the Document Segmentation feature.
     */
    public var enabled: Bool?

    /**
     Defines the heading level that splits into document segments. Valid values are h1, h2, h3, h4, h5, h6.
     */
    public var selectorTags: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case selectorTags = "selector_tags"
    }

    /**
     Initialize a `SegmentSettings` with member variables.

     - parameter enabled: Enables/disables the Document Segmentation feature.
     - parameter selectorTags: Defines the heading level that splits into document segments. Valid values are h1, h2,
       h3, h4, h5, h6.

     - returns: An initialized `SegmentSettings`.
    */
    public init(
        enabled: Bool? = nil,
        selectorTags: [String]? = nil
    )
    {
        self.enabled = enabled
        self.selectorTags = selectorTags
    }

}
