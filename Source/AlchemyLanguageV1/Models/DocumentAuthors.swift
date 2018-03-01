/**
 * Copyright IBM Corporation 2015
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

 **DocumentAuthors**

 Response object for Author related calls

 */

public struct DocumentAuthors: JSONDecodable {

    /** the url information was requested for */
    public let url: String

    /** see **Authors** */
    public let authors: Authors

    /// Used internally to initialize a DocumentAuthors object
    public init(json: JSONWrapper) throws {
        let status = try json.getString(at: "status")
        guard status == "OK" else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: DocumentAuthors.self)
        }

        url = try json.getString(at: "url")
        authors = try json.decode(at: "authors", type: Authors.self)
    }
}

