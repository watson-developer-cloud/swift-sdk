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
import RestKit

/** DialogSuggestion. */
public struct DialogSuggestion: Codable, Equatable {

    /**
     The user-facing label for the disambiguation option. This label is taken from the **user_label** property of the
     corresponding dialog node.
     */
    public var label: String

    /**
     An object defining the message input to be sent to the assistant if the user selects the corresponding
     disambiguation option.
     */
    public var value: DialogSuggestionValue

    /**
     The dialog output that will be returned from the Watson Assistant service if the user selects the corresponding
     option.
     */
    public var output: [String: JSON]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case label = "label"
        case value = "value"
        case output = "output"
    }

}
