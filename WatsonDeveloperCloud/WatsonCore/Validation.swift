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
import ObjectMapper

/**
 Validate the response from a Watson service.
 
 Given an Alamofire response object, this function ensures a successful server
 response. If an error occurs, then the completionHandler is executed with a
 nil result value and non-nil NSError. If no error occurs, then the
 completionHandler is executed with a non-nil result value and nil NSError.
 
 There are two kinds of errors that may occur:
 
 1. Internal Networking Error - These errors typically occur if the request
 cannot be processed or the server cannot be reached. If such an
 error occurs, Alamofire will generate an NSError object. The NSError
 object is returned to the client through the completionHandler.
 
 2. Watson Error - These errors occur if the request is malformed or otherwise
 rejected by the Watson service. For example, a request may be rejected
 if it is missing required fields of contains an invalid identifier. If
 such an error occurs, then the response data is mapped onto the provided
 serviceError object, converted to an NSError, and returned to the client
 through the completionHandler.
 
 We explicitly ensure that the completionHandler is executed with a nil result
 value if an error occurs. (Unfortunately, the ObjectMapper library would
 otherwise construct a result value whose *properties* are all nil—which is not
 not very helpful for the client!)
 
 - Parameters
 - response: An Alamofire response object.
 - successCode: The HTTP status code associated with a successful
 response. Any other status code will be considered an error.
 - serviceError: An empty (all properties are nil) error object that
 conforms to the WatsonError protocol. If a Watson Error occurs,
 then ObjectMapper is used to map the response to this error
 object before converting it to an NSError and returning it
 through the completionHandler.
 - completionHandler: A function invoked with the validated response
 from Watson.
 */
internal func validate<Result, Error: WatsonError>(
    response: Response<Result, NSError>,
    successCode: Int = 200,
    serviceError: Error,
    completionHandler: NSError? -> Void) {
        
        validate(response, successCode: successCode, serviceError: serviceError) {
            _, error in
            completionHandler(error)
        }
}

/**
 Validate the response from a Watson service.
 
 Given an Alamofire response object, this function ensures a successful server
 response. If an error occurs, then the completionHandler is executed with a
 nil result value and non-nil NSError. If no error occurs, then the
 completionHandler is executed with a non-nil result value and nil NSError.
 
 There are two kinds of errors that may occur:
 
 1. Internal Networking Error - These errors typically occur if the request
 cannot be processed or the server cannot be reached. If such an
 error occurs, Alamofire will generate an NSError object. The NSError
 object is returned to the client through the completionHandler.
 
 2. Watson Error - These errors occur if the request is malformed or otherwise
 rejected by the Watson service. For example, a request may be rejected
 if it is missing required fields of contains an invalid identifier. If
 such an error occurs, then the response data is mapped onto the provided
 serviceError object, converted to an NSError, and returned to the client
 through the completionHandler.
 
 We explicitly ensure that the completionHandler is executed with a nil result
 value if an error occurs. (Unfortunately, the ObjectMapper library would
 otherwise construct a result value whose *properties* are all nil—which is not
 not very helpful for the client!)
 
 - Parameters
 - response: An Alamofire response object.
 - successCode: The HTTP status code associated with a successful
 response. Any other status code will be considered an error.
 - serviceError: An empty (all properties are nil) error object that
 conforms to the WatsonError protocol. If a Watson Error occurs,
 then ObjectMapper is used to map the response to this error
 object before converting it to an NSError and returning it
 through the completionHandler.
 - completionHandler: A function invoked with the validated response
 from Watson.
 */
internal func validate<Result, Error: WatsonError>(
    response: Response<Result, NSError>,
    successCode: Int = 200,
    serviceError: Error,
    completionHandler: (Result?, NSError?) -> Void) {
        
        // extract the result and error
        let result = response.result.value
        let error = response.result.error
        
        // was there a response from the server?
        guard let statusCode = response.response?.statusCode else {
            completionHandler(nil, error)
            return
        }
        
        // was the response successful?
        switch statusCode {
        case successCode: completionHandler(result, error)
        default:
            if let data = response.data {
                let errorString = String(data: data, encoding: NSUTF8StringEncoding)
                let dialogError = Mapper<Error>().map(errorString)
                completionHandler(nil, dialogError?.nsError)
            }
        }
}

/**
 Validate the response from a Watson service.
 
 Given an Alamofire response object, this function ensures a successful server
 response. If an error occurs, then the completionHandler is executed with a
 nil result value and non-nil NSError. If no error occurs, then the
 completionHandler is executed with a non-nil result value and nil NSError.
 
 There are two kinds of errors that may occur:
 
 1. Internal Networking Error - These errors typically occur if the request
 cannot be processed or the server cannot be reached. If such an
 error occurs, Alamofire will generate an NSError object. The NSError
 object is returned to the client through the completionHandler.
 
 2. Watson Error - These errors occur if the request is malformed or otherwise
 rejected by the Watson service. For example, a request may be rejected
 if it is missing required fields of contains an invalid identifier. If
 such an error occurs, then the response data is mapped onto the provided
 serviceError object, converted to an NSError, and returned to the client
 through the completionHandler.
 
 We explicitly ensure that the completionHandler is executed with a nil result
 value if an error occurs. (Unfortunately, the ObjectMapper library would
 otherwise construct a result value whose *properties* are all nil—which is not
 not very helpful for the client!)
 
 - Parameters
 - response: An Alamofire response object.
 - successCode: The HTTP status code associated with a successful
 response. Any other status code will be considered an error.
 - serviceError: An empty (all properties are nil) error object that
 conforms to the WatsonError protocol. If a Watson Error occurs,
 then ObjectMapper is used to map the response to this error
 object before converting it to an NSError and returning it
 through the completionHandler.
 - completionHandler: A function invoked with the validated response
 from Watson.
 */
internal func validate<Error: WatsonError>(
    response: NSHTTPURLResponse?,
    data: NSData?,
    error: NSError?,
    successCode: Int = 200,
    serviceError: Error,
    completionHandler: NSError? -> Void) {
        
        // was there a response from the server?
        guard let response = response else {
            if let error = error {
                completionHandler(error)
            } else {
                let domain = "com.watsonsdk"
                let code = 0
                let userInfo = [NSLocalizedDescriptionKey: "Internal error. No response " +
                    "received from IBM Watson."]
                let customError = NSError(domain: domain, code: code, userInfo: userInfo)
                completionHandler(customError)
            }
            return
        }
        
        // was the response successful?
        switch response.statusCode {
        case successCode: completionHandler(error)
        default:
            if let data = data {
                let errorString = String(data: data, encoding: NSUTF8StringEncoding)
                let dialogError = Mapper<Error>().map(errorString)
                completionHandler(dialogError?.nsError)
            }
        }
}