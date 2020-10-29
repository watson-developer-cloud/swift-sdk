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
 Full table object retrieved from Table Understanding Enrichment.
 */
public struct TableResultTable: Codable, Equatable {

    /**
     The numeric location of the identified element in the document, represented with two integers labeled `begin` and
     `end`.
     */
    public var location: TableElementLocation?

    /**
     The textual contents of the current table from the input document without associated markup content.
     */
    public var text: String?

    /**
     Text and associated location within a table.
     */
    public var sectionTitle: TableTextLocation?

    /**
     Text and associated location within a table.
     */
    public var title: TableTextLocation?

    /**
     An array of table-level cells that apply as headers to all the other cells in the current table.
     */
    public var tableHeaders: [TableHeaders]?

    /**
     An array of row-level cells, each applicable as a header to other cells in the same row as itself, of the current
     table.
     */
    public var rowHeaders: [TableRowHeaders]?

    /**
     An array of column-level cells, each applicable as a header to other cells in the same column as itself, of the
     current table.
     */
    public var columnHeaders: [TableColumnHeaders]?

    /**
     An array of key-value pairs identified in the current table.
     */
    public var keyValuePairs: [TableKeyValuePairs]?

    /**
     An array of cells that are neither table header nor column header nor row header cells, of the current table with
     corresponding row and column header associations.
     */
    public var bodyCells: [TableBodyCells]?

    /**
     An array of lists of textual entries across the document related to the current table being parsed.
     */
    public var contexts: [TableTextLocation]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case location = "location"
        case text = "text"
        case sectionTitle = "section_title"
        case title = "title"
        case tableHeaders = "table_headers"
        case rowHeaders = "row_headers"
        case columnHeaders = "column_headers"
        case keyValuePairs = "key_value_pairs"
        case bodyCells = "body_cells"
        case contexts = "contexts"
    }

}
