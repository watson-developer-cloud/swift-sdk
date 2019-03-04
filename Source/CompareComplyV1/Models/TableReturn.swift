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
 The analysis of the document's tables.
 */
public struct TableReturn: Codable, Equatable {

    /**
     Information about the parsed input document.
     */
    public var document: DocInfo?

    /**
     The ID of the model used to extract the table contents. The value for table extraction is `tables`.
     */
    public var modelID: String?

    /**
     The version of the `tables` model ID.
     */
    public var modelVersion: String?

    /**
     Definitions of the tables identified in the input document.
     */
    public var tables: [Tables]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case document = "document"
        case modelID = "model_id"
        case modelVersion = "model_version"
        case tables = "tables"
    }

}
