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

/** Information about the deleted model. */
public struct DeleteModelResults {

    /// model_id of the deleted model.
    public var deleted: String?

    /**
     Initialize a `DeleteModelResults` with member variables.

     - parameter deleted: model_id of the deleted model.

     - returns: An initialized `DeleteModelResults`.
    */
    public init(deleted: String? = nil) {
        self.deleted = deleted
    }
}

extension DeleteModelResults: Codable {

    private enum CodingKeys: String, CodingKey {
        case deleted = "deleted"
        static let allValues = [deleted]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        deleted = try container.decodeIfPresent(String.self, forKey: .deleted)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(deleted, forKey: .deleted)
    }

}
