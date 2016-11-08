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
import RestKit

/**
 AlchemyData News provides news and blog content enriched with natural language processing to allow
 for highly targeted search and trend analysis. It enables you to query the world's news sources and
 blogs like a database.
 */
public class AlchemyDataNews {
    
    /// The base URL to use when contacting the service.
    public var serviceUrl = "https://gateway-a.watsonplatform.net/calls"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    /// The API key credential to use when authenticating with the service.
    private let apiKey: String
    
    /**
     Create an `AlchemyDataNews` object.
     - parameter apiKey: The API key credential to use when authenticating with the service.
     */
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private func dataToError(data: Data) -> NSError? {
        do {
            let json = try JSON(data: data)
            let status = try json.getString(at: "status")
            let statusInfo = try json.getString(at: "statusInfo")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: status,
                NSLocalizedDescriptionKey: statusInfo
            ]
            return NSError(domain: "AlchemyDataNews", code: 400, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    /**
     Analyze news using Natural Language Processing (NLP) queries and sophisticated filters.
     
     All time arguments assume seconds as the default unit, but a more user-friendly time format
     can be used to specify relative times. For more information, see this service documentation:
     http://docs.alchemyapi.com/docs/counts
     
     There are several specific query parameters and 'return' fields. A list can be found at:
     http://docs.alchemyapi.com/docs/full-list-of-supported-news-api-fields
     
     - parameter from: The time (in UTC seconds) of the beginning date and time of the query. Valid
        values are UTC times and relative times.
     - parameter to: The time (in UTC seconds) of the end date and time of the query. Valid values
        are UTC times and relative times.
     - parameter query: Additional key-value pairs for the NLP query. For a full list of valid
        parameters, see: http://docs.alchemyapi.com/docs/full-list-of-supported-news-api-fields
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the service's response.
     */
    public func getNews(
        from startTime: String,
        to endTime: String? = nil,
        query: [String : String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (NewsResponse) -> Void)
    {
        // construct query items
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "start", value: startTime))
        queryItems.append(URLQueryItem(name: "end", value: endTime))
        queryItems.append(URLQueryItem(name: "apikey", value: apiKey))
        queryItems.append(URLQueryItem(name: "outputMode", value: "json"))
        if let query = query {
            for (key, value) in query {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }

        // construct rest request
        let request = RestRequest(
            method: "GET",
            url: serviceUrl + "/data/GetNews",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryItems
        )
        
        // execute rest request
        request.responseObject(dataToError: dataToError) { (response: RestResponse<NewsResponse>) in
            switch response.result {
            case .success(let newsResponse): success(newsResponse)
            case .failure(let error): failure?(error)
            }
        }
    }
}
