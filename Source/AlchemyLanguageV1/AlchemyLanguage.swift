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
    
    private let apiKey: String
    
    private let serviceUrl = "https://gateway-a.watsonplatform.net/calls"
    private let errorDomain = "com.watsonplatform.alchemyLanguage"
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.8.0 AlchemyLanguageV1")
 
    private let unreservedCharacters = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyz" +
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
        "1234567890-._~")
    
    /**
     Initilizes the AlchemyLanguage service
     */
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let status = try json.string("status")
            let statusInfo = try json.string("statusInfo")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: status,
                NSLocalizedDescriptionKey: statusInfo
            ]
            return NSError(domain: errorDomain, code: 400, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    private func buildBody(document: NSURL, html: Bool) throws -> NSData {
        guard let docAsString = try? String(contentsOfURL: document)
            .stringByAddingPercentEncodingWithAllowedCharacters(unreservedCharacters) else {
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
        guard let body = "\(type)=\(docAsString!)".dataUsingEncoding(NSUTF8StringEncoding) else {
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
        failure: (NSError -> Void)? = nil,
        success: DocumentAuthors -> Void)
    {
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetAuthors",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: [
                NSURLQueryItem(name: "url", value: url),
                NSURLQueryItem(name: "apikey", value: apiKey),
                NSURLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentAuthors, NSError>) in
                switch response.result {
                case .Success(let authors): success(authors)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: DocumentAuthors -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetAuthors",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentAuthors, NSError>) in
                switch response.result {
                case .Success(let authors): success(authors)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: ConceptResponse -> Void)
    {
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(NSURLQueryItem(name: "linkedData", value: "1"))
        queryParams.append(NSURLQueryItem(name: "url", value: url))
        if let myGraph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph",
                value: String(myGraph.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetRankedConcepts",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<ConceptResponse, NSError>) in
                switch response.result {
                case .Success(let concepts): success(concepts)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = nil,
        knowledgeGraph: QueryParam? = nil,
        failure: (NSError -> Void)? = nil,
        success: ConceptResponse -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(NSURLQueryItem(name: "linkedData", value: "1"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        if let myGraph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph",
                value: String(myGraph.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetRankedConcepts",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<ConceptResponse, NSError>) in
                switch response.result {
                case .Success(let concepts): success(concepts)
                case .Failure(let error): failure?(error)
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
        forText text: NSURL,
        knowledgeGraph: QueryParam? = nil,
        failure: (NSError -> Void)? = nil,
        success: ConceptResponse -> Void)
    {
        // construct body
        let body = try? buildBody(text, html: false)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(NSURLQueryItem(name: "linkedData", value: "1"))
        if let myGraph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph",
                value: String(myGraph.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/text/TextGetRankedConcepts",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<ConceptResponse, NSError>) in
                switch response.result {
                case .Success(let concepts): success(concepts)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: Entities -> Void)
    {
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(NSURLQueryItem(name: "url", value: url))
        if let myGraph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph",
                value:String(myGraph.rawValue)))
        }
        if let disambiguate = disambiguateEntities {
            queryParams.append(NSURLQueryItem(name: "disambiguatedEntities",
                value: String(disambiguate.rawValue)))
        }
        if let linked = linkedData {
            queryParams.append(NSURLQueryItem(name: "linkedData", value: String(linked.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(NSURLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let quotes = quotations {
            queryParams.append(NSURLQueryItem(name: "quotations", value: String(quotes.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(NSURLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let structEnts = structuredEntities {
            queryParams.append(NSURLQueryItem(name: "structuredEntities",
                value: String(structEnts.rawValue)))
        }
        
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetRankedNamedEntities",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Entities, NSError>) in
                switch response.result {
                case .Success(let entities): success(entities)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String?,
        knowledgeGraph: QueryParam? = nil,
        disambiguateEntities: QueryParam? = nil,
        linkedData: QueryParam? = nil,
        coreference: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        quotations: QueryParam? = nil,
        structuredEntities: QueryParam? = nil,
        failure: (NSError -> Void)? = nil,
        success: Entities -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        if let myGraph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph",
                value:String(myGraph.rawValue)))
        }
        if let disambiguate = disambiguateEntities {
            queryParams.append(NSURLQueryItem(name: "disambiguatedEntities",
                value: String(disambiguate.rawValue)))
        }
        if let linked = linkedData {
            queryParams.append(NSURLQueryItem(name: "linkedData", value: String(linked.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(NSURLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let quotes = quotations {
            queryParams.append(NSURLQueryItem(name: "quotations", value: String(quotes.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(NSURLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let structEnts = structuredEntities {
            queryParams.append(NSURLQueryItem(name: "structuredEntities",
                value: String(structEnts.rawValue)))
        }
        
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetRankedNamedEntities",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Entities, NSError>) in
                switch response.result {
                case .Success(let entities): success(entities)
                case .Failure(let error): failure?(error)
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
        forText text: NSURL,
        knowledgeGraph: QueryParam? = nil,
        disambiguateEntities: QueryParam? = nil,
        linkedData: QueryParam? = nil,
        coreference: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        quotations: QueryParam? = nil,
        structuredEntities: QueryParam? = nil,
        failure: (NSError -> Void)? = nil,
        success: Entities -> Void)
    {
        // construct body
        let body = try? buildBody(text, html: false)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myGraph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph",
                value: String(myGraph.rawValue)))
        }
        if let disambiguate = disambiguateEntities {
            queryParams.append(NSURLQueryItem(name: "disambiguatedEntities",
                value: String(disambiguate.rawValue)))
        }
        if let linked = linkedData {
            queryParams.append(NSURLQueryItem(name: "linkedData", value: String(linked.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(NSURLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let quotes = quotations {
            queryParams.append(NSURLQueryItem(name: "quotations", value: String(quotes.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(NSURLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let structEnts = structuredEntities {
            queryParams.append(NSURLQueryItem(name: "structuredEntities",
                value: String(structEnts.rawValue)))
        }
        
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/text/TextGetRankedNamedEntities",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Entities, NSError>) in
                switch response.result {
                case .Success(let entities): success(entities)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: Keywords -> Void)
    {
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(NSURLQueryItem(name: "url", value: url))
        if let graph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(NSURLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keywordExtractMode = strictMode {
            let mode: String
            if keywordExtractMode == true {
                mode = "strict"
            } else {
                mode = "normal"
            }
            queryParams.append(NSURLQueryItem(name: "keywordExtractMode", value: mode))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetRankedKeywords",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Keywords, NSError>) in
                switch response.result {
                case .Success(let keywords): success(keywords)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = nil,
        knowledgeGraph: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        strictMode: Bool? = false,
        failure: (NSError -> Void)? = nil,
        success: Keywords -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        if let graph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(NSURLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keywordExtractMode = strictMode {
            let mode: String
            if keywordExtractMode == true {
                mode = "strict"
            } else {
                mode = "normal"
            }
            queryParams.append(NSURLQueryItem(name: "keywordExtractMode", value: mode))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetRankedKeywords",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Keywords, NSError>) in
                switch response.result {
                case .Success(let keywords): success(keywords)
                case .Failure(let error): failure?(error)
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
        forText text: NSURL,
        knowledgeGraph: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        strictMode: Bool? = false,
        failure: (NSError -> Void)? = nil,
        success: Keywords -> Void)
    {
        // construct body
        let body = try? buildBody(text, html: false)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let graph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(NSURLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keywordExtractMode = strictMode {
            let mode: String
            if keywordExtractMode == true {
                mode = "strict"
            } else {
                mode = "normal"
            }
            queryParams.append(NSURLQueryItem(name: "keywordExtractMode", value: mode))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/text/TextGetRankedKeywords",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Keywords, NSError>) in
                switch response.result {
                case .Success(let keywords): success(keywords)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: Language -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetLanguage",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: [
                NSURLQueryItem(name: "url", value: url),
                NSURLQueryItem(name: "apikey", value: apiKey),
                NSURLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Language, NSError>) in
                switch response.result {
                case .Success(let language): success(language)
                case .Failure(let error): failure?(error)
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
        forText text: NSURL,
        failure: (NSError -> Void)? = nil,
        success: Language -> Void)
    {
        // construct body
        let body = try? buildBody(text, html: false)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/text/TextGetLanguage",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Language, NSError>) in
                switch response.result {
                case .Success(let language): success(language)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: Microformats -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetMicroformatData",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: [
                NSURLQueryItem(name: "url", value: url),
                NSURLQueryItem(name: "apikey", value: apiKey),
                NSURLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Microformats, NSError>) in
                switch response.result {
                case .Success(let microformats): success(microformats)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = " ",
        failure: (NSError -> Void)? = nil,
        success: Microformats -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetMicroformatData",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Microformats, NSError>) in
                switch response.result {
                case .Success(let microformats): success(microformats)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: PublicationResponse -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetPubDate",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: [
                NSURLQueryItem(name: "url", value: url),
                NSURLQueryItem(name: "apikey", value: apiKey),
                NSURLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<PublicationResponse, NSError>) in
                switch response.result {
                case .Success(let pubResponse): success(pubResponse)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: PublicationResponse -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetPubDate",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<PublicationResponse, NSError>) in
                switch response.result {
                case .Success(let pubResponse): success(pubResponse)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: SAORelations -> Void)
    {
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(NSURLQueryItem(name: "url", value: url))
        if let graph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let disEnts = disambiguateEntities {
            queryParams.append(NSURLQueryItem(name: "disambiguate", value: String(disEnts.rawValue)))
        }
        if let link = linkedData {
            queryParams.append(NSURLQueryItem(name: "linkedData", value: String(link.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(NSURLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(NSURLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keyWords = keywords {
            queryParams.append(NSURLQueryItem(name: "keywords", value: String(keyWords.rawValue)))
        }
        if let ents = entities {
            queryParams.append(NSURLQueryItem(name: "entities", value: String(ents.rawValue)))
        }
        if let reqEnts = requireEntities {
            queryParams.append(NSURLQueryItem(name: "requireEntities",
                value: String(reqEnts.rawValue)))
        }
        if let sentiExEnts = sentimentExcludeEntities {
            queryParams.append(NSURLQueryItem(name: "sentimentExcludeEntities",
                value: String(sentiExEnts.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetRelations",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<SAORelations, NSError>) in
                switch response.result {
                case .Success(let relations): success(relations)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
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
        failure: (NSError -> Void)? = nil,
        success: SAORelations -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        if let graph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let disEnts = disambiguateEntities {
            queryParams.append(NSURLQueryItem(name: "disambiguate", value: String(disEnts.rawValue)))
        }
        if let link = linkedData {
            queryParams.append(NSURLQueryItem(name: "linkedData", value: String(link.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(NSURLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(NSURLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keyWords = keywords {
            queryParams.append(NSURLQueryItem(name: "keywords", value: String(keyWords.rawValue)))
        }
        if let ents = entities {
            queryParams.append(NSURLQueryItem(name: "entities", value: String(ents.rawValue)))
        }
        if let reqEnts = requireEntities {
            queryParams.append(NSURLQueryItem(name: "requireEntities",
                value: String(reqEnts.rawValue)))
        }
        if let sentiExEnts = sentimentExcludeEntities {
            queryParams.append(NSURLQueryItem(name: "sentimentExcludeEntities",
                value: String(sentiExEnts.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetRelations",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<SAORelations, NSError>) in
                switch response.result {
                case .Success(let relations): success(relations)
                case .Failure(let error): failure?(error)
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
        forText text: NSURL,
        knowledgeGraph: QueryParam? = nil,
        disambiguateEntities: QueryParam? = nil,
        linkedData: QueryParam? = nil,
        coreference: QueryParam? = nil,
        sentiment: QueryParam? = nil,
        keywords: QueryParam? = nil,
        entities: QueryParam? = nil,
        requireEntities: QueryParam? = nil,
        sentimentExcludeEntities: QueryParam? = nil,
        failure: (NSError -> Void)? = nil,
        success: SAORelations -> Void)
    {
        // construct body
        let body = try? buildBody(text, html: false)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let graph = knowledgeGraph {
            queryParams.append(NSURLQueryItem(name: "knowledgeGraph", value: String(graph.rawValue)))
        }
        if let disEnts = disambiguateEntities {
            queryParams.append(NSURLQueryItem(name: "disambiguate", value: String(disEnts.rawValue)))
        }
        if let link = linkedData {
            queryParams.append(NSURLQueryItem(name: "linkedData", value: String(link.rawValue)))
        }
        if let coref = coreference {
            queryParams.append(NSURLQueryItem(name: "coreference", value: String(coref.rawValue)))
        }
        if let senti = sentiment {
            queryParams.append(NSURLQueryItem(name: "sentiment", value: String(senti.rawValue)))
        }
        if let keyWords = keywords {
            queryParams.append(NSURLQueryItem(name: "keywords", value: String(keyWords.rawValue)))
        }
        if let ents = entities {
            queryParams.append(NSURLQueryItem(name: "entities", value: String(ents.rawValue)))
        }
        if let reqEnts = requireEntities {
            queryParams.append(NSURLQueryItem(name: "requireEntities",
                value: String(reqEnts.rawValue)))
        }
        if let sentiExEnts = sentimentExcludeEntities {
            queryParams.append(NSURLQueryItem(name: "sentimentExcludeEntities",
                value: String(sentiExEnts.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/text/TextGetRelations",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<SAORelations, NSError>) in
                switch response.result {
                case .Success(let relations): success(relations)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: SentimentResponse -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetTextSentiment",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: [
                NSURLQueryItem(name: "url", value: url),
                NSURLQueryItem(name: "apikey", value: apiKey),
                NSURLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<SentimentResponse, NSError>) in
                switch response.result {
                case .Success(let sentimentResponse): success(sentimentResponse)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: SentimentResponse -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetTextSentiment",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<SentimentResponse, NSError>) in
                switch response.result {
                case .Success(let sentimentResponse): success(sentimentResponse)
                case .Failure(let error): failure?(error)
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
        forText text: NSURL,
        failure: (NSError -> Void)? = nil,
        success: SentimentResponse -> Void)
    {
        // construct body
        let body = try? buildBody(text, html: false)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/text/TextGetTextSentiment",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<SentimentResponse, NSError>) in
                switch response.result {
                case .Success(let sentimentResponse): success(sentimentResponse)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: SentimentResponse -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetTargetedSentiment",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: [
                NSURLQueryItem(name: "target", value: target),
                NSURLQueryItem(name: "url", value: url),
                NSURLQueryItem(name: "apikey", value: apiKey),
                NSURLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<SentimentResponse, NSError>) in
                switch response.result {
                case .Success(let sentimentResponse): success(sentimentResponse)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        target: String,
        url: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: SentimentResponse -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(NSURLQueryItem(name: "target", value: target))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetTargetedSentiment",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<SentimentResponse, NSError>) in
                switch response.result {
                case .Success(let sentimentResponse): success(sentimentResponse)
                case .Failure(let error): failure?(error)
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
        forText text: NSURL,
        target: String,
        failure: (NSError -> Void)? = nil,
        success: SentimentResponse -> Void)
    {
        // construct body
        let body = try? buildBody(text, html: false)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(NSURLQueryItem(name: "target", value: target))
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/text/TextGetTargetedSentiment",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<SentimentResponse, NSError>) in
                switch response.result {
                case .Success(let sentimentResponse): success(sentimentResponse)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: Taxonomies -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetRankedTaxonomy",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: [
                NSURLQueryItem(name: "url", value: url),
                NSURLQueryItem(name: "apikey", value: apiKey),
                NSURLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Taxonomies, NSError>) in
                switch response.result {
                case .Success(let taxonomies): success(taxonomies)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: Taxonomies -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetRankedTaxonomy",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Taxonomies, NSError>) in
                switch response.result {
                case .Success(let taxonomies): success(taxonomies)
                case .Failure(let error): failure?(error)
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
        forText text: NSURL,
        failure: (NSError -> Void)? = nil,
        success: Taxonomies -> Void)
    {
        // construct body
        let body = try? buildBody(text, html: false)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/text/TextGetRankedTaxonomy",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Taxonomies, NSError>) in
                switch response.result {
                case .Success(let taxonomies): success(taxonomies)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: DocumentText -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetRawText",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: [
                NSURLQueryItem(name: "url", value: url),
                NSURLQueryItem(name: "apikey", value: apiKey),
                NSURLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentText, NSError>) in
                switch response.result {
                case .Success(let docText): success(docText)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: DocumentText -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetRawText",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentText, NSError>) in
                switch response.result {
                case .Success(let docText): success(docText)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: DocumentText -> Void)
    {
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(NSURLQueryItem(name: "url", value: url))
        if let metadata = useMetadata {
            queryParams.append(NSURLQueryItem(name: "useMetadata", value: String(metadata.rawValue)))
        }
        if let extract = extractLinks {
            queryParams.append(NSURLQueryItem(name: "extractLinks", value: String(extract.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetText",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentText, NSError>) in
                switch response.result {
                case .Success(let docText): success(docText)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = nil,
        useMetadata: QueryParam? = nil,
        extractLinks: QueryParam? = nil,
        failure: (NSError -> Void)? = nil,
        success: DocumentText -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        if let metadata = useMetadata {
            queryParams.append(NSURLQueryItem(name: "useMetadata", value: String(metadata.rawValue)))
        }
        if let extract = extractLinks {
            queryParams.append(NSURLQueryItem(name: "extractLinks", value: String(extract.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetText",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentText, NSError>) in
                switch response.result {
                case .Success(let docText): success(docText)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: DocumentTitle -> Void)
    {
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParams.append(NSURLQueryItem(name: "url", value: url))
        if let metadata = useMetadata {
            queryParams.append(NSURLQueryItem(name: "useMetadata", value: String(metadata.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetTitle",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentTitle, NSError>) in
                switch response.result {
                case .Success(let docTitle): success(docTitle)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = nil,
        useMetadata: QueryParam? = nil,
        failure: (NSError -> Void)? = nil,
        success: DocumentTitle -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        if let metadata = useMetadata {
            queryParams.append(NSURLQueryItem(name: "useMetadata", value: String(metadata.rawValue)))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetTitle",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentTitle, NSError>) in
                switch response.result {
                case .Success(let docTitle): success(docTitle)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: Feeds -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetFeedLinks",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: [
                NSURLQueryItem(name: "url", value: url),
                NSURLQueryItem(name: "apikey", value: apiKey),
                NSURLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Feeds, NSError>) in
                switch response.result {
                case .Success(let feeds): success(feeds)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = " ",
        failure: (NSError -> Void)? = nil,
        success: Feeds -> Void)
    {
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetFeedLinks",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Feeds, NSError>) in
                switch response.result {
                case .Success(let feeds): success(feeds)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: DocumentEmotion -> Void)
    {
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/url/URLGetEmotion",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: [
                NSURLQueryItem(name: "url", value: url),
                NSURLQueryItem(name: "apikey", value: apiKey),
                NSURLQueryItem(name: "outputMode", value: "json")
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentEmotion, NSError>) in
                switch response.result {
                case .Success(let emotion): success(emotion)
                case .Failure(let error): failure?(error)
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
        forHtml html: NSURL,
        url: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: DocumentEmotion -> Void)
    {
        
        // construct body
        let body = try? buildBody(html, html: true)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let myUrl = url {
            queryParams.append(NSURLQueryItem(name: "url", value: myUrl))
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/html/HTMLGetEmotion",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentEmotion, NSError>) in
                switch response.result {
                case .Success(let emotion): success(emotion)
                case .Failure(let error): failure?(error)
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
        forText text: NSURL,
        failure: (NSError -> Void)? = nil,
        success: DocumentEmotion -> Void)
    {
        
        // construct body
        let body = try? buildBody(text, html: false)
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceUrl + "/text/TextGetEmotion",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams,
            messageBody: body
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<DocumentEmotion, NSError>) in
                switch response.result {
                case .Success(let emotion): success(emotion)
                case .Failure(let error): failure?(error)
                }
        }
    }

}
