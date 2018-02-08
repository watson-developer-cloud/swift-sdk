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

/** DialogNodeVisitedDetails. */
public struct DialogNodeVisitedDetails {

    /// A dialog node that was triggered during processing of the input message.
    public var dialogNode: String?

    /// The title of the dialog node.
    public var title: String?

    /**
     Initialize a `DialogNodeVisitedDetails` with member variables.

     - parameter dialogNode: A dialog node that was triggered during processing of the input message.
     - parameter title: The title of the dialog node.

     - returns: An initialized `DialogNodeVisitedDetails`.
    */
    public init(dialogNode: String? = nil, title: String? = nil) {
        self.dialogNode = dialogNode
        self.title = title
    }
}

extension DialogNodeVisitedDetails: Codable {

    private enum CodingKeys: String, CodingKey {
        case dialogNode = "dialog_node"
        case title = "title"
        static let allValues = [dialogNode, title]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dialogNode = try container.decodeIfPresent(String.self, forKey: .dialogNode)
        title = try container.decodeIfPresent(String.self, forKey: .title)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(dialogNode, forKey: .dialogNode)
        try container.encodeIfPresent(title, forKey: .title)
    }

}
