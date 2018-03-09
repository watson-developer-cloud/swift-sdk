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

/** The response received when searching a specific query within the Solr cluster and collection. */
public struct SearchResponse: JSONDecodable {

    /// A header containing information about the request and response.
    public let header: SearchResponseHeader

    /// An object containing the results of the Search request.
    public let body: SearchResponseBody

    /// Used internally to initialize a `SearchResponse` model from JSON.
    public init(json: JSONWrapper) throws {
        header = try json.decode(at: "responseHeader", type: SearchResponseHeader.self)
        body = try json.decode(at: "response", type: SearchResponseBody.self)
    }
}

/** An object returned with a Search request, returning more information about the request. */
public struct SearchResponseHeader: JSONDecodable {

    /// The status.
    public let status: Int

    /// The query time.
    public let qTime: Int

    /// An object containing the parameters that were sent in the request.
    public let params: RequestParameters

    /// Used internally to initialize a `SearchResponseHeader` model from JSON.
    public init(json: JSONWrapper) throws {
        status = try json.getInt(at: "status")
        qTime = try json.getInt(at: "QTime")
        params = try json.decode(at: "params", type: RequestParameters.self)
    }
}

/** An object containing the query parameters that were sent in the original request. */
public struct RequestParameters: JSONDecodable {

    /// The original query string.
    public let query: String

    /// The return fields the user specified.
    public let returnFields: String

    /// The writer type.
    public let writerType: String

    /// Used internally to initialize a `RequestParameters` model from JSON.
    public init(json: JSONWrapper) throws {
        query = try json.getString(at: "q")
        returnFields = try json.getString(at: "fl")
        writerType = try json.getString(at: "wt")
    }
}

/** A named alias for the document results returned by a search function. */
public typealias Document = NSDictionary

/** Contains the results of the Search request. */
public struct SearchResponseBody: JSONDecodable {

    /// The number of results found.
    public let numFound: Int

    /// The index the given results start from.
    public let start: Int

    /// A list of possible answers whose structure depends on the list of fields the user
    /// requested to be returned.
    public let documents: [Document]

    /// Used internally to initialize a `SearchResponseBody` model from JSON.
    public init(json: JSONWrapper) throws {
        numFound = try json.getInt(at: "numFound")
        start = try json.getInt(at: "start")

        var docs = [Document]()
        let docsJSON = try json.getArray(at: "docs")
        for docJSON in docsJSON {
            if let doc = try JSONSerialization.jsonObject(with: docJSON.serialize(), options: JSONSerialization.ReadingOptions.allowFragments) as? Document {
                docs.append(doc)
            }
        }
        documents = docs
    }
}
