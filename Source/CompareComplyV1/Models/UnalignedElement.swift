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
 Element that does not align semantically between two compared documents.
 */
public struct UnalignedElement: Codable, Equatable {

    /**
     The label assigned to the document by the value of the `file_1_label` or `file_2_label` parameters on the **Compare
     two documents** method.
     */
    public var documentLabel: String?

    /**
     The numeric location of the identified element in the document, represented with two integers labeled `begin` and
     `end`.
     */
    public var location: Location?

    /**
     The text of the element.
     */
    public var text: String?

    /**
     Description of the action specified by the element and whom it affects.
     */
    public var types: [TypeLabelComparison]?

    /**
     List of functional categories into which the element falls; in other words, the subject matter of the element.
     */
    public var categories: [CategoryComparison]?

    /**
     List of document attributes.
     */
    public var attributes: [Attribute]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case documentLabel = "document_label"
        case location = "location"
        case text = "text"
        case types = "types"
        case categories = "categories"
        case attributes = "attributes"
    }

}
