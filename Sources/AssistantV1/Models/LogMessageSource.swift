/**
 * (C) Copyright IBM Corp. 2021.
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
 An object that identifies the dialog element that generated the error message.
 */
public struct LogMessageSource: Codable, Equatable {

    /**
     A string that indicates the type of dialog element that generated the error message.
     */
    public enum TypeEnum: String {
        case dialogNode = "dialog_node"
    }

    /**
     A string that indicates the type of dialog element that generated the error message.
     */
    public var type: String?

    /**
     The unique identifier of the dialog node that generated the error message.
     */
    public var dialogNode: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case dialogNode = "dialog_node"
    }

    /**
      Initialize a `LogMessageSource` with member variables.

      - parameter type: A string that indicates the type of dialog element that generated the error message.
      - parameter dialogNode: The unique identifier of the dialog node that generated the error message.

      - returns: An initialized `LogMessageSource`.
     */
    public init(
        type: String? = nil,
        dialogNode: String? = nil
    )
    {
        self.type = type
        self.dialogNode = dialogNode
    }

}
