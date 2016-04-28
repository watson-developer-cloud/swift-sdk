/************************************************************************/
/*                                                                      */
/* IBM Confidential                                                     */
/* OCO Source Materials                                                 */
/*                                                                      */
/* (C) Copyright IBM Corp. 2001, 2016                                   */
/*                                                                      */
/* The source code for this program is not published or otherwise       */
/* divested of its trade secrets, irrespective of what has been         */
/* deposited with the U.S. Copyright Office.                            */
/*                                                                      */
/************************************************************************/

import Foundation

/// HTTP method definitions: https://tools.ietf.org/html/rfc7231#section-4.3
enum Method: String {
    case GET, HEAD, POST, PUT, PATCH, DELETE, CONNECT, OPTIONS, TRACE
}

/**
 A RestRequest object represents a REST request supported by IBM Watson.
 It captures all arguments required to construct an HTTP request message
 and can represent itself as an NSMutableURLRequest..
 */
class RestRequest {

    /// The operation's HTTP method.
    let method: Method

    /// The service's URL.
    /// (e.g. "https://gateway.watsonplatform.net/personality-insights/api")
    let serviceURL: String

    /// The operation's endpoint. (e.g. "/v2/profile")
    let endpoint: String

    /// The authentication strategy for obtaining a token.
    let authStrategy: AuthenticationStrategy?

    /// The acceptable MediaType of the response.
    let accept: MediaType?

    /// The MediaType of the message body.
    let contentType: MediaType?

    /// The query parameters to be encoded in the URL.
    let urlParams: [NSURLQueryItem]?

    /// A dictionary of parameters to be encoded in the header.
    let headerParams: [String: String]?

    /// The data to be included in the message body.
    let messageBody: NSData?

    /// A representation of the request as an NSMutableURLRequest.
    var urlRequest: NSMutableURLRequest {

        // construct URL
        let urlString = serviceURL + endpoint
        let urlComponents = NSURLComponents(string: urlString)!
        if let urlParams = urlParams {
            if !urlParams.isEmpty {
                urlComponents.queryItems = urlParams
            }
        }
        let url = urlComponents.URL!

        // construct mutable base request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        request.HTTPBody = messageBody

        // set accept type of request
        if let accept = accept {
            request.setValue(accept.rawValue, forHTTPHeaderField: "Accept")
        }

        // set content type of request
        if let contentType = contentType {
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        
        // attach the token to the request header
        if let auth = authStrategy {
            if let authToken = auth.token {
                request.setValue(authToken, forHTTPHeaderField: "X-Watson-Authentication-Token")
            }
        }

        // add user header parameters to request
        if let headerParams = headerParams {
            for (key, value) in headerParams {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        // return request
        return request
    }

    /**
     Initialize a new WatsonRequest with the given arguments.

     - parameter method:       The operation's HTTP method.
     - parameter serviceURL:   The service's URL.
     - parameter endpoint:     The operation's endpoint. (e.g. "/v2/profile")
     - parameter authStrategy: The authentication strategy for obtaining a token.
     - parameter accept:       The acceptable MediaType for the response.
     - parameter contentType:  The MediaType of the message body.
     - parameter urlParams:    The query parameters to be encoded in the URL.
     - parameter headerParams: A dictionary of parameters to be encoded in the header.
     - parameter messageBody:  The data to be included in the message body.

     - returns: A WatsonRequest object for use with Alamofire.
     */
    init(
        method: Method,
        serviceURL: String,
        endpoint: String,
        authStrategy: AuthenticationStrategy? = nil,
        accept: MediaType? = nil,
        contentType: MediaType? = nil,
        urlParams: [NSURLQueryItem]? = nil,
        headerParams: [String: String]? = nil,
        messageBody: NSData? = nil) {

            self.method = method
            self.serviceURL = serviceURL
            self.endpoint = endpoint
            self.authStrategy = authStrategy
            self.accept = accept
            self.contentType = contentType
            self.urlParams = urlParams
            self.headerParams = headerParams
            self.messageBody = messageBody
    }
}
