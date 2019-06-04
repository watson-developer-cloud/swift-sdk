/**
 * (C) Copyright IBM Corp. 2018, 2019.
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
     Defines the heading level that splits into document segments. Valid values are h1, h2, h3, h4, h5, h6. The content
     of the header field that the segmentation splits at is used as the **title** field for that segmented result. Only
     valid if used with a collection that has **enabled** set to `false` in the **smart_document_understanding** object.
     */
    public var selectorTags: [String]?

    /**
     Defines the annotated smart document understanding fields that the document is split on. The content of the
     annotated field that the segmentation splits at is used as the **title** field for that segmented result. For
     example, if the field `sub-title` is specified, when a document is uploaded each time the smart documement
     understanding conversion encounters a field of type `sub-title` the document is split at that point and the content
     of the field used as the title of the remaining content. Thnis split is performed for all instances of the listed
     fields in the uploaded document. Only valid if used with a collection that has **enabled** set to `true` in the
     **smart_document_understanding** object.
     */
    public var annotatedFields: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case selectorTags = "selector_tags"
        case annotatedFields = "annotated_fields"
    }

    /**
     Initialize a `SegmentSettings` with member variables.

     - parameter enabled: Enables/disables the Document Segmentation feature.
     - parameter selectorTags: Defines the heading level that splits into document segments. Valid values are h1, h2,
       h3, h4, h5, h6. The content of the header field that the segmentation splits at is used as the **title** field
       for that segmented result. Only valid if used with a collection that has **enabled** set to `false` in the
       **smart_document_understanding** object.
     - parameter annotatedFields: Defines the annotated smart document understanding fields that the document is
       split on. The content of the annotated field that the segmentation splits at is used as the **title** field for
       that segmented result. For example, if the field `sub-title` is specified, when a document is uploaded each time
       the smart documement understanding conversion encounters a field of type `sub-title` the document is split at
       that point and the content of the field used as the title of the remaining content. Thnis split is performed for
       all instances of the listed fields in the uploaded document. Only valid if used with a collection that has
       **enabled** set to `true` in the **smart_document_understanding** object.

     - returns: An initialized `SegmentSettings`.
     */
    public init(
        enabled: Bool? = nil,
        selectorTags: [String]? = nil,
        annotatedFields: [String]? = nil
    )
    {
        self.enabled = enabled
        self.selectorTags = selectorTags
        self.annotatedFields = annotatedFields
    }

}
