/**
 * (C) Copyright IBM Corp. 2019.
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
 Details about an error.
 */
public struct Error: Codable, Equatable {

    /**
     Identifier of the problem.
     */
    public enum Code: String {
        case invalidField = "invalid_field"
        case invalidHeader = "invalid_header"
        case invalidMethod = "invalid_method"
        case missingField = "missing_field"
        case serverError = "server_error"
    }

    /**
     Identifier of the problem.
     */
    public var code: String

    /**
     An explanation of the problem with possible solutions.
     */
    public var message: String

    /**
     A URL for more information about the solution.
     */
    public var moreInfo: String?

    /**
     Details about the specific area of the problem.
     */
    public var target: ErrorTarget?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case moreInfo = "more_info"
        case target = "target"
    }

}
