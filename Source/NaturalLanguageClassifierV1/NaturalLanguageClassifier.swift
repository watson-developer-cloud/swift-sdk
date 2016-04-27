/**
 * Copyright IBM Corporation 2015
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

public class NaturalLanguageClassifierV1 {
    
    private let username: String
    private let password: String
    
    private let domain = "com.ibm.watson.developer-cloud.WatsonDeveloperCloud"
    private let serviceURL = "https://gateway.watsonplatform.net/natural-language-classifier/api"
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let error = try json.string("error")
            let code = try json.int("code")
            let description = try json.string("description")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: error,
                NSLocalizedRecoverySuggestionErrorKey: description
            ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    /**
     Retrieves the list of classifiers for the service instance. Returns an empty array
     if no classifiers are available.
     
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of available standard and custom models.
     */
    public func getClassifiers(
        failure: (NSError -> Void)? = nil,
        success: [ClassifierModel] -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/classifiers"
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(dataToError: dataToError, path: ["classifiers"]) {
                (response: Response<[ClassifierModel], NSError>) in
                switch response.result {
                case .Success(let classifiers): success(classifiers)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
}
