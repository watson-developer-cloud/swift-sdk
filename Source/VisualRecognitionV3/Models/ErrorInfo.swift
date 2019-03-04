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

/**
 Information about what might have caused a failure, such as an image that is too large. Not returned when there is no
 error.
 */
public struct ErrorInfo: Codable, Equatable {

    /**
     HTTP status code.
     */
    public var code: Int

    /**
     Human-readable error description. For example, `File size limit exceeded`.
     */
    public var description: String

    /**
     Codified error string. For example, `limit_exceeded`.
     */
    public var errorID: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case description = "description"
        case errorID = "error_id"
    }

}
