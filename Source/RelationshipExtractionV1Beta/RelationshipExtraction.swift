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
 The Watson Relationship Extraction service is able to parse sentences into their various components 
 and detect relationships between the components. Relationship Extraction models are domain-specific
 and work best with in-domain input. The service can currently analyze news articles and, based on 
 statistical modeling, the service will perform linguistic analysis of the input text, find spans of 
 text that refers to entities, cluster them together to form entities, and extract the relationships 
 between the entities.
 */
@available(*, deprecated, message: "Relationship Extraction will be deprecated on July 27th 2016. If you want to continue using Relationship Extraction models, you can now access them with AlchemyLanguage. See the migration guide for details.")
public class RelationshipExtraction {
    
    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/relationship-extraction-beta/api"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let credentials: Credentials
    private let domain = "com.ibm.watson.developer-cloud.RelationshipExtractionV1Beta"
    
    /**
     Create a `RelationshipExtraction` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        credentials = Credentials.basicAuthentication(username: username, password: password)
    }
    
    /**
     If the response or data represents an error returned by the Relationship Extraction 
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
            let userInfo = [NSLocalizedFailureReasonErrorKey: message]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    /**
     Analyzes a piece of text and extracts the different entities, along with the relationships that 
     exist between those entities.
     
     - parameter text: The text to be analyzed.
     - parameter language: Identifier for the language of the text. For example, "ie-en-news" for
            English, and "ie-es-news" for Spanish.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a Document object.
     */
    public func getRelationships(
        fromText text: String,
        withLanguage language: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Document) -> Void) {
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "txt", value: text))
        queryParameters.append(URLQueryItem(name: "sid", value: language))
        queryParameters.append(URLQueryItem(name: "rt", value: "json"))
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/sire/0",
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError, path: ["doc"]) {
            (response: RestResponse<Document>) in
            switch response.result {
            case .success(let document): success(document)
            case .failure(let error): failure?(error)
            }
        }
    }
}
