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

/** The response received when searching a specific query within the Solr cluster and collection,
 returned in ranked order. */
public struct SearchAndRankResponse: JSONDecodable {

    /// A header containing information about the response.
    public let header: SearchAndRankResponseHeader

    /// An object containing the results of the Search and Rank request.
    public let body: SearchAndRankResponseBody

    /// Used internally to initialize a `SearchAndRankResponse` model from JSON.
    public init(json: JSONWrapper) throws {
        header = try json.decode(at: "responseHeader", type: SearchAndRankResponseHeader.self)
        body = try json.decode(at: "response", type: SearchAndRankResponseBody.self)
    }
}

/** An object returned with a Search and Rank request, returning more information about the
 request. */
public struct SearchAndRankResponseHeader: JSONDecodable {

    /// The status.
    public let status: Int

    /// The query time.
    public let qTime: Int

    /// Used internally to initialize a `SearchAndRankResponseHeader` model from JSON.
    public init(json: JSONWrapper) throws {
        status = try json.getInt(at: "status")
        qTime = try json.getInt(at: "QTime")
    }
}

/** Contains the results of the Search and Rank request. */
public struct SearchAndRankResponseBody: JSONDecodable {

    /// The number of results found.
    public let numFound: Int

    /// The index the given results start from.
    public let start: Int

    /// The highest ranking score out of the potential answers.
    public let maxScore: Double

    /// A list of possible answers whose structure depends on the list of fields the user
    /// requested to be returned.
    public let documents: [Document]

    /// Used internally to initialize a `SearchAndRankResponseBody` model from JSON.
    public init(json: JSONWrapper) throws {
        numFound = try json.getInt(at: "numFound")
        start = try json.getInt(at: "start")
        maxScore = try json.getDouble(at: "maxScore")

        var docs = [Document]()
        let docsJSON = try json.getArray(at: "docs")
        for docJSON in docsJSON {
            if let doc = try JSONSerialization.jsonObject(
                                with: docJSON.serialize(),
                                options: JSONSerialization.ReadingOptions.allowFragments) as? Document {
                docs.append(doc)
            }
        }
        documents = docs
    }
}
