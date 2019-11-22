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
 Object that describes a long query.
 */
internal struct QueryLarge: Codable, Equatable {

    /**
     A comma-separated list of collection IDs to be queried against.
     */
    public var collectionIDs: [String]?

    /**
     A cacheable query that excludes documents that don't mention the query content. Filter searches are better for
     metadata-type searches and for assessing the concepts in the data set.
     */
    public var filter: String?

    /**
     A query search returns all documents in your data set with full enrichments and full text, but with the most
     relevant documents listed first. Use a query search when you want to find the most relevant search results.
     */
    public var query: String?

    /**
     A natural language query that returns relevant documents by utilizing training data and natural language
     understanding.
     */
    public var naturalLanguageQuery: String?

    /**
     An aggregation search that returns an exact answer by combining query search with filters. Useful for applications
     to build lists, tables, and time series. For a full list of possible aggregations, see the Query reference.
     */
    public var aggregation: String?

    /**
     Number of results to return.
     */
    public var count: Int?

    /**
     A list of the fields in the document hierarchy to return. If this parameter not specified, then all top-level
     fields are returned.
     */
    public var `return`: [String]?

    /**
     The number of query results to skip at the beginning. For example, if the total number of results that are returned
     is 10 and the offset is 8, it returns the last two results.
     */
    public var offset: Int?

    /**
     A comma-separated list of fields in the document to sort on. You can optionally specify a sort direction by
     prefixing the field with `-` for descending or `+` for ascending. Ascending is the default sort direction if no
     prefix is specified. This parameter cannot be used in the same query as the **bias** parameter.
     */
    public var sort: String?

    /**
     When `true`, a highlight field is returned for each result which contains the fields which match the query with
     `<em></em>` tags around the matching query terms.
     */
    public var highlight: Bool?

    /**
     When `true` and the **natural_language_query** parameter is used, the **natural_language_query** parameter is spell
     checked. The most likely correction is returned in the **suggested_query** field of the response (if one exists).
     */
    public var spellingSuggestions: Bool?

    /**
     Configuration for table retrieval.
     */
    public var tableResults: QueryLargeTableResults?

    /**
     Configuration for suggested refinements.
     */
    public var suggestedRefinements: QueryLargeSuggestedRefinements?

    /**
     Configuration for passage retrieval.
     */
    public var passages: QueryLargePassages?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case collectionIDs = "collection_ids"
        case filter = "filter"
        case query = "query"
        case naturalLanguageQuery = "natural_language_query"
        case aggregation = "aggregation"
        case count = "count"
        case `return` = "return"
        case offset = "offset"
        case sort = "sort"
        case highlight = "highlight"
        case spellingSuggestions = "spelling_suggestions"
        case tableResults = "table_results"
        case suggestedRefinements = "suggested_refinements"
        case passages = "passages"
    }

    /**
     Initialize a `QueryLarge` with member variables.

     - parameter collectionIDs: A comma-separated list of collection IDs to be queried against.
     - parameter filter: A cacheable query that excludes documents that don't mention the query content. Filter
       searches are better for metadata-type searches and for assessing the concepts in the data set.
     - parameter query: A query search returns all documents in your data set with full enrichments and full text,
       but with the most relevant documents listed first. Use a query search when you want to find the most relevant
       search results.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by utilizing training
       data and natural language understanding.
     - parameter aggregation: An aggregation search that returns an exact answer by combining query search with
       filters. Useful for applications to build lists, tables, and time series. For a full list of possible
       aggregations, see the Query reference.
     - parameter count: Number of results to return.
     - parameter `return`: A list of the fields in the document hierarchy to return. If this parameter not specified,
       then all top-level fields are returned.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results.
     - parameter sort: A comma-separated list of fields in the document to sort on. You can optionally specify a sort
       direction by prefixing the field with `-` for descending or `+` for ascending. Ascending is the default sort
       direction if no prefix is specified. This parameter cannot be used in the same query as the **bias** parameter.
     - parameter highlight: When `true`, a highlight field is returned for each result which contains the fields
       which match the query with `<em></em>` tags around the matching query terms.
     - parameter spellingSuggestions: When `true` and the **natural_language_query** parameter is used, the
       **natural_language_query** parameter is spell checked. The most likely correction is returned in the
       **suggested_query** field of the response (if one exists).
     - parameter tableResults: Configuration for table retrieval.
     - parameter suggestedRefinements: Configuration for suggested refinements.
     - parameter passages: Configuration for passage retrieval.

     - returns: An initialized `QueryLarge`.
     */
    public init(
        collectionIDs: [String]? = nil,
        filter: String? = nil,
        query: String? = nil,
        naturalLanguageQuery: String? = nil,
        aggregation: String? = nil,
        count: Int? = nil,
        `return`: [String]? = nil,
        offset: Int? = nil,
        sort: String? = nil,
        highlight: Bool? = nil,
        spellingSuggestions: Bool? = nil,
        tableResults: QueryLargeTableResults? = nil,
        suggestedRefinements: QueryLargeSuggestedRefinements? = nil,
        passages: QueryLargePassages? = nil
    )
    {
        self.collectionIDs = collectionIDs
        self.filter = filter
        self.query = query
        self.naturalLanguageQuery = naturalLanguageQuery
        self.aggregation = aggregation
        self.count = count
        self.`return` = `return`
        self.offset = offset
        self.sort = sort
        self.highlight = highlight
        self.spellingSuggestions = spellingSuggestions
        self.tableResults = tableResults
        self.suggestedRefinements = suggestedRefinements
        self.passages = passages
    }

}
