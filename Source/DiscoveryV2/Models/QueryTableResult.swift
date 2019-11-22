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
 A tables whose content or context match a search query.
 */
public struct QueryTableResult: Codable, Equatable {

    /**
     The identifier for the retrieved table.
     */
    public var tableID: String?

    /**
     The identifier of the document the table was retrieved from.
     */
    public var sourceDocumentID: String?

    /**
     The identifier of the collection the table was retrieved from.
     */
    public var collectionID: String?

    /**
     HTML snippet of the table info.
     */
    public var tableHTML: String?

    /**
     The offset of the table html snippet in the original document html.
     */
    public var tableHTMLOffset: Int?

    /**
     Full table object retrieved from Table Understanding Enrichment.
     */
    public var table: TableResultTable?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case tableID = "table_id"
        case sourceDocumentID = "source_document_id"
        case collectionID = "collection_id"
        case tableHTML = "table_html"
        case tableHTMLOffset = "table_html_offset"
        case table = "table"
    }

}
