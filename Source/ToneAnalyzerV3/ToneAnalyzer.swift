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
 The IBM Watson Tone Analyzer service uses linguistic analysis to detect emotional tones,
 social propensities, and writing styles in written communication. Then it offers suggestions
 to help the writer improve their intended language tones.
**/
public class ToneAnalyzer {
    
    private let username: String
    private let password: String
    private let version: String
    private let serviceURL: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.6.0 ToneAnalyzerV3")
    private let domain = "com.ibm.watson.developer-cloud.ToneAnalyzerV3"

    /**
     Create a `ToneAnalyzer` object.
 
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
            in "YYYY-MM-DD" format.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        username: String,
        password: String,
        version: String,
        serviceURL: String = "https://gateway.watsonplatform.net/tone-analyzer/api")
    {
        self.username = username
        self.password = password
        self.version = version
        self.serviceURL = serviceURL
    }
    
    /**
     If the given data represents an error returned by the Visual Recognition service, then return
     an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let code = try json.int("code")
            let error = try json.string("error")
            let help = try? json.string("help")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: error,
                NSLocalizedRecoverySuggestionErrorKey: "\(help)"
            ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Analyze the tone of the given text.
     
     The message is analyzed for several tones—social, emotional, and writing. For each tone,
     various traits are derived (e.g. conscientiousness, agreeableness, and openness).
     
     - parameter text: The text to analyze.
     - parameter tones: Filter the results by a specific tone. Valid values for `tones` are
            `emotion`, `writing`, or `social`.
     - parameter sentences: Should sentence-level tone analysis by performed?
     - parameter failure: A function invoked if an error occurs.
     - parameter success: A function invoked with the tone analysis.
     */
    public func getTone(
        text: String,
        tones: [String]? = nil,
        sentences: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: ToneAnalysis -> Void)
    {
        // construct body
        guard let body = try? ["text": text].toJSON().serialize() else {
            let failureReason = "Classification text could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        if let tones = tones {
            let tonesList = tones.joinWithSeparator(",")
            queryParameters.append(NSURLQueryItem(name: "tones", value: tonesList))
        }
        if let sentences = sentences {
            queryParameters.append(NSURLQueryItem(name: "sentences", value: "\(sentences)"))
        }
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v3/tone",
            acceptType: "application/json",
            contentType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<ToneAnalysis, NSError>) in
                switch response.result {
                case .Success(let toneAnalysis): success(toneAnalysis)
                case .Failure(let error): failure?(error)
                }
            }
    }
}
