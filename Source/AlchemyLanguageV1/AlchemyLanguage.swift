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
import Alamofire
import Freddy
import RestKit

/**
 The AlchemyLanguage API utilizes sophisticated natural language processing techniques to provide 
 high-level semantic information about your content.
 */

public class AlchemyLanguage {
    
    /// The base URL to use when contacting the service.
    public var serviceUrl = "https://gateway-a.watsonplatform.net/calls"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let apiKey: String
    private let errorDomain = "com.watsonplatform.alchemyLanguage"
 
    private let unreservedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz" +
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
        "1234567890-._~")
    
    /**
     Create an `AlchemyLanguage` object.
     
     - parameter apiKey: The API key credential to use when authenticating with the service.
     */
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private func buildBody(document:  URL, html: Bool) throws -> Data {
        guard let docAsString = try? String(contentsOf: document)
            .addingPercentEncoding(withAllowedCharacters: unreservedCharacters) else {
                let failureReason = "Profile could not be escaped."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: errorDomain, code: 0, userInfo: userInfo)
                throw error
        }
        let type: String
        if html == true {
            type = "html"
        } else {
            type = "text"
        }
        guard let body = "\(type)=\(docAsString!)".data(using: String.Encoding.utf8) else {
            let failureReason = "Profile could not be encoded."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
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
        forURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentAuthors) -> Void)
    {
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetAuthors",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryParameters: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
            
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentAuthors>) in
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
        forHtml html: URL,
        url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentAuthors) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/html/HTMLGetAuthors",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentAuthors>) in
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
        forURL url: String,
        knowledgeGraph: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ConceptResponse) -> Void)
    {
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/url/URLGetRankedConcepts",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<ConceptResponse>) in
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
        forHtml html: URL,
        url: String? = nil,
        knowledgeGraph: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ConceptResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/html/HTMLGetRankedConcepts",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<ConceptResponse>) in
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
        forText text: URL,
        knowledgeGraph: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ConceptResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/text/TextGetRankedConcepts",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<ConceptResponse>) in
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
        forURL url: String,
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
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/url/URLGetRankedNamedEntities",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Entities>) in
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
        forHtml html: URL,
        url: String?,
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
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/html/HTMLGetRankedNamedEntities",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Entities>) in
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
        forText text: URL,
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
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/text/TextGetRankedNamedEntities",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Entities>) in
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
        forURL url: String,
        knowledgeGraph: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        strictMode: Bool? = false,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Keywords) -> Void)
    {
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/url/URLGetRankedKeywords",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Keywords>) in
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
        forHtml html: URL,
        url: String? = nil,
        knowledgeGraph: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        strictMode: Bool? = false,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Keywords) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/html/HTMLGetRankedKeywords",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Keywords>) in
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
        forText text: URL,
        knowledgeGraph: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        strictMode: Bool? = false,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Keywords) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/text/TextGetRankedKeywords",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Keywords>) in
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
        forURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Language) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetLanguage",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryParameters: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Language>) in
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
        forText text: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Language) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/text/TextGetLanguage",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Language>) in
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
        forURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Microformats) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetMicroformatData",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryParameters: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Microformats>) in
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
        forHtml html: URL,
        url: String? = " ",
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Microformats) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/html/HTMLGetMicroformatData",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Microformats>) in
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
        forURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (PublicationResponse) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetPubDate",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryParameters: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<PublicationResponse>) in
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
        forHtml html: URL,
        url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (PublicationResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/html/HTMLGetPubDate",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<PublicationResponse>) in
                switch response.result {
                case .success(let pubResponse): success(pubResponse)
                case .failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Extracts the Subject-Action-Object relations of given content.
     
     - parameter url:                      the URL of the content
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
        forURL url: String,
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
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/url/URLGetRelations",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<SAORelations>) in
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
        forHtml html: URL,
        url: String? = nil,
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
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/html/HTMLGetRelations",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<SAORelations>) in
                switch response.result {
                case .success(let relations): success(relations)
                case .failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Extracts the Subject-Action-Object relations of given content.
     
     - parameter text:                     a Text document
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
        forText text: URL,
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
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/text/TextGetRelations",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<SAORelations>) in
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
        forURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetTextSentiment",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryParameters: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<SentimentResponse>) in
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
        forHtml html: URL,
        url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/html/HTMLGetTextSentiment",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<SentimentResponse>) in
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
        forText text: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/text/TextGetTextSentiment",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<SentimentResponse>) in
                switch response.result {
                case .success(let sentimentResponse): success(sentimentResponse)
                case .failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Calculates the Sentiment of given content.
     
     - parameter target:  a pharse to target analysis towards
     - parameter url:     the URL of the content
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Sentiment information
     */
    public func getTargetedSentiment(
        forURL url: String,
        target: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetTargetedSentiment",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: [
                URLQueryItem(name: "target", value: target),
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<SentimentResponse>) in
                switch response.result {
                case .success(let sentimentResponse): success(sentimentResponse)
                case .failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Calculates the Sentiment of given content.
     
     - parameter html:    a HTML document
     - parameter target:  a pharse to target analysis towards
     - parameter url:     a reference to where the HTML is located
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Sentiment information
     */
    public func getTargetedSentiment(
        forHtml html: URL,
        target: String,
        url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "target", value: target))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/html/HTMLGetTargetedSentiment",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<SentimentResponse>) in
                switch response.result {
                case .success(let sentimentResponse): success(sentimentResponse)
                case .failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Calculates the Sentiment of given content.
     
     - parameter text:    a Text document
     - parameter target:  a pharse to target analysis towards
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with Sentiment information
     */
    public func getTargetedSentiment(
        forText text: URL,
        target: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SentimentResponse) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "target", value: target))
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/text/TextGetTargetedSentiment",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<SentimentResponse>) in
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
        forURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Taxonomies) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetRankedTaxonomy",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Taxonomies>) in
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
        forHtml html: URL,
        url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Taxonomies) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/html/HTMLGetRankedTaxonomy",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Taxonomies>) in
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
        forText text: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Taxonomies) -> Void)
    {
        // construct body
        let body = try? buildBody(document: text, html: false)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/text/TextGetRankedTaxonomy",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Taxonomies>) in
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
        forURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentText) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetRawText",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentText>) in
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
        forHtml html: URL,
        url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentText) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/html/HTMLGetRawText",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentText>) in
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
        forURL url: String,
        useMetadata: QueryParam? = nil,
        extractLinks: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentText) -> Void)
    {
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/url/URLGetText",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentText>) in
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
        forHtml html: URL,
        url: String? = nil,
        useMetadata: QueryParam? = nil,
        extractLinks: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentText) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/html/HTMLGetText",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentText>) in
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
        forURL url: String,
        useMetadata: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentTitle) -> Void)
    {
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(URLQueryItem(name: "url", value: url))
        if let metadata = useMetadata {
            queryParams.append(URLQueryItem(name: "useMetadata", value: String(metadata.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetTitle",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentTitle>) in
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
        forHtml html: URL,
        url: String? = nil,
        useMetadata: QueryParam? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentTitle) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
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
            method: .post,
            url: serviceUrl + "/html/HTMLGetTitle",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentTitle>) in
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
        forURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Feeds) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetFeedLinks",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Feeds>) in
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
        forHtml html: URL,
        url: String? = " ",
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Feeds) -> Void)
    {
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/html/HTMLGetFeedLinks",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Feeds>) in
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
        forURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentEmotion) -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/url/URLGetEmotion",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: [
                URLQueryItem(name: "url", value: url),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentEmotion>) in
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
        forHtml html: URL,
        url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentEmotion) -> Void)
    {
        
        // construct body
        let body = try? buildBody(document: html, html: true)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(URLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/html/HTMLGetEmotion",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentEmotion>) in
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
        forText text: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DocumentEmotion) -> Void)
    {
        
        // construct body
        let body = try? buildBody(document: text, html: false)
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        
        // construct request
        let request = RestRequest(
            method: .post,
            url: serviceUrl + "/text/TextGetEmotion",
            headerParameters: defaultHeaders,
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<DocumentEmotion>) in
                switch response.result {
                case .success(let emotion): success(emotion)
                case .failure(let error): failure?(error)
                }
        }
    }
}
