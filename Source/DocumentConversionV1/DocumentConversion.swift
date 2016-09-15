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
 The IBM Watson™ Document Conversion Service converts a single HTML, PDF, or Microsoft Word™ 
 document. The input document is transformed into normalized HTML, plain text, or a set of 
 JSON-formatted Answer units that can be used with other Watson services, like the
 Watson Retrieve and Rank Service.
 */
public class DocumentConversion {
    
    private let username: String
    private let password: String
    private let serviceURL: String
    private let version: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.8.0 DocumentConversionV1")
    private let domain = "com.ibm.watson.developer-cloud.DocumentConversionV1"
    
    /**
     Create a `DocumentConversion` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        username: String,
        password: String,
        version: String,
        serviceURL: String = "https://gateway.watsonplatform.net/document-conversion/api")
    {
        self.username = username
        self.password = password
        self.serviceURL = serviceURL
        self.version = version
    }
    
    /**
     If the given data represents an error returned by the Document Conversion service, then return
     an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            if let errCode = try? json.int("code") {
                let code = errCode
                let message = try json.string("error")
                let userInfo = [NSLocalizedFailureReasonErrorKey: message]
                return NSError(domain: domain, code: code, userInfo: userInfo)
            } else if let errCode = try? json.string("code") {
                let code = Int(errCode)!
                let message = try json.string("error")
                let userInfo = [NSLocalizedFailureReasonErrorKey: message]
                return NSError(domain: domain, code: code, userInfo: userInfo)
            }
            return nil
        } catch {
            return nil
        }
    }
    
    /**
     Sends a request to the Document Conversion service to attempt to convert a document from one 
     format to another.
     
     - parameter config:   Configuration file for the Document Conversion service. Information on
                           config files can be found here:
     http://www.ibm.com/watson/developercloud/doc/document-conversion/customizing.shtml
     - parameter document: The document you want to convert
     - parameter version:  The date of the version of Document Service you want to use.
     - parameter fileType: Explicit type of the file you are converting, if the service cannot
                           detect or you don't want the service to auto detect the file type
     - parameter failure:  A function executed if the call fails
     - parameter success:  A function executed with the response String
     */
    public func convertDocument(
        config: NSURL,
        document: NSURL,
        fileType: FileType? = nil,
        failure: (NSError -> Void)? = nil,
        success: String -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/convert_document",
            userAgent: userAgent,
            queryParameters: [NSURLQueryItem(name: "version", value: version)]
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: config, name: "config")
                multipartFormData.appendBodyPart(fileURL: document, name: "file")
                if let type = fileType {
                    multipartFormData.appendBodyPart(
                        data: type.rawValue.dataUsingEncoding(NSUTF8StringEncoding)!,
                        name: "type")
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.authenticate(user: self.username, password: self.password)
                    upload.responseData() {
                        (response: Response<NSData, NSError>) in
                        if response.data == nil {
                            let failureReason = "Response data was nil"
                            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                            failure?(error)
                            return
                        } else if let error = response.result.error {
                            //there's an error that's already been captured
                            failure?(error)
                            return
                        } else if let error = self.dataToError(response.data!) {
                            failure?(error)
                            return
                        }  else {
                            switch response.result {
                            case .Success(_): success(
                                String(data: response.data!, encoding: NSUTF8StringEncoding)!)
                            case .Failure(let error): failure?(error)
                            }
                        }
                    }
                case .Failure:
                    let failureReason = "One or more values could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }
    
    /**
     Deserializes a response string to a ConversationResponse object. Only works with AnswerUnits
     as that's the only response type from the service that returns a JSON object. The other two
     options return plain text
     
     - parameter string: the String to attempt to convert to a ConversationResponse object
     
     - retuns: A ConversationReponse object populated with the input's data
     */
    public func deserializeAnswerUnits(string: String) throws -> ConversationResponse {
        let toJson = try JSON(jsonString: string)
        do {
            let answerUnits = try ConversationResponse(json: toJson)
            return answerUnits
        } catch {
            throw JSON.Error.ValueNotConvertible(value: toJson, to: ConversationResponse.self)
        }
    }
    
    /**
     Write service config parameters to a temporary JSON file that can be uploaded. This creates the
     most basic configuration file possible. For information on creating your own, with greater
     functionality, see: 
     http://www.ibm.com/watson/developercloud/doc/document-conversion/customizing.shtml
     
     - parameter type: The return type of the service you wish to recieve.
     
     - returns: The URL of a JSON file that includes the given parameters.
     */
    public func writeConfig(type: ReturnType) throws -> NSURL {
        // construct JSON dictionary
        var json = [String: JSON]()
        json["conversion_target"] = JSON.String(type.rawValue)
        
        // create a globally unique file name in a temporary directory
        let suffix = "DocumentConversionConfiguration.json"
        let fileName = String(format: "%@_%@", NSUUID().UUIDString, suffix)
        let directoryURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = directoryURL.URLByAppendingPathComponent(fileName)!
        
        // save JSON dictionary to file
        do {
            let data = try JSON.Dictionary(json).serialize()
            try data.writeToURL(fileURL, options: .AtomicWrite)
        } catch {
            let message = "Unable to create config file"
            let userInfo = [NSLocalizedFailureReasonErrorKey: message]
            throw NSError(domain: domain, code: 0, userInfo: userInfo)
        }
        
        return fileURL
    }
    
}

/**
 Enum for supported return types from the DocumentConversion service
 */
public enum ReturnType: String {
    
    /// Constant for AnswerUnits
    case AnswerUnits = "ANSWER_UNITS"
    
    /// Constant for HTML
    case HTML = "NORMALIZED_HTML"
    
    /// Constant for Text
    case Text = "NORMALIZED_TEXT"
}
