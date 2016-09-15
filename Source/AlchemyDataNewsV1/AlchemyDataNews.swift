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
    
    private let apiKey: String
    
    private let serviceUrl = "https://gateway-a.watsonplatform.net/calls"
    private let errorDomain = "com.watsonplatform.alchemyDataNews"
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.8.0 AlchemyDataNewsV1")
    
    /**
     Initilizes the AlchemyDataNews service
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
        failure: (NSError -> Void)? = nil,
        success: NewsResponse -> Void)
    {
        
        // construct query paramerters
        var queryParams = [NSURLQueryItem]()
        
        if let queries = query {
            for (key, value) in queries {
                queryParams.append(NSURLQueryItem(name: key, value: value))
            }
        }
        queryParams.append(NSURLQueryItem(name: "start", value: start))
        queryParams.append(NSURLQueryItem(name: "end", value: end))
        queryParams.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParams.append(NSURLQueryItem(name: "outputMode", value: "json"))
        
        // construct request
        let request = RestRequest(
            method: .GET,
            url: serviceUrl + "/data/GetNews",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<NewsResponse, NSError>) in
                switch response.result {
                case .Success(let newsResponse): success(newsResponse)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
}
