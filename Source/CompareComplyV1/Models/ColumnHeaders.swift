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
import RestKit

/**
 Column-level cells, each applicable as a header to other cells in the same column as itself, of the current table.
 */
public struct ColumnHeaders: Codable, Equatable {

    /**
     The unique ID of the cell in the current table.
     */
    public var cellID: String?

    /**
     The location of the column header cell in the current table as defined by its `begin` and `end` offsets,
     respectfully, in the input document.
     */
    public var location: [String: JSON]?

    /**
     The textual contents of this cell from the input document without associated markup content.
     */
    public var text: String?

    /**
     If you provide customization input, the normalized version of the cell text according to the customization;
     otherwise, the same value as `text`.
     */
    public var textNormalized: String?

    /**
     The `begin` index of this cell's `row` location in the current table.
     */
    public var rowIndexBegin: Int?

    /**
     The `end` index of this cell's `row` location in the current table.
     */
    public var rowIndexEnd: Int?

    /**
     The `begin` index of this cell's `column` location in the current table.
     */
    public var columnIndexBegin: Int?

    /**
     The `end` index of this cell's `column` location in the current table.
     */
    public var columnIndexEnd: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case cellID = "cell_id"
        case location = "location"
        case text = "text"
        case textNormalized = "text_normalized"
        case rowIndexBegin = "row_index_begin"
        case rowIndexEnd = "row_index_end"
        case columnIndexBegin = "column_index_begin"
        case columnIndexEnd = "column_index_end"
    }

}
