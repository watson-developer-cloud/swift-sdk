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
 The AlchemyDataNews API utilizes natural language processing technologies to query the world's
 news and blogs like a database. 
 */
public class AlchemyDataNews {
    
    /// The base URL to use when contacting the service.
    public var serviceUrl = "https://gateway-a.watsonplatform.net/calls"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let apiKey: String
    private let errorDomain = "com.watsonplatform.alchemyDataNews"
    
    /**
     Create an `AlchemyDataNews` object.
     
     - parameter apiKey: The API key credential to use when authenticating with the service.
     */
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /**
     Returns articles matching the query. If no query is given, simply returns a count of articles
     matching the start/end timeframe.
     
     Timeframe values as numbers are assumed to be in second, however some convenience values are
     recognized by the service. For a list of those values, visit
     http://docs.alchemyapi.com/docs/counts
     
     There are several specific query parameters and 'return' fields. A list can be found at:
     http://docs.alchemyapi.com/docs/full-list-of-supported-news-api-fields
     
     - parameter start:   the start value for the search timeframe
     - parameter end:     the end value for the search timefram
     - parameter query:   key-value pairs that will build the request query
     - parameter failure: a function executed if the call fails
     - parameter success: a function executed with NewsResponse information
     */
    public func getNews(
        start: String,
        end: String,
        query: [String : String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (NewsResponse) -> Void)
    {
        
        // construct query paramerters
        var queryParams = [URLQueryItem]()
        
        if let queries = query {
            for (key, value) in queries {
                queryParams.append(URLQueryItem(name: key, value: value))
            }
        }
        queryParams.append(URLQueryItem(name: "start", value: start))
        queryParams.append(URLQueryItem(name: "end", value: end))
        queryParams.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(URLQueryItem(name: "outputMode", value: "json"))
        
        // construct request
        let request = RestRequest(
            method: .get,
            url: serviceUrl + "/data/GetNews",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<NewsResponse>) in
                switch response.result {
                case .success(let newsResponse): success(newsResponse)
                case .failure(let error): failure?(error)
                }
        }
    }
    
}
