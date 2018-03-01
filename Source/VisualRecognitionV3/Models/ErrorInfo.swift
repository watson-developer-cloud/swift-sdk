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

/** Information about what might have caused a failure, such as an image that is too large. Not returned when there is no error. */
public struct ErrorInfo {

    /// HTTP status code.
    public var code: Int

    /// Human-readable error description. For example, `File size limit exceeded`.
    public var description: String

    /// Codified error string. For example, `limit_exceeded`.
    public var errorID: String

    /**
     Initialize a `ErrorInfo` with member variables.

     - parameter code: HTTP status code.
     - parameter description: Human-readable error description. For example, `File size limit exceeded`.
     - parameter errorID: Codified error string. For example, `limit_exceeded`.

     - returns: An initialized `ErrorInfo`.
    */
    public init(code: Int, description: String, errorID: String) {
        self.code = code
        self.description = description
        self.errorID = errorID
    }
}

extension ErrorInfo: Codable {

    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case description = "description"
        case errorID = "error_id"
        static let allValues = [code, description, errorID]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(Int.self, forKey: .code)
        description = try container.decode(String.self, forKey: .description)
        errorID = try container.decode(String.self, forKey: .errorID)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(description, forKey: .description)
        try container.encode(errorID, forKey: .errorID)
    }

}
