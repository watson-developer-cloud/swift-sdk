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

public class AlchemyDataNewsV1 {
    
    private let apiKey: String
    
    private let serviceUrl = "https://gateway-a.watsonplatform.net/calls"
    private let errorDomain = "com.watsonplatform.alchemyDataNews"
    
    let unreservedCharacters = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyz" +
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
        "1234567890-._~")
    
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
            queryParameters: queryParams
        )
        
        // execute request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<NewsResponse, NSError>) in
                switch response.result {
                case .Success(let authors): success(authors)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
}