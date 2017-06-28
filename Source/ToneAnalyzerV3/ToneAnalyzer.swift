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
 The IBM Watson Tone Analyzer service uses linguistic analysis to detect emotional tones,
 social propensities, and writing styles in written communication. Then it offers suggestions
 to help the writer improve their intended language tones.
**/
public class ToneAnalyzer {
    
    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/tone-analyzer/api"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let credentials: Credentials
    private let version: String
    private let domain = "com.ibm.watson.developer-cloud.ToneAnalyzerV3"

    /**
     Create a `ToneAnalyzer` object.
 
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
            in "YYYY-MM-DD" format.
     */
    public init(username: String, password: String, version: String) {
        self.credentials = Credentials.basicAuthentication(username: username, password: password)
        self.version = version
    }
    
    /**
     If the response or data represents an error returned by the Tone Analyzer service,
     then return NSError with information about the error that occured. Otherwise, return nil.
     
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
            let help = try? json.getString(at: "help")
            let description = try? json.getString(at: "description")
            if let recoverySuggestion = help ?? description {
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = recoverySuggestion
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Analyze the tone of the given text.
     
     The message is analyzed for several tones—social, emotional, and writing. For each tone,
     various traits are derived (e.g. conscientiousness, agreeableness, and openness).
     
     - parameter ofText: The text to analyze.
     - parameter tones: Filter the results by a specific tone. Valid values for `tones` are
            `emotion`, `writing`, or `social`.
     - parameter sentences: Should sentence-level tone analysis by performed?
     - parameter failure: A function invoked if an error occurs.
     - parameter success: A function invoked with the tone analysis.
     */
    public func getTone(
        ofText text: String,
        tones: [String]? = nil,
        sentences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ToneAnalysis) -> Void)
    {
        // construct body
        guard let body = try? JSON(dictionary: ["text": text]).serialize() else {
            let failureReason = "Classification text could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let tones = tones {
            let tonesList = tones.joined(separator: ",")
            queryParameters.append(URLQueryItem(name: "tones", value: tonesList))
        }
        if let sentences = sentences {
            queryParameters.append(URLQueryItem(name: "sentences", value: "\(sentences)"))
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/tone",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ToneAnalysis>) in
            switch response.result {
            case .success(let toneAnalysis): success(toneAnalysis)
            case .failure(let error): failure?(error)
            }
        }
    }
}
