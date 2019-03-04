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
 The contents of the tables extracted from a document.
 */
public struct Tables: Codable, Equatable {

    /**
     The numeric location of the identified element in the document, represented with two integers labeled `begin` and
     `end`.
     */
    public var location: Location?

    /**
     The textual contents of the current table from the input document without associated markup content.
     */
    public var text: String?

    /**
     The table's section title, if identified.
     */
    public var sectionTitle: SectionTitle?

    /**
     An array of table-level cells that apply as headers to all the other cells in the current table.
     */
    public var tableHeaders: [TableHeaders]?

    /**
     An array of row-level cells, each applicable as a header to other cells in the same row as itself, of the current
     table.
     */
    public var rowHeaders: [RowHeaders]?

    /**
     An array of column-level cells, each applicable as a header to other cells in the same column as itself, of the
     current table.
     */
    public var columnHeaders: [ColumnHeaders]?

    /**
     An array of key-value pairs identified in the current table.
     */
    public var keyValuePairs: [KeyValuePair]?

    /**
     An array of cells that are neither table header nor column header nor row header cells, of the current table with
     corresponding row and column header associations.
     */
    public var bodyCells: [BodyCells]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case location = "location"
        case text = "text"
        case sectionTitle = "section_title"
        case tableHeaders = "table_headers"
        case rowHeaders = "row_headers"
        case columnHeaders = "column_headers"
        case keyValuePairs = "key_value_pairs"
        case bodyCells = "body_cells"
    }

}
