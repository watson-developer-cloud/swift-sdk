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
 Object containing smart document understanding information for this collection.
 */
public struct SduStatus: Codable, Equatable {

    /**
     When `true`, smart document understanding conversion is enabled for this collection. All collections created with a
     version date after `2019-04-30` have smart document understanding enabled. If `false`, documents added to the
     collection are converted using the **conversion** settings specified in the configuration associated with the
     collection.
     */
    public var enabled: Bool?

    /**
     The total number of pages annotated using smart document understanding in this collection.
     */
    public var totalAnnotatedPages: Int?

    /**
     The current number of pages that can be used for training smart document understanding. The `total_pages` number is
     calculated as the total number of pages identified from the documents listed in the **total_documents** field.
     */
    public var totalPages: Int?

    /**
     The total number of documents in this collection that can be used to train smart document understanding. For
     **lite** plan collections, the maximum is the first 20 uploaded documents (not including HTML or JSON documents).
     For other plans, the maximum is the first 40 uploaded documents (not including HTML or JSON documents). When the
     maximum is reached, additional documents uploaded to the collection are not considered for training smart document
     understanding.
     */
    public var totalDocuments: Int?

    /**
     Information about custom smart document understanding fields that exist in this collection.
     */
    public var customFields: SduStatusCustomFields?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case totalAnnotatedPages = "total_annotated_pages"
        case totalPages = "total_pages"
        case totalDocuments = "total_documents"
        case customFields = "custom_fields"
    }

}
