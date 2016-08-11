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
 The IBM Watson Tradeoff Analytics service helps people make better choices when faces with a
 decision problem that includes multiple, often conflicting, goals and alternatives. By using
 mathematical filtering techniques to identify the top options based on different criteria, the
 service can help users explore the trade-offs between options to make complex decisions.
 */
public class TradeoffAnalytics {
    
    private let username: String
    private let password: String
    private let serviceURL: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.6.0 TradeoffAnalyticsV1")
    private let domain = "com.ibm.watson.developer-cloud.TradeoffAnalyticsV1"

    /**
     Create a `TradeoffAnalytics` object.
 
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        username: String,
        password: String,
        serviceURL: String = "https://gateway.watsonplatform.net/tradeoff-analytics/api")
    {
        self.username = username
        self.password = password
        self.serviceURL = serviceURL
    }

    /**
     Get a dilemma that contains a problem and its resolution.
     
     The problem contains a set of columns (objectives) and options. The resolution contains a set
     of optimal options, their analytical characteristics, and, by default, their representation
     in a two-dimensional space.
     
     - parameter problem: The decision problem.
     - parameter generateVisualization: Indicated whether to calculate the map visualization for
        the results. If `true`, the visualization is returned; if `false`, no visualization is
        returned.
     - parameter failure: A function invoked if an error occurs.
     - parameter success: A function invoked with the resulting dilemma and visualization.
     */
    public func getDilemma(
        problem: Problem,
        generateVisualization: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: Dilemma -> Void)
    {
        // construct body
        guard let body = try? problem.toJSON().serialize() else {
            let failureReason = "Problem could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        if let generateVisualization = generateVisualization {
            queryParameters.append(NSURLQueryItem(name: "generate_visualization", value: "\(generateVisualization)"))
        }
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/dilemmas",
            acceptType: "application/json",
            contentType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .validate()
            .responseObject() {
                (response: Response<Dilemma, NSError>) in
                switch response.result {
                case .Success(let dilemma): success(dilemma)
                case .Failure(let error): failure?(error)
                }
            }
    }
}
