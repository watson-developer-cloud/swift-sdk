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
 The AlchemyLanguage API utilizes sophisticated natural language processing techniques to provide
 high-level semantic information about your content.
 */

public class AlchemyLanguage {

    /// The base URL to use when contacting the service.
    public var serviceUrl = "https://gateway-a.watsonplatform.net/calls"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    /// The API key credential to use when authenticating with the service.
    private let apiKey: String

    private let errorDomain = "com.watsonplatform.alchemyLanguage"

    // The characters at the end of the CharacterSet break in Linux
    private let unreservedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-._~")
    /**
     Create an `AlchemyLanguage` object.

     - parameter apiKey: The API key credential to use when authenticating with the service.
     */
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    /**
     If the response or data represents an error returned by the AlchemyLanguage service,
     then return NSError with information about the error that occured. Otherwise, return nil.

     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {

        // Typically, we would check the http status code in the response object here, and return
        // `nil` if the status code is successful (200 <= statusCode < 300). However, the Alchemy
        // services return a status code of 200 if you are able to successfully contact the
        // service, without regards to whether the response itself was a success or a failure.

        // First check http status code in response
        // If statusCode indicates an error, return nil so that RestKit uses its default error
        if let response = response {
            if !(200..<300).contains(response.statusCode) {
                return nil
            }
        }

        // ensure data is not nil
        guard let data = data else {
            if let code = response?.statusCode {
                return NSError(domain: errorDomain, code: code, userInfo: nil)
            }
            return nil  // RestKit will generate error for this case
        }

        do {
            let json = try JSONWrapper(data: data)
            let code = 400
            let status = try json.getString(at: "status")
            let statusInfo = try json.getString(at: "statusInfo")
            let userInfo = [
                NSLocalizedDescriptionKey: status,
                NSLocalizedRecoverySuggestionErrorKey: statusInfo
            ]
            return NSError(domain: errorDomain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    private func buildBody(document:  URL, html: Bool) throws -> Data {

        guard let docAsString = try String(contentsOfFile: document.relativePath, encoding:.utf8)
            .addingPercentEncoding(withAllowedCharacters: unreservedCharacters) else {
                let failureReason = "Profile could not be escaped."
                let userInfo = [NSLocalizedDescriptionKey: failureReason]
                let error = NSError(domain: errorDomain, code: 0, userInfo: userInfo)
                throw error
        }

        let type: String
        if html == true {
            type = "html"
        } else {
            type = "text"
        }
        guard let body = "\(type)=\(docAsString)".data(using: String.Encoding.utf8) else {
            let failureReason = "Profile could not be encoded."
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: errorDomain, code: 0, userInfo: userInfo)
            throw error
        }
        return body
    }

    /**
     Extracts the Author(s) of given content.

     - parameter url:     the URL of the content
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Author information
     */
    public func getAuthors(
        fromContentAtURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentAuthors) -> Void)
    {

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetAuthors",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]

        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentAuthors>) in
            switch response.result {
            case .success(let authors): success(authors)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Author(s) of given content.

     - parameter html:    an HTML document
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Author information
     */
    public func getAuthors(
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentAuthors) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetAuthors",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentAuthors>) in
            switch response.result {
            case .success(let authors): success(authors)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Concepts of given content.

     - parameter url:            the URL of the content
     - parameter knowledgeGraph: whether to include a knowledgeGraph calculation
     - parameter failure:        a function executed if the call fails
     - parameter success:        a function executed with Concept information
     */
    public func getRankedConcepts(
        fromContentAtURL url: String,
        knowledgeGraph: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ConceptResponse) -> Void)
    {

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "linkedData", value: "1"))
        queryParams.append(URLQueryItem(name: "url", value: url))
        if let myGraph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph",
                                            value: String(myGraph.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetRankedConcepts",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<ConceptResponse>) in
            switch response.result {
            case .success(let concepts): success(concepts)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the concepts of given content.

     - parameter html:           an HTML document
     - parameter url:            a reference to where the HTML is located
     - parameter knowledgeGraph: whether to include a knowledgeGraph calculation
     - parameter failure:        a function executed if the call fails
     - parameter success:        a function executed with Concept information
     */
    public func getRankedConcepts(
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        knowledgeGraph: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ConceptResponse) -> Void)
    {

        // construct body
        let body = try? buildBody(document: html, html: true)
        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "linkedData", value: "1"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        if let myGraph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph",
                                            value: String(myGraph.rawValue)))
        }
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetRankedConcepts",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )
        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<ConceptResponse>) in
            switch response.result {
            case .success(let concepts): success(concepts)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the concepts of given content.

     - parameter text:           a Text document
     - parameter knowledgeGraph: whether to include a knowledgeGraph calculation
     - parameter failure:        a function executed if the call fails
     - parameter success:        a function executed with Concept information
     */
    public func getRankedConcepts(
        fromTextFile text: URL,
        knowledgeGraph: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ConceptResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "linkedData", value: "1"))
        if let myGraph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph",
                                            value: String(myGraph.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/text/TextGetRankedConcepts",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<ConceptResponse>) in
            switch response.result {
            case .success(let concepts): success(concepts)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Entities of given content.

     - parameter url:                  the URL of the content
     - parameter knowledgeGraph:       whether to include a knowledgeGraph calculation
     - parameter disambiguateEntities: whether to include disambiguate entities
     - parameter linkedData:           whether to include linked data
     - parameter coreference:          whether to include coreferences
     - parameter sentiment:            whether to include sentiment analysis
     - parameter quotations:           whether to inlcude quotations
     - parameter structuredEntities:   whether to include structured entities
     - parameter failure:              a function executed if the call fails
     - parameter success:              a function executed with Entity information
     */
    public func getRankedNamedEntities(
        fromContentAtURL url: String,
        knowledgeGraph: QueryParam? = nil,
        disambiguateEntities: QueryParam? = nil,
        linkedData: QueryParam? = nil,
        coreference: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        quotations: QueryParam? = nil,
        structuredEntities: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Entities) -> Void)
    {
        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "url", value: url))
        if let myGraph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph",
                                            value:String(myGraph.rawValue)))
        }
        if let disambiguate = disambiguateEntities {
            queryParams.append(URLQueryItem(name: "disambiguatedEntities",
                                            value: String(disambiguate.rawValue)))
        }
        if let linked = linkedData {
            queryParams.append(URLQueryItem(name: "linkedData", value: String(linked.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(URLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let quotes = quotations {
            queryParams.append(URLQueryItem(name: "quotations", value: String(quotes.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(URLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let structEnts = structuredEntities {
            queryParams.append(URLQueryItem(name: "structuredEntities",
                                            value: String(structEnts.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetRankedNamedEntities",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Entities>) in
            switch response.result {
            case .success(let entities): success(entities)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Entities of given content.

     - parameter html:                 a HTML document
     - parameter url:                  a reference to where the HTML is located
     - parameter knowledgeGraph:       whether to include a knowledgeGraph calculation
     - parameter disambiguateEntities: whether to include disambiguate entities
     - parameter linkedData:           whether to include linked data
     - parameter coreference:          whether to include coreferences
     - parameter sentiment:            whether to include sentiment analysis
     - parameter quotations:           whether to inlcude quotations
     - parameter structuredEntities:   whether to include structured entities
     - parameter failure:              a function executed if the call fails
     - parameter success:              a function executed with Entity information
     */
    public func getRankedNamedEntities(
        fromHTMLFile html: URL,
        withURL url: String?,
        knowledgeGraph: QueryParam? = nil,
        disambiguateEntities: QueryParam? = nil,
        linkedData: QueryParam? = nil,
        coreference: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        quotations: QueryParam? = nil,
        structuredEntities: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Entities) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        if let myGraph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph",
                                            value:String(myGraph.rawValue)))
        }
        if let disambiguate = disambiguateEntities {
            queryParams.append(URLQueryItem(name: "disambiguatedEntities",
                                            value: String(disambiguate.rawValue)))
        }
        if let linked = linkedData {
            queryParams.append(URLQueryItem(name: "linkedData", value: String(linked.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(URLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let quotes = quotations {
            queryParams.append(URLQueryItem(name: "quotations", value: String(quotes.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(URLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let structEnts = structuredEntities {
            queryParams.append(URLQueryItem(name: "structuredEntities",
                                            value: String(structEnts.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetRankedNamedEntities",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Entities>) in
            switch response.result {
            case .success(let entities): success(entities)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Entities of given content.

     - parameter text:                 a Text document
     - parameter knowledgeGraph:       whether to include a knowledgeGraph calculation
     - parameter disambiguateEntities: whether to include disambiguate entities
     - parameter linkedData:           whether to include linked data
     - parameter coreference:          whether to include coreferences
     - parameter sentiment:            whether to include sentiment analysis
     - parameter quotations:           whether to inlcude quotations
     - parameter structuredEntities:   whether to include structured entities
     - parameter failure:              a function executed if the call fails
     - parameter success:              a function executed with Entity information
     */
    public func getRankedNamedEntities(
        fromTextFile text: URL,
        knowledgeGraph: QueryParam? = nil,
        disambiguateEntities: QueryParam? = nil,
        linkedData: QueryParam? = nil,
        coreference: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        quotations: QueryParam? = nil,
        structuredEntities: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Entities) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myGraph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph",
                                            value: String(myGraph.rawValue)))
        }
        if let disambiguate = disambiguateEntities {
            queryParams.append(URLQueryItem(name: "disambiguatedEntities",
                                            value: String(disambiguate.rawValue)))
        }
        if let linked = linkedData {
            queryParams.append(URLQueryItem(name: "linkedData", value: String(linked.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(URLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let quotes = quotations {
            queryParams.append(URLQueryItem(name: "quotations", value: String(quotes.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(URLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let structEnts = structuredEntities {
            queryParams.append(URLQueryItem(name: "structuredEntities",
                                            value: String(structEnts.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/text/TextGetRankedNamedEntities",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Entities>) in
            switch response.result {
            case .success(let entities): success(entities)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Keywords of given content.

     - parameter url:            the URL of the content
     - parameter knowledgeGraph: whether to include a knowledgeGraph calculation
     - parameter strictMode:     whether to run in strict mode
     - parameter sentiment:      whether to include sentiment analysis
     - parameter failure:        a function executed if the call fails
     - parameter success:        a function executed with Keyword information
     */
    public func getRankedKeywords(
        fromContentAtURL url: String,
        knowledgeGraph: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        strictMode: Bool? = false,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Keywords) -> Void)
    {
        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "url", value: url))
        if let graph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(URLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keywordExtractMode = strictMode {
            let mode: String
            if keywordExtractMode == true {
                mode = "strict"
            } else {
                mode = "normal"
            }
            queryParams.append(URLQueryItem(name: "keywordExtractMode", value: mode))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetRankedKeywords",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Keywords>) in
            switch response.result {
            case .success(let keywords): success(keywords)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Keywords of given content.

     - parameter html:           a HTML document
     - parameter url:            a reference to where the HTML is located
     - parameter knowledgeGraph: whether to include a knowledgeGraph calculation
     - parameter strictMode:     whether to run in strict mode
     - parameter sentiment:      whether to include sentiment analysis
     - parameter failure:        a function executed if the call fails
     - parameter success:        a function executed with Keyword information
     */
    public func getRankedKeywords(
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        knowledgeGraph: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        strictMode: Bool? = false,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Keywords) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        if let graph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(URLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keywordExtractMode = strictMode {
            let mode: String
            if keywordExtractMode == true {
                mode = "strict"
            } else {
                mode = "normal"
            }
            queryParams.append(URLQueryItem(name: "keywordExtractMode", value: mode))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetRankedKeywords",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Keywords>) in
            switch response.result {
            case .success(let keywords): success(keywords)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Keywords of given content.

     - parameter text:           a Text document
     - parameter knowledgeGraph: whether to include a knowledgeGraph calculation
     - parameter strictMode:     whether to run in strict mode
     - parameter sentiment:      whether to include sentiment analysis
     - parameter failure:        a function executed if the call fails
     - parameter success:        a function executed with Keyword information
     */
    public func getRankedKeywords(
        fromTextFile text: URL,
        knowledgeGraph: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        strictMode: Bool? = false,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Keywords) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let graph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(URLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keywordExtractMode = strictMode {
            let mode: String
            if keywordExtractMode == true {
                mode = "strict"
            } else {
                mode = "normal"
            }
            queryParams.append(URLQueryItem(name: "keywordExtractMode", value: mode))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/text/TextGetRankedKeywords",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Keywords>) in
            switch response.result {
            case .success(let keywords): success(keywords)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the language of given content.

     - parameter url:     the URL of the content
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Language information
     */
    public func getLanguage(
        fromContentAtURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Language) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetLanguage",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Language>) in
            switch response.result {
            case .success(let language): success(language)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the language of given content.

     - parameter text:    a Text document
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Language information
     */
    public func getLanguage(
        fromTextFile text: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Language) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/text/TextGetLanguage",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Language>) in
            switch response.result {
            case .success(let language): success(language)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Microformat Data of given content.

     - parameter url:     the URL of the content
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Microformat information
     */
    public func getMicroformatData(
        fromContentAtURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Microformats) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetMicroformatData",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Microformats>) in
            switch response.result {
            case .success(let microformats): success(microformats)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Microformat Data of given content.
     The fact URL is required here is a bug.

     - parameter html:    a HTML document
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Microformat information
     */
    public func getMicroformatData(
        fromHTMLFile html: URL,
        withURL url: String? = " ",
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Microformats) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetMicroformatData",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Microformats>) in
            switch response.result {
            case .success(let microformats): success(microformats)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Publication Date of given content.

     - parameter url:     the URL of the content
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Publication information
     */
    public func getPubDate(
        fromContentAtURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (PublicationResponse) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetPubDate",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<PublicationResponse>) in
            switch response.result {
            case .success(let pubResponse): success(pubResponse)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Publication Date of given content.

     - parameter html:    a HTML document
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Publication information
     */
    public func getPubDate(
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (PublicationResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetPubDate",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<PublicationResponse>) in
            switch response.result {
            case .success(let pubResponse): success(pubResponse)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Subject-Action-Object relations of given content.

     - parameter url:                      the URL of the content
     - parameter knowledgeGraph:           whether to include a knowledgeGraph calculation
     - parameter disambiguateEntities:     whether to include disambiguate entities
     - parameter linkedData:               whether to include linked data
     - parameter coreference:              whether to include coreferences
     - parameter sentiment:                whether to include sentiment analysis
     - parameter keywords:                 whether to include keyword extraction
     - parameter entities:                 whether to include entity extraction
     - parameter requireEntities:          whether to incldue relations that contain at least one
     named entity
     - parameter sentimentExcludeEntities: whether to include relation info in sentiment analysis
     - parameter failure:                  a function executed if the call fails
     - parameter success:                  a function executed with Relationship information
     */
    public func getRelations(
        fromContentAtURL url: String,
        knowledgeGraph: QueryParam? = nil,
        disambiguateEntities: QueryParam? = nil,
        linkedData: QueryParam? = nil,
        coreference: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        keywords: QueryParam? = nil,
        entities: QueryParam? = nil,
        requireEntities: QueryParam? = nil,
        sentimentExcludeEntities: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SAORelations) -> Void)
    {
        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "url", value: url))
        if let graph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let disEnts = disambiguateEntities {
            queryParams.append(URLQueryItem(name: "disambiguate", value: String(disEnts.rawValue)))
        }
        if let link = linkedData {
            queryParams.append(URLQueryItem(name: "linkedData", value: String(link.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(URLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(URLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keyWords = keywords {
            queryParams.append(URLQueryItem(name: "keywords", value: String(keyWords.rawValue)))
        }
        if let ents = entities {
            queryParams.append(URLQueryItem(name: "entities", value: String(ents.rawValue)))
        }
        if let reqEnts = requireEntities {
            queryParams.append(URLQueryItem(name: "requireEntities",
                                            value: String(reqEnts.rawValue)))
        }
        if let sentiExEnts = sentimentExcludeEntities {
            queryParams.append(URLQueryItem(name: "sentimentExcludeEntities",
                                            value: String(sentiExEnts.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetRelations",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SAORelations>) in
            switch response.result {
            case .success(let relations): success(relations)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Subject-Action-Object relations of given content.

     - parameter html:                     a HTML document
     - parameter url:                      a reference to where the HTML is located
     - parameter knowledgeGraph:           whether to include a knowledgeGraph calculation
     - parameter disambiguateEntities:     whether to include disambiguate entities
     - parameter linkedData:               whether to include linked data
     - parameter coreference:              whether to include coreferences
     - parameter sentiment:                whether to include sentiment analysis
     - parameter keywords:                 whether to include keyword extraction
     - parameter entities:                 whether to include entity extraction
     - parameter requireEntities:          whether to incldue relations that contain at least one
     named entity
     - parameter sentimentExcludeEntities: whether to include relation info in sentiment analysis
     - parameter failure:                  a function executed if the call fails
     - parameter success:                  a function executed with Relationship information
     */
    public func getRelations(
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        knowledgeGraph: QueryParam? = nil,
        disambiguateEntities: QueryParam? = nil,
        linkedData: QueryParam? = nil,
        coreference: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        keywords: QueryParam? = nil,
        entities: QueryParam? = nil,
        requireEntities: QueryParam? = nil,
        sentimentExcludeEntities: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SAORelations) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        if let graph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let disEnts = disambiguateEntities {
            queryParams.append(URLQueryItem(name: "disambiguate", value: String(disEnts.rawValue)))
        }
        if let link = linkedData {
            queryParams.append(URLQueryItem(name: "linkedData", value: String(link.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(URLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(URLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keyWords = keywords {
            queryParams.append(URLQueryItem(name: "keywords", value: String(keyWords.rawValue)))
        }
        if let ents = entities {
            queryParams.append(URLQueryItem(name: "entities", value: String(ents.rawValue)))
        }
        if let reqEnts = requireEntities {
            queryParams.append(URLQueryItem(name: "requireEntities",
                                            value: String(reqEnts.rawValue)))
        }
        if let sentiExEnts = sentimentExcludeEntities {
            queryParams.append(URLQueryItem(name: "sentimentExcludeEntities",
                                            value: String(sentiExEnts.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetRelations",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SAORelations>) in
            switch response.result {
            case .success(let relations): success(relations)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Subject-Action-Object relations of given content.

     - parameter text:                     a Text document
     - parameter knowledgeGraph:           whether to include a knowledgeGraph calculation
     - parameter disambiguateEntities:     whether to include disambiguate entities
     - parameter linkedData:               whether to include linked data
     - parameter coreference:              whether to include coreferences
     - parameter sentiment:                whether to include sentiment analysis
     - parameter keywords:                 whether to include keyword extraction
     - parameter entities:                 whether to include entity extraction
     - parameter requireEntities:          whether to incldue relations that contain at least one
     named entity
     - parameter sentimentExcludeEntities: whether to include relation info in sentiment analysis
     - parameter failure:                  a function executed if the call fails
     - parameter success:                  a function executed with Relationship information
     */
    public func getRelations(
        fromTextFile text: URL,
        knowledgeGraph: QueryParam? = nil,
        disambiguateEntities: QueryParam? = nil,
        linkedData: QueryParam? = nil,
        coreference: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        keywords: QueryParam? = nil,
        entities: QueryParam? = nil,
        requireEntities: QueryParam? = nil,
        sentimentExcludeEntities: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SAORelations) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let graph = knowledgeGraph {
            queryParams.append(URLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let disEnts = disambiguateEntities {
            queryParams.append(URLQueryItem(name: "disambiguate", value: String(disEnts.rawValue)))
        }
        if let link = linkedData {
            queryParams.append(URLQueryItem(name: "linkedData", value: String(link.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(URLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(URLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keyWords = keywords {
            queryParams.append(URLQueryItem(name: "keywords", value: String(keyWords.rawValue)))
        }
        if let ents = entities {
            queryParams.append(URLQueryItem(name: "entities", value: String(ents.rawValue)))
        }
        if let reqEnts = requireEntities {
            queryParams.append(URLQueryItem(name: "requireEntities",
                                            value: String(reqEnts.rawValue)))
        }
        if let sentiExEnts = sentimentExcludeEntities {
            queryParams.append(URLQueryItem(name: "sentimentExcludeEntities",
                                            value: String(sentiExEnts.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/text/TextGetRelations",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SAORelations>) in
            switch response.result {
            case .success(let relations): success(relations)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Sentiment of given content.

     - parameter url:     the URL of the content
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Sentiment information
     */
    public func getTextSentiment(
        fromContentAtURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetTextSentiment",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SentimentResponse>) in
            switch response.result {
            case .success(let sentimentResponse): success(sentimentResponse)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Sentiment of given content.

     - parameter html:    a HTML document
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Sentiment information
     */
    public func getTextSentiment(
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetTextSentiment",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SentimentResponse>) in
            switch response.result {
            case .success(let sentimentResponse): success(sentimentResponse)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Sentiment of given content.

     - parameter text:    a Text document
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Sentiment information
     */
    public func getTextSentiment(
        fromTextFile text: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/text/TextGetTextSentiment",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SentimentResponse>) in
            switch response.result {
            case .success(let sentimentResponse): success(sentimentResponse)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Sentiment of given content.

     - parameter url:     the URL of the content
     - parameter targets:  a pipe delimited list of phrases to target analysis towards
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Sentiment information
     */
    public func getTargetedSentiment(
        fromContentAtURL url: String,
        withTargets targets: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetTargetedSentiment",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: [
                URLQueryItem(name: "target", value: targets),
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SentimentResponse>) in
            switch response.result {
            case .success(let sentimentResponse): success(sentimentResponse)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Sentiment of given content.

     - parameter html:    a HTML document
     - parameter targets:  a pipe delimited list of phrases to target analysis towards
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Sentiment information
     */
    public func getTargetedSentiment(
        fromHTMLFile html: URL,
        withTargets targets: String,
        url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "target", value: targets))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetTargetedSentiment",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SentimentResponse>) in
            switch response.result {
            case .success(let sentimentResponse): success(sentimentResponse)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Sentiment of given content.

     - parameter text:    a Text document
     - parameter targets:  a pipe delimited list of phrases to target analysis towards
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Sentiment information
     */
    public func getTargetedSentiment(
        fromTextFile text: URL,
        withTargets targets: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "target", value: targets))

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/text/TextGetTargetedSentiment",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SentimentResponse>) in
            switch response.result {
            case .success(let sentimentResponse): success(sentimentResponse)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Taxonomy of given content.

     - parameter url:     the URL of the content
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Taxonomy information
     */
    public func getRankedTaxonomy(
        fromContentAtURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Taxonomies) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetRankedTaxonomy",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Taxonomies>) in
            switch response.result {
            case .success(let taxonomies): success(taxonomies)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Taxonomy of given content.

     - parameter html:    a HTML document
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Taxonomy information
     */
    public func getRankedTaxonomy(
        fromHTMLFile html: URL,
        atURL url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Taxonomies) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetRankedTaxonomy",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Taxonomies>) in
            switch response.result {
            case .success(let taxonomies): success(taxonomies)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Calculates the Taxonomy of given content.

     - parameter text:    a Text document
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Taxonomy information
     */
    public func getRankedTaxonomy(
        fromTextFile text: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Taxonomies) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/text/TextGetRankedTaxonomy",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Taxonomies>) in
            switch response.result {
            case .success(let taxonomies): success(taxonomies)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Raw Text of given content.

     - parameter url:     the URL of the content
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Raw Text information
     */
    public func getRawText(
        fromContentAtURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentText) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetRawText",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentText>) in
            switch response.result {
            case .success(let docText): success(docText)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Raw Text of given content.

     - parameter html:    a HTML document
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Raw Text information
     */
    public func getRawText(
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentText) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetRawText",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentText>) in
            switch response.result {
            case .success(let docText): success(docText)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Text of given content.

     - parameter url:          the URL of the content
     - parameter useMetadata:  whether to use metadata embeded in the webpage
     - parameter extractLinks: whether to include hyperlinks in the extracted text
     - parameter failure:      a function executed if the call fails
     - parameter success:      a function executed with Text information
     */
    public func getText(
        fromContentAtURL url: String,
        useMetadata: QueryParam? = nil,
        extractLinks: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentText) -> Void)
    {
        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "url", value: url))
        if let metadata = useMetadata {
            queryParams.append(URLQueryItem(name: "useMetadata", value: String(metadata.rawValue)))
        }
        if let extract = extractLinks {
            queryParams.append(URLQueryItem(name: "extractLinks", value: String(extract.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetText",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentText>) in
            switch response.result {
            case .success(let docText): success(docText)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Text of given content.

     - parameter html:         a HTML document
     - parameter url:          a reference to where the HTML is located
     - parameter useMetadata:  whether to use metadata embeded in the webpage
     - parameter extractLinks: whether to include hyperlinks in the extracted text
     - parameter failure:      a function executed if the call fails
     - parameter success:      a function executed with Text information
     */
    public func getText(
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        useMetadata: QueryParam? = nil,
        extractLinks: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentText) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        if let metadata = useMetadata {
            queryParams.append(URLQueryItem(name: "useMetadata", value: String(metadata.rawValue)))
        }
        if let extract = extractLinks {
            queryParams.append(URLQueryItem(name: "extractLinks", value: String(extract.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetText",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentText>) in
            switch response.result {
            case .success(let docText): success(docText)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Title of given content.

     - parameter url:          the URL of the content
     - parameter failure:      a function executed if the call fails
     - parameter success:      a function executed with Title information
     */
    public func getTitle(
        fromContentAtURL url: String,
        useMetadata: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentTitle) -> Void)
    {
        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "url", value: url))
        if let metadata = useMetadata {
            queryParams.append(URLQueryItem(name: "useMetadata", value: String(metadata.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetTitle",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentTitle>) in
            switch response.result {
            case .success(let docTitle): success(docTitle)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Title of given content.

     - parameter html:    a HTML document
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Title information
     */
    public func getTitle(
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        useMetadata: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentTitle) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        if let metadata = useMetadata {
            queryParams.append(URLQueryItem(name: "useMetadata", value: String(metadata.rawValue)))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetTitle",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentTitle>) in
            switch response.result {
            case .success(let docTitle): success(docTitle)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Feeds of given content.

     - parameter url:          the URL of the content
     - parameter failure:      a function executed if the call fails
     - parameter success:      a function executed with Feed information
     */
    public func getFeedLinks(
        fromContentAtURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Feeds) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetFeedLinks",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Feeds>) in
            switch response.result {
            case .success(let feeds): success(feeds)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Feeds of given content.
     The fact that URL is required here is a bug.

     - parameter html:    a HTML document
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Feeds information
     */
    public func getFeedLinks(
        fromHTMLFile html: URL,
        withURL url: String? = " ",
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Feeds) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetFeedLinks",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Feeds>) in
            switch response.result {
            case .success(let feeds): success(feeds)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Emotion of given content.

     - parameter url:          the URL of the content
     - parameter failure:      a function executed if the call fails
     - parameter success:      a function executed with Feed information
     */
    public func getEmotion(
        fromContentAtURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentEmotion) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/url/URLGetEmotion",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentEmotion>) in
            switch response.result {
            case .success(let emotion): success(emotion)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Emotion of given content.

     - parameter html:    a HTML document
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Feed information
     */
    public func getEmotion(
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentEmotion) -> Void)
    {

        // construct body
        let body = try? buildBody(document: html, html: true)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/html/HTMLGetEmotion",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentEmotion>) in
            switch response.result {
            case .success(let emotion): success(emotion)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extracts the Emotion of given content.

     - parameter text:    a Text document
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Feed information
     */
    public func getEmotion(
        fromTextFile text: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentEmotion) -> Void)
    {

        // construct body
        let body = try? buildBody(document: text, html: false)

        // construct query parameters
        var queryParams = [URLQueryItem]()

        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))

        // construct request
        let request = RestRequest(
            method: "POST",
            url: serviceUrl + "/text/TextGetEmotion",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParams,
            messageBody: body
        )

        // execute request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<DocumentEmotion>) in
            switch response.result {
            case .success(let emotion): success(emotion)
            case .failure(let error): failure?(error)
            }
        }
    }
}
