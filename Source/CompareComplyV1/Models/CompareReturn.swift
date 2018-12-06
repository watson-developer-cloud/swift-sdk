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
 The comparison of the two submitted documents.
 */
public struct CompareReturn: Codable, Equatable {

    /**
     Information about the documents being compared.
     */
    public var documents: [Document]?

    /**
     A list of pairs of elements that semantically align between the compared documents.
     */
    public var alignedElements: [AlignedElement]?

    /**
     A list of elements that do not semantically align between the compared documents.
     */
    public var unalignedElements: [UnalignedElement]?

    /**
     The analysis model used to classify the input document. For the `/v1/element_classification` method, the only valid
     value is `contracts`.
     */
    public var modelID: String?

    /**
     The version of the analysis model identified by the value of the `model_id` key.
     */
    public var modelVersion: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case documents = "documents"
        case alignedElements = "aligned_elements"
        case unalignedElements = "unaligned_elements"
        case modelID = "model_id"
        case modelVersion = "model_version"
    }

}
