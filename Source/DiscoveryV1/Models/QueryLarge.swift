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
 Object that describes a long query.
 */
internal struct QueryLarge: Codable, Equatable {

    /**
     A cacheable query that excludes documents that don't mention the query content. Filter searches are better for
     metadata-type searches and for assessing the concepts in the data set.
     */
    public var filter: String?

    /**
     A query search returns all documents in your data set with full enrichments and full text, but with the most
     relevant documents listed first. Use a query search when you want to find the most relevant search results. You
     cannot use **natural_language_query** and **query** at the same time.
     */
    public var query: String?

    /**
     A natural language query that returns relevant documents by utilizing training data and natural language
     understanding. You cannot use **natural_language_query** and **query** at the same time.
     */
    public var naturalLanguageQuery: String?

    /**
     A passages query that returns the most relevant passages from the results.
     */
    public var passages: Bool?

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
     A comma-separated list of the portion of the document hierarchy to return.
     */
    public var returnFields: String?

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
     When true, a highlight field is returned for each result which contains the fields which match the query with
     `<em></em>` tags around the matching query terms.
     */
    public var highlight: Bool?

    /**
     A comma-separated list of fields that passages are drawn from. If this parameter not specified, then all top-level
     fields are included.
     */
    public var passagesFields: String?

    /**
     The maximum number of passages to return. The search returns fewer passages if the requested total is not found.
     The default is `10`. The maximum is `100`.
     */
    public var passagesCount: Int?

    /**
     The approximate number of characters that any one passage will have.
     */
    public var passagesCharacters: Int?

    /**
     When `true`, and used with a Watson Discovery News collection, duplicate results (based on the contents of the
     **title** field) are removed. Duplicate comparison is limited to the current query only; **offset** is not
     considered. This parameter is currently Beta functionality.
     */
    public var deduplicate: Bool?

    /**
     When specified, duplicate results based on the field specified are removed from the returned results. Duplicate
     comparison is limited to the current query only, **offset** is not considered. This parameter is currently Beta
     functionality.
     */
    public var deduplicateField: String?

    /**
     A comma-separated list of collection IDs to be queried against. Required when querying multiple collections,
     invalid when performing a single collection query.
     */
    public var collectionIDs: String?

    /**
     When `true`, results are returned based on their similarity to the document IDs specified in the
     **similar.document_ids** parameter.
     */
    public var similar: Bool?

    /**
     A comma-separated list of document IDs to find similar documents.
     **Tip:** Include the **natural_language_query** parameter to expand the scope of the document similarity search
     with the natural language query. Other query parameters, such as **filter** and **query**, are subsequently applied
     and reduce the scope.
     */
    public var similarDocumentIDs: String?

    /**
     A comma-separated list of field names that are used as a basis for comparison to identify similar documents. If not
     specified, the entire document is used for comparison.
     */
    public var similarFields: String?

    /**
     Field which the returned results will be biased against. The specified field must be either a **date** or
     **number** format. When a **date** type field is specified returned results are biased towards field values closer
     to the current date. When a **number** type field is specified, returned results are biased towards higher field
     values. This parameter cannot be used in the same query as the **sort** parameter.
     */
    public var bias: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case filter = "filter"
        case query = "query"
        case naturalLanguageQuery = "natural_language_query"
        case passages = "passages"
        case aggregation = "aggregation"
        case count = "count"
        case returnFields = "return"
        case offset = "offset"
        case sort = "sort"
        case highlight = "highlight"
        case passagesFields = "passages.fields"
        case passagesCount = "passages.count"
        case passagesCharacters = "passages.characters"
        case deduplicate = "deduplicate"
        case deduplicateField = "deduplicate.field"
        case collectionIDs = "collection_ids"
        case similar = "similar"
        case similarDocumentIDs = "similar.document_ids"
        case similarFields = "similar.fields"
        case bias = "bias"
    }

    /**
     Initialize a `QueryLarge` with member variables.

     - parameter filter: A cacheable query that excludes documents that don't mention the query content. Filter
       searches are better for metadata-type searches and for assessing the concepts in the data set.
     - parameter query: A query search returns all documents in your data set with full enrichments and full text,
       but with the most relevant documents listed first. Use a query search when you want to find the most relevant
       search results. You cannot use **natural_language_query** and **query** at the same time.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by utilizing training
       data and natural language understanding. You cannot use **natural_language_query** and **query** at the same
       time.
     - parameter passages: A passages query that returns the most relevant passages from the results.
     - parameter aggregation: An aggregation search that returns an exact answer by combining query search with
       filters. Useful for applications to build lists, tables, and time series. For a full list of possible
       aggregations, see the Query reference.
     - parameter count: Number of results to return.
     - parameter returnFields: A comma-separated list of the portion of the document hierarchy to return.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results.
     - parameter sort: A comma-separated list of fields in the document to sort on. You can optionally specify a sort
       direction by prefixing the field with `-` for descending or `+` for ascending. Ascending is the default sort
       direction if no prefix is specified. This parameter cannot be used in the same query as the **bias** parameter.
     - parameter highlight: When true, a highlight field is returned for each result which contains the fields which
       match the query with `<em></em>` tags around the matching query terms.
     - parameter passagesFields: A comma-separated list of fields that passages are drawn from. If this parameter not
       specified, then all top-level fields are included.
     - parameter passagesCount: The maximum number of passages to return. The search returns fewer passages if the
       requested total is not found. The default is `10`. The maximum is `100`.
     - parameter passagesCharacters: The approximate number of characters that any one passage will have.
     - parameter deduplicate: When `true`, and used with a Watson Discovery News collection, duplicate results (based
       on the contents of the **title** field) are removed. Duplicate comparison is limited to the current query only;
       **offset** is not considered. This parameter is currently Beta functionality.
     - parameter deduplicateField: When specified, duplicate results based on the field specified are removed from
       the returned results. Duplicate comparison is limited to the current query only, **offset** is not considered.
       This parameter is currently Beta functionality.
     - parameter collectionIDs: A comma-separated list of collection IDs to be queried against. Required when
       querying multiple collections, invalid when performing a single collection query.
     - parameter similar: When `true`, results are returned based on their similarity to the document IDs specified
       in the **similar.document_ids** parameter.
     - parameter similarDocumentIDs: A comma-separated list of document IDs to find similar documents.
       **Tip:** Include the **natural_language_query** parameter to expand the scope of the document similarity search
       with the natural language query. Other query parameters, such as **filter** and **query**, are subsequently
       applied and reduce the scope.
     - parameter similarFields: A comma-separated list of field names that are used as a basis for comparison to
       identify similar documents. If not specified, the entire document is used for comparison.
     - parameter bias: Field which the returned results will be biased against. The specified field must be either a
       **date** or **number** format. When a **date** type field is specified returned results are biased towards field
       values closer to the current date. When a **number** type field is specified, returned results are biased towards
       higher field values. This parameter cannot be used in the same query as the **sort** parameter.

     - returns: An initialized `QueryLarge`.
    */
    public init(
        filter: String? = nil,
        query: String? = nil,
        naturalLanguageQuery: String? = nil,
        passages: Bool? = nil,
        aggregation: String? = nil,
        count: Int? = nil,
        returnFields: String? = nil,
        offset: Int? = nil,
        sort: String? = nil,
        highlight: Bool? = nil,
        passagesFields: String? = nil,
        passagesCount: Int? = nil,
        passagesCharacters: Int? = nil,
        deduplicate: Bool? = nil,
        deduplicateField: String? = nil,
        collectionIDs: String? = nil,
        similar: Bool? = nil,
        similarDocumentIDs: String? = nil,
        similarFields: String? = nil,
        bias: String? = nil
    )
    {
        self.filter = filter
        self.query = query
        self.naturalLanguageQuery = naturalLanguageQuery
        self.passages = passages
        self.aggregation = aggregation
        self.count = count
        self.returnFields = returnFields
        self.offset = offset
        self.sort = sort
        self.highlight = highlight
        self.passagesFields = passagesFields
        self.passagesCount = passagesCount
        self.passagesCharacters = passagesCharacters
        self.deduplicate = deduplicate
        self.deduplicateField = deduplicateField
        self.collectionIDs = collectionIDs
        self.similar = similar
        self.similarDocumentIDs = similarDocumentIDs
        self.similarFields = similarFields
        self.bias = bias
    }

}
