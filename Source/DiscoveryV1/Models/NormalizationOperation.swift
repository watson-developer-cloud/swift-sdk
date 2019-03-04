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

/** NormalizationOperation. */
public struct NormalizationOperation: Codable, Equatable {

    /**
     Identifies what type of operation to perform.
     **copy** - Copies the value of the **source_field** to the **destination_field** field. If the
     **destination_field** already exists, then the value of the **source_field** overwrites the original value of the
     **destination_field**.
     **move** - Renames (moves) the **source_field** to the **destination_field**. If the **destination_field** already
     exists, then the value of the **source_field** overwrites the original value of the **destination_field**. Rename
     is identical to copy, except that the **source_field** is removed after the value has been copied to the
     **destination_field** (it is the same as a _copy_ followed by a _remove_).
     **merge** - Merges the value of the **source_field** with the value of the **destination_field**. The
     **destination_field** is converted into an array if it is not already an array, and the value of the
     **source_field** is appended to the array. This operation removes the **source_field** after the merge. If the
     **source_field** does not exist in the current document, then the **destination_field** is still converted into an
     array (if it is not an array already). This conversion ensures the type for **destination_field** is consistent
     across all documents.
     **remove** - Deletes the **source_field** field. The **destination_field** is ignored for this operation.
     **remove_nulls** - Removes all nested null (blank) field values from the ingested document. **source_field** and
     **destination_field** are ignored by this operation because _remove_nulls_ operates on the entire ingested
     document. Typically, **remove_nulls** is invoked as the last normalization operation (if it is invoked at all, it
     can be time-expensive).
     */
    public enum Operation: String {
        case copy = "copy"
        case move = "move"
        case merge = "merge"
        case remove = "remove"
        case removeNulls = "remove_nulls"
    }

    /**
     Identifies what type of operation to perform.
     **copy** - Copies the value of the **source_field** to the **destination_field** field. If the
     **destination_field** already exists, then the value of the **source_field** overwrites the original value of the
     **destination_field**.
     **move** - Renames (moves) the **source_field** to the **destination_field**. If the **destination_field** already
     exists, then the value of the **source_field** overwrites the original value of the **destination_field**. Rename
     is identical to copy, except that the **source_field** is removed after the value has been copied to the
     **destination_field** (it is the same as a _copy_ followed by a _remove_).
     **merge** - Merges the value of the **source_field** with the value of the **destination_field**. The
     **destination_field** is converted into an array if it is not already an array, and the value of the
     **source_field** is appended to the array. This operation removes the **source_field** after the merge. If the
     **source_field** does not exist in the current document, then the **destination_field** is still converted into an
     array (if it is not an array already). This conversion ensures the type for **destination_field** is consistent
     across all documents.
     **remove** - Deletes the **source_field** field. The **destination_field** is ignored for this operation.
     **remove_nulls** - Removes all nested null (blank) field values from the ingested document. **source_field** and
     **destination_field** are ignored by this operation because _remove_nulls_ operates on the entire ingested
     document. Typically, **remove_nulls** is invoked as the last normalization operation (if it is invoked at all, it
     can be time-expensive).
     */
    public var operation: String?

    /**
     The source field for the operation.
     */
    public var sourceField: String?

    /**
     The destination field for the operation.
     */
    public var destinationField: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case operation = "operation"
        case sourceField = "source_field"
        case destinationField = "destination_field"
    }

    /**
     Initialize a `NormalizationOperation` with member variables.

     - parameter operation: Identifies what type of operation to perform.
       **copy** - Copies the value of the **source_field** to the **destination_field** field. If the
       **destination_field** already exists, then the value of the **source_field** overwrites the original value of the
       **destination_field**.
       **move** - Renames (moves) the **source_field** to the **destination_field**. If the **destination_field**
       already exists, then the value of the **source_field** overwrites the original value of the
       **destination_field**. Rename is identical to copy, except that the **source_field** is removed after the value
       has been copied to the **destination_field** (it is the same as a _copy_ followed by a _remove_).
       **merge** - Merges the value of the **source_field** with the value of the **destination_field**. The
       **destination_field** is converted into an array if it is not already an array, and the value of the
       **source_field** is appended to the array. This operation removes the **source_field** after the merge. If the
       **source_field** does not exist in the current document, then the **destination_field** is still converted into
       an array (if it is not an array already). This conversion ensures the type for **destination_field** is
       consistent across all documents.
       **remove** - Deletes the **source_field** field. The **destination_field** is ignored for this operation.
       **remove_nulls** - Removes all nested null (blank) field values from the ingested document. **source_field** and
       **destination_field** are ignored by this operation because _remove_nulls_ operates on the entire ingested
       document. Typically, **remove_nulls** is invoked as the last normalization operation (if it is invoked at all, it
       can be time-expensive).
     - parameter sourceField: The source field for the operation.
     - parameter destinationField: The destination field for the operation.

     - returns: An initialized `NormalizationOperation`.
    */
    public init(
        operation: String? = nil,
        sourceField: String? = nil,
        destinationField: String? = nil
    )
    {
        self.operation = operation
        self.sourceField = sourceField
        self.destinationField = destinationField
    }

}
