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
 The Watson Relationship Extraction service is able to parse sentences into their various components 
 and detect relationships between the components. Relationship Extraction models are domain-specific
 and work best with in-domain input. The service can currently analyze news articles and, based on 
 statistical modeling, the service will perform linguistic analysis of the input text, find spans of 
 text that refers to entities, cluster them together to form entities, and extract the relationships 
 between the entities.
 */
@available(*, deprecated, message="Relationship Extraction will be deprecated on July 27th 2016. If you want to continue using Relationship Extraction models, you can now access them with AlchemyLanguage. See the migration guide for details.")
public class RelationshipExtraction {
    private let username: String
    private let password: String
    private let serviceURL: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.8.0 RelationshipExtractionV1Beta")
    private let domain = "com.ibm.watson.developer-cloud.RelationshipExtractionV1Beta"
    
    /**
     Create a `RelationshipExtraction` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        username: String,
        password: String,
        serviceURL: String = "https://gateway.watsonplatform.net/relationship-extraction-beta/api")
    {
        self.username = username
        self.password = password
        self.serviceURL = serviceURL
    }
    
    /**
     If the given data represents an error returned by the Relationship Extraction service, then 
     return an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let code = try json.int("error_code")
            let error = try json.string("error_message")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: error,
            ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    /**
     Analyzes a piece of text and extracts the different entities, along with the relationships that 
     exist between those entities.
     
     - parameter language: Identifier for the language of the text. For example, "ie-en-news" for 
            English, and "ie-es-news" for Spanish.
     - parameter text: The text to be analyzed.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a Document object.
     */
    public func getRelationships(
        language: String,
        text: String,
        failure: (NSError -> Void)? = nil,
        success: Document -> Void) {
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "txt", value: text))
        queryParameters.append(NSURLQueryItem(name: "sid", value: language))
        queryParameters.append(NSURLQueryItem(name: "rt", value: "json"))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/sire/0",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError, path: ["doc"]) {
                (response: Response<Document, NSError>) in
                switch response.result {
                case .Success(let document): success(document)
                case .Failure(let error): failure?(error)
                }
        }
    }
}
