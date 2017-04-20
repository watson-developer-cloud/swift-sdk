/**
 * Copyright IBM Corporation 2017
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

/** CreateDialogNode. */
public struct CreateDialogNode: JSONDecodable, JSONEncodable {

    /// The dialog node ID.
    public let dialogNode: String

    /**
     Initialize a `CreateDialogNode` with member variables.

     - parameter dialogNode: The dialog node ID.

     - returns: An initialized `CreateDialogNode`.
    */
    public init(dialogNode: String) {
        self.dialogNode = dialogNode
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `CreateDialogNode` model from JSON.
    public init(json: JSON) throws {
        dialogNode = try json.getString(at: "dialog_node")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `CreateDialogNode` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["dialog_node"] = dialogNode
        return json
    }
}
