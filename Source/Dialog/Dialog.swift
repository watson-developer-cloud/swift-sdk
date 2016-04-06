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
import AlamofireObjectMapper
import ObjectMapper

/**
 The IBM Watson™ Dialog service provides a comprehensive, robust, platform for managing
 conversations between virtual agents and users through an application programming
 interface (API). These conversations are commonly referred to as dialogs.
 */
public class Dialog: WatsonService {

    // The shared WatsonGateway singleton.
    let gateway = WatsonGateway.sharedInstance

    // The authentication strategy to obtain authorization tokens.
    let authStrategy: AuthenticationStrategy

    // TODO: comment this initializer
    public required init(authStrategy: AuthenticationStrategy) {
        self.authStrategy = authStrategy
    }

    // TODO: comment this initializer
    public convenience required init(username: String, password: String) {
        let authStrategy = BasicAuthenticationStrategy(tokenURL: Constants.tokenURL,
            serviceURL: Constants.serviceURL, username: username, password: password)
        self.init(authStrategy: authStrategy)
    }

    // Date formatter
    private static var formatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
    
    // MARK: Content Operations
    
    /**
     Get the content for each node associated with a Dialog application.
    
     Depending on the Dialog design, each node can either be an input/output
     pair or just a single node.
    
     - parameter dialogID: The Dialog application identifier.
     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func getContent(dialogID: String,
        completionHandler: ([Node]?, NSError?) -> Void)
    {
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.content(dialogID),
            authStrategy: authStrategy,
            accept: .JSON)

        gateway.request(request, serviceError: DialogError()) { data, error in
            let nodes = Mapper<Node>().mapDataArray(data, keyPath: "items")
            completionHandler(nodes, error)
        }
    }
    
    /**
     Update the content for specific nodes of the Dialog application.
     
     - parameter dialogID: The Dialog application identifier.
     - parameter nodes: The specified nodes and updated content.
     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func updateContent(dialogID: DialogID, nodes: [Node],
        completionHandler: NSError? -> Void)
    {
        let request = WatsonRequest(
            method: .PUT,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.content(dialogID),
            authStrategy: authStrategy,
            contentType: .JSON,
            messageBody: Mapper().toJSONData(nodes, header: "items"))

        gateway.request(request, serviceError: DialogError()) { data, error in
            completionHandler(error)
        }
    }
    
    /**
     List the Dialog applications associated with the service instance.

     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func getDialogs(completionHandler: ([DialogModel]?, NSError?) -> Void) {

        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.dialogs,
            authStrategy: authStrategy,
            accept: .JSON)

        gateway.request(request, serviceError: DialogError()) { data, error in
            let dialogs = Mapper<DialogModel>().mapDataArray(data, keyPath: "dialogs")
            completionHandler(dialogs, error)
        }
    }
    
    /**
     Create a dialog application by uploading an existing Dialog file to the
     service instance. The returned Dialog application identifier can be used
     for subsequent calls to the API.

     The file content type is determined by the file extension:
        - .mct for encrypted Dialog account file
        - .json for Watson Dialog document JSON format
        - .xml for Watson Dialog document XML format

     - parameter name: The desired name of the Dialog application instance.
     - parameter fileURL: The URL to a file that will be uploaded and used to create
            the Dialog application. Must contain an extension of .mct for encrypted
            Dialog account file, .json for Watson Dialog document JSON format, or .xml
            for Watson Dialog document XML format.
     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func createDialog(name: String, fileURL: NSURL,
        completionHandler: (DialogID?, NSError?) -> Void)
    {
        // TODO: Update this function after WatsonGateway supports uploads
        authStrategy.refreshToken() { error in
            var headerParams = [String: String]()
            if let token = self.authStrategy.token {
                headerParams["X-Watson-Authorization-Token"] = token
            }

            let request = WatsonRequest(
                method: .POST,
                serviceURL: Constants.serviceURL,
                endpoint: Constants.dialogs,
                authStrategy: self.authStrategy,
                accept: .JSON,
                headerParams: headerParams)

            Alamofire.upload(request,
                multipartFormData: { multipartFormData in
                    let nameData = name.dataUsingEncoding(NSUTF8StringEncoding)!
                    multipartFormData.appendBodyPart(data: nameData, name: "name")
                    multipartFormData.appendBodyPart(fileURL: fileURL, name: "file")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseObject {
                            (response: Response<DialogIDModel, NSError>) in
                            let unwrapID = {
                                (dialogID: DialogIDModel?, error: NSError?) in
                                completionHandler(dialogID?.id, error) }
                            validate(response, successCode: 201,
                                serviceError: DialogError(),
                                completionHandler: unwrapID)
                        }
                    case .Failure:
                        let nsError = NSError(
                            domain: "com.alamofire.error",
                            code: -6008,
                            userInfo: [NSLocalizedDescriptionKey:
                                "Unable to encode data as multipart form."])
                        completionHandler(nil, nsError)
                    }
            })
        }
    }
    
    /**
     Delete a Dialog application associated with the service instance. This
     permanently removes all associated data.
    
     - parameter dialogID: The Dialog application identifier.
     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func deleteDialog(dialogID: DialogID, completionHandler: NSError? -> Void) {

        let request = WatsonRequest(
            method: .DELETE,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.dialogID(dialogID),
            authStrategy: authStrategy)

        gateway.request(request, serviceError: DialogError()) { data, error in
            completionHandler(error)
        }
    }
    
    /**
     Download the Dialog file associated with the given Dialog application.
     
     - parameter dialogID: The Dialog application identifier.
     - parameter format: The format of the file. The format can be either OctetStream
            (.mct file), Watson Dialog document JSON format (.json file), or Watson
            Dialog document XML format (.xml file).
     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func getDialogFile(dialogID: DialogID, format: MediaType? = nil,
        completionHandler: (NSURL?, NSError?) -> Void)
    {
        // TODO: Update this function after WatsonGateway supports uploads
        authStrategy.refreshToken() { error in
            var headerParams = [String: String]()
            if let token = self.authStrategy.token {
                headerParams["X-Watson-Authorization-Token"] = token
            }

            let request = WatsonRequest(
                method: .GET,
                serviceURL: Constants.serviceURL,
                endpoint: Constants.dialogID(dialogID),
                authStrategy: self.authStrategy,
                accept: format,
                headerParams: headerParams)

            var fileURL: NSURL?
            let req = Alamofire.download(request) { (temporaryURL, response) in
                let manager = NSFileManager.defaultManager()
                let directoryURL = manager.URLsForDirectory(.DocumentDirectory,
                    inDomains: .UserDomainMask)[0]
                let pathComponent = response.suggestedFilename
                fileURL = directoryURL.URLByAppendingPathComponent(pathComponent!)
                return fileURL!
            }

            req.response { _, response, _, error in
                var data: NSData? = nil
                if let file = fileURL?.path { data = NSData(contentsOfFile: file) }
                let includeFileURL = { error in completionHandler(fileURL, error) }
                validate(response, data: data, error: error, serviceError: DialogError(),
                    completionHandler: includeFileURL)
            }
        }
    }

    /**
     Update an existing Dialog application by uploading a Dialog file.
     
     The file content type is determined by the file extension:
        - .mct for encrypted Dialog account file
        - .json for Watson Dialog document JSON format
        - .xml for Watson Dialog document XML format
     
     - parameter dialogID: The Dialog application identifier.
     - parameter fileURL: The URL to a file that will be uploaded and used to define
            the Dialog application's operation. Must contain an extension of .mct for
            encrypted Dialog account file, .json for Watson Dialog document JSON format,
            or .xml for Watson Dialog document XML format.
     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func updateDialog(dialogID: DialogID, fileURL: NSURL,
        fileType: MediaType, completionHandler: NSError? -> Void)
    {
        // TODO: Update this function after WatsonGateway supports uploads
        authStrategy.refreshToken() { error in
            var headerParams = [String: String]()
            if let token = self.authStrategy.token {
                headerParams["X-Watson-Authorization-Token"] = token
            }

            let request = WatsonRequest(
                method: .PUT,
                serviceURL: Constants.serviceURL,
                endpoint: Constants.dialogID(dialogID),
                authStrategy: self.authStrategy,
                contentType: fileType,
                headerParams: headerParams)

            // execute request
            Alamofire.upload(request, file: fileURL)
                .responseData { response in
                    validate(response, serviceError: DialogError(),
                        completionHandler: completionHandler)
            }
        }
    }
    
    // MARK: Conversation Operations
    
    /**
     Obtain recorded conversation history.
     
     - parameter dialogID: The Dialog application identifier.
     - parameter dateFrom: The start date of the desired conversation history. The
        timezone should match that of the Dialog application.
     - parameter dateTo: The end date of the desired conversation history. The
        timezone should match that of the Dialog application.
     - parameter offset: The offset starting point in the returned history (default: 0).
     - parameter limit: The maximum number of conversations to retrieve (default: 10,000).
     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func getConversation(dialogID: DialogID, dateFrom: NSDate,
        dateTo: NSDate, offset: Int? = nil, limit: Int? = nil,
        completionHandler: ([Conversation]?, NSError?) -> Void)
    {
        let dateFromString = Dialog.formatter.stringFromDate(dateFrom)
        let dateToString = Dialog.formatter.stringFromDate(dateTo)

        var urlParams = [NSURLQueryItem]()
        urlParams.append(NSURLQueryItem(name: "date_from", value: dateFromString))
        urlParams.append(NSURLQueryItem(name: "date_to", value: dateToString))
        if let offset = offset {
            urlParams.append(NSURLQueryItem(name: "offset", value: "\(offset)"))
        }
        if let limit = limit {
            urlParams.append(NSURLQueryItem(name: "limit", value: "\(limit)"))
        }

        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.conversation(dialogID),
            authStrategy: authStrategy,
            accept: .JSON,
            urlParams: urlParams)

        gateway.request(request, serviceError: DialogError()) { data, error in
            let conversations = Mapper<Conversation>().mapDataArray(data,
                keyPath: "conversations")
            completionHandler(conversations, error)
        }
    }
    
    /**
     Start a new conversation or obtain a response for a submitted input message.
    
     - parameter dialogID: The Dialog application identifier.
     - parameter conversationID: The conversation identifier. If not specified, then a
            new conversation will be started.
     - parameter clientID: A client identifier generated by the Dialog service. If not
            specified, then a new client identifier will be issued.
     - parameter input: The user input message to send for processing. This parameter
            is optional when conversationID is not specified.
     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func converse(dialogID: DialogID, conversationID: Int? = nil,
        clientID: Int? = nil, input: String? = nil,
        completionHandler: (ConversationResponse?, NSError?) -> Void)
    {
        var urlParams = [NSURLQueryItem]()
        if let conversationID = conversationID {
            let query = NSURLQueryItem(name: "conversation_id",
                value: "\(conversationID)")
            urlParams.append(query)
        }
        if let clientID = clientID {
            let query = NSURLQueryItem(name: "client_id", value: "\(clientID)")
            urlParams.append(query)
        }
        if let input = input {
            let query = NSURLQueryItem(name: "input", value: input)
            urlParams.append(query)
        }

        let request = WatsonRequest(
            method: .POST,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.conversation(dialogID),
            authStrategy: authStrategy,
            accept: .JSON,
            urlParams: urlParams)

        gateway.request(request, serviceError: DialogError()) { data, error in
            let conversationResponse = Mapper<ConversationResponse>().mapData(data)
            completionHandler(conversationResponse, error)
        }
    }
    
    // MARK: Profile Operations
    
    /**
     Get the values for a client's profile variables.
    
     - parameter dialogID: The Dialog application identifier.
     - parameter clientID: A client identifier generated by the Dialog service.
     - parameter names: The names of the profile variables to retrieve. If nil, then all
            profile variables will be retrieved.
     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func getProfile(dialogID: DialogID, clientID: Int, names: [String]? = nil,
        completionHandler: ([Parameter]?, NSError?) -> Void)
    {
        var urlParams = [NSURLQueryItem]()
        urlParams.append(NSURLQueryItem(name: "client_id", value: "\(clientID)"))
        if let names = names {
            for name in names {
                urlParams.append(NSURLQueryItem(name: "name", value: name))
            }
        }

        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.profile(dialogID),
            authStrategy: authStrategy,
            accept: .JSON,
            urlParams: urlParams)

        gateway.request(request, serviceError: DialogError()) { data, error in
            let parameters = Mapper<Parameter>().mapDataArray(data,
                keyPath: "name_values")
            completionHandler(parameters, error)
        }
    }

    /**
     Set the values for a client's profile variables.
    
     - parameter dialogID: The Dialog application identifier.
     - parameter clientID: A client identifier generated by the Dialog service. If not
            specified, then a new client identifier will be issued.
     - parameter parameters: A dictionary of profile variables. The profile variables
            must already be explicitly defined in the Dialog application.
     - parameter completionHandler: A function invoked with the response from Watson.
     */
    public func updateProfile(dialogID: DialogID, clientID: Int?,
        parameters: [String: String], completionHandler: NSError? -> Void)
    {
        let profile = Profile(clientID: clientID, parameters: parameters)

        let request = WatsonRequest(
            method: .PUT,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.profile(dialogID),
            authStrategy: authStrategy,
            messageBody: Mapper().toJSONData(profile))

        gateway.request(request, serviceError: DialogError()) { data, error in
            completionHandler(error)
        }
    }
}