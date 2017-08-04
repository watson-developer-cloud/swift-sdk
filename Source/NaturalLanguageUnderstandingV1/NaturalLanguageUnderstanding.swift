/**
 * Copyright IBM Corporation 2017
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
 The IBM Watson Natural Language Understanding service enables developers to programmatically
 explore various features of text content at scale. Provide text, raw HTML, or a public URL and
 the service will give you results for the features requested. Features to request for includes
 the ability to pull Concepts, Entities, Keywords, Categories, Sentiment, Emotion, Relations,
 Semantic Roles and Metadata from the content given.
 */
public class NaturalLanguageUnderstanding {
    
    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/natural-language-understanding/api"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let credentials: Credentials
    private let version: String
    private let domain = "com.ibm.watson.developer-cloud.NaturalLanguageUnderstandingV1"
    
    /**
     Create a `NaturalLanguageUnderstanding` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String, version: String) {
        credentials = Credentials.basicAuthentication(username: username, password: password)
        self.version = version
    }
    
    /**
     If the response or data represents an error returned by the Natural Language Understanding 
     service, then return NSError with information about the error that occured. Otherwise, 
     return nil.
     
     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {
        
        // First check http status code in response
        if let response = response {
            if response.statusCode >= 200 && response.statusCode < 300 {
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
            let json = try JSON(data: data)
            let code = response?.statusCode ?? 400
            let message = try json.getString(at: "error")
            var userInfo = [NSLocalizedFailureReasonErrorKey: message]
            if let description = try? json.getString(at: "description") {
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = description
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    /**
     Analyze text, HTML, or a public webpage with one or more text analysis features.
     
     - parameter parameters: A `Parameters` object containing the content to be analyzed, as well as 
        the specific features to analyze the content for.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the results from the text analysis.
     */
    public func analyzeContent(
        withParameters parameters: Parameters,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (AnalysisResults) -> Void) {
        
        // construct body
        guard let body = try? parameters.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/analyze",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<AnalysisResults>) in
            switch response.result {
            case .success(let result): success(result)
            case .failure(let error): failure?(error)
            }
        }
    }
}
