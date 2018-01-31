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

    private let errorDomain = "com.ibm.watson.developer-cloud.AlchemyDataNews"

    /**
     Create an `AlchemyDataNews` object.
     - parameter apiKey: The API key credential to use when authenticating with the service.
     */
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    /**
     If the response or data represents an error returned by the AlchemyDataNews service,
     then return NSError with information about the error that occured. Otherwise, return nil.

     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {

        // Typically, we would check the http status code in the response object here, and return
        // `nil` if the status code is successful (200 <= statusCode < 300). However, the Alchemy
        // services return a status code of 200 if you are able to successfully contact the
        // service, without regards to whether the response itself was a success or a failure.
        // https://www.ibm.com/watson/developercloud/alchemydata-news/api/v1/#error-handling

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
        request.responseObject(responseToError: responseToError) { (response: RestResponse<NewsResponse>) in
            switch response.result {
            case .success(let newsResponse): success(newsResponse)
            case .failure(let error): failure?(error)
            }
        }
    }
}
