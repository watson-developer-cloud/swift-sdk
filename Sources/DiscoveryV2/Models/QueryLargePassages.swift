/**
 * (C) Copyright IBM Corp. 2019, 2021.
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
 Configuration for passage retrieval.
 */
public struct QueryLargePassages: Codable, Equatable {

    /**
     A passages query that returns the most relevant passages from the results.
     */
    public var enabled: Bool?

    /**
     When `true`, passages will be returned within their respective result.
     */
    public var perDocument: Bool?

    /**
     Maximum number of passages to return per result.
     */
    public var maxPerDocument: Int?

    /**
     A list of fields that passages are drawn from. If this parameter not specified, then all top-level fields are
     included.
     */
    public var fields: [String]?

    /**
     The maximum number of passages to return. The search returns fewer passages if the requested total is not found.
     The maximum is `100`.
     */
    public var count: Int?

    /**
     The approximate number of characters that any one passage will have.
     */
    public var characters: Int?

    /**
     When true, `answer` objects are returned as part of each passage in the query results. The primary difference
     between an `answer` and a `passage` is that the length of a passage is defined by the query, where the length of an
     `answer` is calculated by Discovery based on how much text is needed to answer the question./n/nThis parameter is
     ignored if passages are not enabled for the query, or no **natural_language_query** is specified./n/nIf the
     **find_answers** parameter is set to `true` and **per_document** parameter is also set to `true`, then the document
     search results and the passage search results within each document are reordered using the answer confidences. The
     goal of this reordering is to do as much as possible to make sure that the first answer of the first passage of the
     first document is the best answer. Similarly, if the **find_answers** parameter is set to `true` and
     **per_document** parameter is set to `false`, then the passage search results are reordered in decreasing order of
     the highest confidence answer for each document and passage./n/nThe **find_answers** parameter is **beta**
     functionality available only on managed instances and should not be used in a production environment. This
     parameter is not available on installed instances of Discovery.
     */
    public var findAnswers: Bool?

    /**
     The number of `answer` objects to return per passage if the **find_answers** parmeter is specified as `true`.
     */
    public var maxAnswersPerPassage: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case perDocument = "per_document"
        case maxPerDocument = "max_per_document"
        case fields = "fields"
        case count = "count"
        case characters = "characters"
        case findAnswers = "find_answers"
        case maxAnswersPerPassage = "max_answers_per_passage"
    }

    /**
      Initialize a `QueryLargePassages` with member variables.

      - parameter enabled: A passages query that returns the most relevant passages from the results.
      - parameter perDocument: When `true`, passages will be returned within their respective result.
      - parameter maxPerDocument: Maximum number of passages to return per result.
      - parameter fields: A list of fields that passages are drawn from. If this parameter not specified, then all
        top-level fields are included.
      - parameter count: The maximum number of passages to return. The search returns fewer passages if the requested
        total is not found. The maximum is `100`.
      - parameter characters: The approximate number of characters that any one passage will have.
      - parameter findAnswers: When true, `answer` objects are returned as part of each passage in the query results.
        The primary difference between an `answer` and a `passage` is that the length of a passage is defined by the
        query, where the length of an `answer` is calculated by Discovery based on how much text is needed to answer the
        question./n/nThis parameter is ignored if passages are not enabled for the query, or no
        **natural_language_query** is specified./n/nIf the **find_answers** parameter is set to `true` and
        **per_document** parameter is also set to `true`, then the document search results and the passage search results
        within each document are reordered using the answer confidences. The goal of this reordering is to do as much as
        possible to make sure that the first answer of the first passage of the first document is the best answer.
        Similarly, if the **find_answers** parameter is set to `true` and **per_document** parameter is set to `false`,
        then the passage search results are reordered in decreasing order of the highest confidence answer for each
        document and passage./n/nThe **find_answers** parameter is **beta** functionality available only on managed
        instances and should not be used in a production environment. This parameter is not available on installed
        instances of Discovery.
      - parameter maxAnswersPerPassage: The number of `answer` objects to return per passage if the **find_answers**
        parmeter is specified as `true`.

      - returns: An initialized `QueryLargePassages`.
     */
    public init(
        enabled: Bool? = nil,
        perDocument: Bool? = nil,
        maxPerDocument: Int? = nil,
        fields: [String]? = nil,
        count: Int? = nil,
        characters: Int? = nil,
        findAnswers: Bool? = nil,
        maxAnswersPerPassage: Int? = nil
    )
    {
        self.enabled = enabled
        self.perDocument = perDocument
        self.maxPerDocument = maxPerDocument
        self.fields = fields
        self.count = count
        self.characters = characters
        self.findAnswers = findAnswers
        self.maxAnswersPerPassage = maxAnswersPerPassage
    }

}
