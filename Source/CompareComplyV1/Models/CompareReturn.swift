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
 The comparison of the two submitted documents.
 */
public struct CompareReturn: Codable, Equatable {

    /**
     The analysis model used to compare the input documents. For the **Compare two documents** method, the only valid
     value is `contracts`.
     */
    public var modelID: String?

    /**
     The version of the analysis model identified by the value of the `model_id` key.
     */
    public var modelVersion: String?

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

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case modelID = "model_id"
        case modelVersion = "model_version"
        case documents = "documents"
        case alignedElements = "aligned_elements"
        case unalignedElements = "unaligned_elements"
    }

}
