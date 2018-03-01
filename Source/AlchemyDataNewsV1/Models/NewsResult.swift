/**
 * Copyright IBM Corporation 2016
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

 **NewsResult**

 The result of the query given to the AlchemyDataNews service

 */
public struct NewsResult: JSONDecodable {

    /** see **Document** */
    public let docs: [Document]?

    /** a query may return multiple pages of results. Append this value with the key 'next' to
     your query to access the next page of results */
    public let next: String?

    /** the number of documents that fit the query */
    public let count: Int?

    /** the number of articles within a defined time slice */
    public let slices: [Int]?

    /// used internally to initialize NewsResult objects
    public init(json: JSONWrapper) throws {
        docs = try? json.decodedArray(at: "docs", type: Document.self)
        next = try? json.getString(at: "next")
        count = try? json.getInt(at: "count")
        slices = try? json.decodedArray(at: "slices", type: Int.self)
    }

}
