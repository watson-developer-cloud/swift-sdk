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

/// A DialogID uniquely identifies a dialog application.
public typealias DialogID = String

/**
 The Watson Dialog service provides a comprehensive, robust, platform for managing
 conversations between virtual agents and users through an application programming
 interface (API). These conversations are commonly referred to as dialogs.
 */
@available(*, deprecated, message: "The IBM Watson™ Dialog service will be deprecated on August 15, 2016. The service will be retired on September 8, 2016, after which no new instances of the service can be created, though existing instances of the service will continue to function until August 9, 2017. Users of the Dialog service should migrate their applications to use the IBM Watson™ Conversation service. See the migration documentation to learn how to migrate your dialogs to the Conversation service.")
public class Dialog {
    
    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/dialog/api"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let username: String
    private let password: String
    private let domain = "com.ibm.watson.developer-cloud.DialogV1"
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()

    /**
     Create a `Dialog` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    /**
     If the given data represents an error returned by the Visual Recognition service, then return
     an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: Data) -> NSError? {
        do {
            let json = try JSON(data: data)
            let error = try json.getString(at: "error")
            let code = try json.getInt(at: "code")
            let userInfo = [NSLocalizedFailureReasonErrorKey: error]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    // MARK: - Content Operations

    /**
     List the dialog applications associated with this service instance.
     
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of dialog applications.
     */
    public func getDialogs(
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([DialogModel]) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: .get,
            url: serviceURL + "/v1/dialogs",
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(path: ["dialogs"]) { (response: DataResponse<[DialogModel]>) in
                switch response.result {
                case .success(let dialogs): success(dialogs)
                case .failure(let error): failure?(error)
                }
            }
    }

    /**
     Create a dialog application by uploading an existing dialog file to the
     service instance. The returned dialog application identifier can be used
     for subsequent calls to the API.

     The file content type is determined by the file extension:
        - .mct for encrypted dialog account file
        - .json for Watson dialog document JSON format
        - .xml for Watson dialog document XML format

     - parameter name: The desired name of the dialog application instance.
     - parameter fileURL: The URL to a file that will be uploaded and used to create the dialog
        application. Must contain an extension of .mct for encrypted dialog account file, .json
        for Watson dialog document JSON format, or .xml for Watson dialog document XML format.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the identifier of the newly created dialog
        application.
     */
    public func createDialog(
        withName name: String,
        fromFile fileURL: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DialogID) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v1/dialogs",
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )

        // execute REST request
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                let nameData = name.data(using: String.Encoding.utf8)!
                multipartFormData.append(nameData, withName: "name")
                multipartFormData.append(fileURL, withName: "file")
            },
            with: request,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.authenticate(user: self.username, password: self.password)
                    upload.responseObject(path: ["dialog_id"]) {
                        (response: DataResponse<DialogID>) in
                        switch response.result {
                        case .success(let dialogID): success(dialogID)
                        case .failure(let error): failure?(error)
                        }
                    }
                case .failure:
                    let failureReason = "File could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }

    /**
     Delete a dialog application associated with this service instance. This
     permanently removes all associated data.
    
     - parameter dialogID: The dialog application identifier.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after the dialog application
        has been successfully deleted.
     */
    public func deleteDialog(
        withID dialogID: DialogID,
        failure: ((Error) -> Void)? = nil,
        success: ((Void) -> Void)? = nil)
    {
        // construct REST request
        let request = RestRequest(
            method: .delete,
            url: serviceURL + "/v1/dialogs/\(dialogID)",
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    switch self.dataToError(data: data) {
                    case .some(let error): failure?(error)
                    case .none: success?()
                    }
                case .failure(let error):
                    failure?(error)
                }
            }
    }

    /**
     Download the dialog file associated with the given dialog application.
     
     - parameter dialogID: The dialog application identifier.
     - parameter format: The desired format of the dialog file. The format can be either
        OctetStream (.mct file), Watson dialog document JSON format (.json file), or Watson
        dialog document XML format (.xml file).
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the URL of the downloaded dialog file.
     */
    public func getDialogFile(
        forDialogID dialogID: DialogID,
        inFormat format: Format? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (URL) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: .get,
            url: serviceURL + "/v1/dialogs/\(dialogID)",
            headerParameters: defaultHeaders,
            acceptType: format?.rawValue
        )
        
        // determine file extension
        var filetype = ".mct"
        if let format = format {
            switch format {
            case .octetStream: filetype = ".mct"
            case .wdsJSON: filetype = ".json"
            case .wdsXML: filetype = ".xml"
            }
        }
        
        // locate downloads directory
        let fileManager = FileManager.default
        let directories = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)
        guard let downloads = directories.first else {
            let failureReason = "Cannot locate documents directory."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct unique filename
        var filename = "dialog-" + dialogID + filetype
        var isUnique = false
        var duplicates = 0
        while !isUnique {
            let filePath = downloads.appendingPathComponent(filename).path
            if fileManager.fileExists(atPath: filePath) {
                duplicates += 1
                filename = "dialog-" + dialogID + "-\(duplicates)" + filetype
            } else {
                isUnique = true
            }
        }
        
        // specify download destination
        let destinationURL = downloads.appendingPathComponent(filename)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (destinationURL, [])
        }

        // execute REST request
        Alamofire.download(request, to: destination)
            .authenticate(user: username, password: password)
            .response { response in
                guard response.error == nil else {
                    failure?(response.error!)
                    return
                }
                
                guard let statusCode = response.response?.statusCode else {
                    let failureReason = "Did not receive response."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
                
                if statusCode != 200 {
                    let failureReason = "Status code was not acceptable: \(statusCode)."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: statusCode, userInfo: userInfo)
                    failure?(error)
                    return
                }
                
                success(destinationURL)
            }
    }

    /**
     Update an existing dialog application by uploading a dialog file.

     The file content type is determined by the file extension:
        - .mct for encrypted Dialog account file
        - .json for Watson Dialog document JSON format
        - .xml for Watson Dialog document XML format

     - parameter dialogID: The dialog application identifier.
     - parameter fileURL: The URL to a file that will be uploaded and used to define
        the dialog application's operation. Must contain an extension of .mct for
        encrypted Dialog account file, .json for Watson Dialog document JSON format,
        or .xml for Watson Dialog document XML format.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after the dialog file has been 
        successfully uploaded.
     */
    public func updateDialog(
        withID dialogID: DialogID,
        fromFile fileURL: URL,
        failure: ((Error) -> Void)? = nil,
        success: ((Void) -> Void)? = nil)
    {
        // construct REST request
        let request = RestRequest(
            method: .put,
            url: serviceURL + "/v1/dialogs/\(dialogID)",
            headerParameters: defaultHeaders
        )

        // execute REST request
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(fileURL, withName: "file")
            },
            with: request,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.authenticate(user: self.username, password: self.password)
                    upload.responseData { response in
                            switch response.result {
                            case .success(let data):
                                switch self.dataToError(data: data) {
                                case .some(let error): failure?(error)
                                case .none: success?()
                                }
                            case .failure(let error):
                                failure?(error)
                            }
                    }
                case .failure:
                    let failureReason = "File could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }

    /**
     Get the content for each node associated with a dialog application.

     Depending on the dialog design, each node can either be an input/output
     pair or just a single node.

     - parameter dialogID: The dialog application identifier.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the dialog application's nodes.
     */
    public func getContent(
        ofDialogID dialogID: DialogID,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Node]) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: .get,
            url: serviceURL + "/v1/dialogs/\(dialogID)/content",
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(path: ["items"]) { (response: DataResponse<[Node]>) in
                switch response.result {
                case .success(let nodes): success(nodes)
                case .failure(let error): failure?(error)
                }
            }
    }

    /**
     Update the content for specific nodes of the Dialog application.

     - parameter dialogID: The dialog application identifier.
     - parameter nodes: The specified nodes with updated content.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after the specified nodes have been updated.
     */
    public func updateContent(
        ofDialogID dialogID: DialogID,
        forNodes nodes: [Node],
        failure: ((Error) -> Void)? = nil,
        success: ((Void) -> Void)? = nil)
    {
        // serialize nodes to JSON
        guard let body = try? JSON.dictionary(["items": nodes.toJSON()]).serialize() else {
            let failureReason = "Nodes could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct REST request
        let request = RestRequest(
            method: .put,
            url: serviceURL + "/v1/dialogs/\(dialogID)/content",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: body
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    switch self.dataToError(data: data) {
                    case .some(let error): failure?(error)
                    case .none: success?()
                    }
                case .failure(let error):
                    failure?(error)
                }
        }
    }

    // MARK: -  Conversation Operations
    
    /**
     Retrieve conversation session history for a specified date range.
     
     - parameter dialogID: The dialog application identifier.
     - parameter dateFrom: The start date of the desired conversation history. The
        timezone should match that of the Dialog application.
     - parameter dateTo: The end date of the desired conversation history. The
        timezone should match that of the Dialog application.
     - parameter offset: The offset starting point in the returned history (default: 0).
     - parameter limit: The maximum number of conversations to retrieve (default: 10,000).
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the retrieved conversation history.
     */
    public func getConversationHistory(
        forDialogID dialogID: DialogID,
        from dateFrom: Date,
        to dateTo: Date,
        offset: Int? = nil,
        limit: Int? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Conversation]) -> Void)
    {
        // construct date strings
        let dateFromString = Dialog.dateFormatter.string(from: dateFrom)
        let dateToString = Dialog.dateFormatter.string(from: dateTo)

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "date_from", value: dateFromString))
        queryParameters.append(URLQueryItem(name: "date_to", value: dateToString))
        if let offset = offset {
            queryParameters.append(URLQueryItem(name: "offset", value: "\(offset)"))
        }
        if let limit = limit {
            queryParameters.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }

        // construct REST request
        let request = RestRequest(
            method: .get,
            url: serviceURL + "/v1/dialogs/\(dialogID)/conversation",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(path: ["conversations"]) { (response: DataResponse<[Conversation]>) in
                switch response.result {
                case .success(let conversations): success(conversations)
                case .failure(let error): failure?(error)
                }
            }
    }

    /**
     Start a new conversation or obtain a response for a submitted input message.
    
     - parameter dialogID: The dialog application identifier.
     - parameter conversationID: The conversation identifier. If not specified, then a
        new conversation will be started.
     - parameter clientID: A client identifier generated by the dialog service. If not
        specified, then a new client identifier will be issued.
     - parameter input: The user input message to send for processing. This parameter
        is optional when starting a new conversation.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the dialog application's response.
     */
    public func converse(
        usingDialogID dialogID: DialogID,
        withConversationID conversationID: Int? = nil,
        clientID: Int? = nil,
        input: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ConversationResponse) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let conversationID = conversationID {
            queryParameters.append(URLQueryItem(name: "conversation_id", value: "\(conversationID)"))
        }
        if let clientID = clientID {
            queryParameters.append(URLQueryItem(name: "client_id", value: "\(clientID)"))
        }
        if let input = input {
            queryParameters.append(URLQueryItem(name: "input", value: input))
        }

        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v1/dialogs/\(dialogID)/conversation",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject() { (response: DataResponse<ConversationResponse>) in
                switch response.result {
                case .success(let response): success(response)
                case .failure(let error): failure?(error)
                }
            }
    }

    // MARK: Profile Operations

    /**
     Retrieve the values for a client's profile variables.
    
     - parameter dialogID: The dialog application identifier.
     - parameter clientID: A client identifier that was generated by the dialog service.
     - parameter names: The names of the profile variables to retrieve. If nil, then all
        profile variables will be retrieved.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the retrieved profile variables.
     */
    public func getProfile(
        inDialogID dialogID: DialogID,
        withClientID clientID: Int,
        names: [String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "client_id", value: "\(clientID)"))
        if let names = names {
            for name in names {
                queryParameters.append(URLQueryItem(name: "name", value: name))
            }
        }

        // construct REST request
        let request = RestRequest(
            method: .get,
            url: serviceURL + "/v1/dialogs/\(dialogID)/profile",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject() { (response: DataResponse<Profile>) in
                switch response.result {
                case .success(let profile): success(profile)
                case .failure(let error): failure?(error)
                }
            }
    }

    /**
     Set the values for a client's profile variables.
    
     - parameter dialogID: The dialog application identifier.
     - parameter clientID: A client identifier that was generated by the dialog service.
        If not specified, then a new client identifier will be issued.
     - parameter parameters: A dictionary of profile variables. The profile variables
        must already be explicitly defined in the dialog application.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after the client's profile has been updated.
     */
    public func updateProfile(
        inDialogID dialogID: DialogID,
        withClientID clientID: Int? = nil,
        parameters: [String: String],
        failure: ((Error) -> Void)? = nil,
        success: ((Void) -> Void)? = nil)
    {
        // serialize the profile to JSON
        let profile = Profile(clientID: clientID, parameters: parameters)
        guard let body = try? profile.toJSON().serialize() else {
            let failureReason = "Profile could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct REST request
        let request = RestRequest(
            method: .put,
            url: serviceURL + "/v1/dialogs/\(dialogID)/profile",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: body
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    switch self.dataToError(data: data) {
                    case .some(let error): failure?(error)
                    case .none: success?()
                    }
                case .failure(let error):
                    failure?(error)
                }
        }
    }
}
