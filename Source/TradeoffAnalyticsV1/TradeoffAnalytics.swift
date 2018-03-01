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
 The IBM Watson Tradeoff Analytics service helps people make better choices when faces with a
 decision problem that includes multiple, often conflicting, goals and alternatives. By using
 mathematical filtering techniques to identify the top options based on different criteria, the
 service can help users explore the trade-offs between options to make complex decisions.
 */
public class TradeoffAnalytics {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/tradeoff-analytics/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let credentials: Credentials
    private let domain = "com.ibm.watson.developer-cloud.TradeoffAnalyticsV1"

    /**
     Create a `TradeoffAnalytics` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.credentials = Credentials.basicAuthentication(username: username, password: password)
    }

    /**
     If the response or data represents an error returned by the Tradeoff Analytics service,
     then return NSError with information about the error that occured. Otherwise, return nil.

     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {

        // First check http status code in response
        if let response = response {
            if (200..<300).contains(response.statusCode) {
                return nil
            }
        }

        // ensure data is not nil
        guard let data = data else {
            if let code = response?.statusCode {
                return NSError(domain: domain, code: code, userInfo: nil)
            }
            return nil  // RestKit will generate error for this case
        }

        do {
            let json = try JSONWrapper(data: data)
            let code = response?.statusCode ?? 400
            let message = try json.getString(at: "error")
            var userInfo = [NSLocalizedDescriptionKey: message]
            if let description = try? json.getString(at: "description") {
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = description
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Get a dilemma that contains a problem and its resolution.

     The problem contains a set of columns (objectives) and options. The resolution contains a set
     of optimal options, their analytical characteristics, and, by default, their representation
     in a two-dimensional space.

     - parameter for: The decision problem.
     - parameter generateVisualization: Indicated whether to calculate the map visualization for
        the results. If `true`, the visualization is returned; if `false`, no visualization is
        returned.
     - parameter failure: A function invoked if an error occurs.
     - parameter success: A function invoked with the resulting dilemma and visualization.
     */
    public func getDilemma(
        for problem: Problem,
        generateVisualization: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Dilemma) -> Void)
    {
        // construct body
        guard let body = try? problem.toJSON().serialize() else {
            let failureReason = "Problem could not be serialized to JSON."
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let generateVisualization = generateVisualization {
            queryParameters.append(URLQueryItem(name: "generate_visualization", value: "\(generateVisualization)"))
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/dilemmas",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        // TODO: Add status code validation
        request.responseObject(responseToError: responseToError) { (response: RestResponse<Dilemma>) in
            switch response.result {
            case .success(let dilemma): success(dilemma)
            case .failure(let error): failure?(error)
            }
        }
    }
}
