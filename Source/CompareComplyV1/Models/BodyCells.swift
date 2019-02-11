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
 Cells that are not table header, column header, or row header cells.
 */
public struct BodyCells: Codable, Equatable {

    /**
     A string value in the format `columnHeader-x-y`, where `x` and `y` are the begin and end offsets of this column
     header cell in the input document.
     */
    public var cellID: String?

    /**
     The numeric location of the identified element in the document, represented with two integers labeled `begin` and
     `end`.
     */
    public var location: Location?

    /**
     The textual contents of this cell from the input document without associated markup content.
     */
    public var text: String?

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

    /**
     An array of values, each being the `id` value of a row header that is applicable to this body cell.
     */
    public var rowHeaderIDs: [String]?

    /**
     An array of values, each being the `text` value of a row header that is applicable to this body cell.
     */
    public var rowHeaderTexts: [String]?

    /**
     If you provide customization input, the normalized version of the row header texts according to the customization;
     otherwise, the same value as `row_header_texts`.
     */
    public var rowHeaderTextsNormalized: [String]?

    /**
     An array of values, each being the `id` value of a column header that is applicable to the current cell.
     */
    public var columnHeaderIDs: [String]?

    /**
     An array of values, each being the `text` value of a column header that is applicable to the current cell.
     */
    public var columnHeaderTexts: [String]?

    /**
     If you provide customization input, the normalized version of the column header texts according to the
     customization; otherwise, the same value as `column_header_texts`.
     */
    public var columnHeaderTextsNormalized: [String]?

    public var attributes: [Attribute]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case cellID = "cell_id"
        case location = "location"
        case text = "text"
        case rowIndexBegin = "row_index_begin"
        case rowIndexEnd = "row_index_end"
        case columnIndexBegin = "column_index_begin"
        case columnIndexEnd = "column_index_end"
        case rowHeaderIDs = "row_header_ids"
        case rowHeaderTexts = "row_header_texts"
        case rowHeaderTextsNormalized = "row_header_texts_normalized"
        case columnHeaderIDs = "column_header_ids"
        case columnHeaderTexts = "column_header_texts"
        case columnHeaderTextsNormalized = "column_header_texts_normalized"
        case attributes = "attributes"
    }

}
