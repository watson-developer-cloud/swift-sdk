/**
 * Copyright IBM Corporation 2018
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

/**
 An `AuthenticationMethod` adds authentication to a `RestRequest`.

 The authentication method adapts a `RestRequest` by adding authentication credentials to it. Authentication
 is expressed as an adapter because the credentials may be dynamic — they may change over time. For example,
 a `RestRequest` might use one token, fail with an authentication error, then retry using a refreshed token.
 The `RestRequest` does not need to be rebuilt, but should be updated with a new token value.
 */
public protocol AuthenticationMethod {

    /**
     Authenticate a `RestRequest`.

     - parameter request: The request that should be authenticated.
     - parameter completionHandler: The completion handler to execute with the authenticated `RestRequest`.
     */
    func authenticate(request: RestRequest, completionHandler: @escaping (RestRequest?, Error?) -> Void)

    /**
     Authenticate a `URLRequest`.

     - parameter request: The request that should be authenticated.
     - parameter completionHandler: The completion handler to execute with the authenticated `URLRequest`.
     */
    func authenticate(request: URLRequest, completionHandler: @escaping (URLRequest?, Error?) -> Void)
}

/** No authentication. */
public class NoAuthentication: AuthenticationMethod {
    public func authenticate(request: RestRequest, completionHandler: @escaping (RestRequest?, Error?) -> Void) {
        completionHandler(request, nil)
    }

    public func authenticate(request: URLRequest, completionHandler: @escaping (URLRequest?, Error?) -> Void) {
        completionHandler(request, nil)
    }
}

/** Authenticate with basic authentication. */
public class BasicAuthentication: AuthenticationMethod {

    public let username: String
    public let password: String
    public var tokenURL: String?
    public var token: String?

    public init(username: String, password: String, tokenURL: String? = nil) {
        self.username = username
        self.password = password
        self.tokenURL = tokenURL
    }

    public func authenticate(request: RestRequest, completionHandler: @escaping (RestRequest?, Error?) -> Void) {
        var request = request
        guard let data = (username + ":" + password).data(using: .utf8) else {
            completionHandler(nil, RestError.serializationError)
            return
        }
        let string = "Basic \(data.base64EncodedString())"
        request.headerParameters["Authorization"] = string
        completionHandler(request, nil)
    }

    public func authenticate(request: URLRequest, completionHandler: @escaping (URLRequest?, Error?) -> Void) {
        var request = request
        getToken {
            token, error in
            if let token = token {
                request.addValue(token, forHTTPHeaderField: "X-Watson-Authorization-Token")
                completionHandler(request, nil)
            } else {
                completionHandler(nil, error ?? RestError.failure(400, "Token Manager error"))
            }
        }
    }

    private func getToken(completionHandler: @escaping (String?, Error?) -> Void) {
        // request a new access token if not present
        guard let token = token else {
            requestToken(completionHandler: completionHandler)
            return
        }

        // use the existing, valid access token
        completionHandler(token, nil)
    }

    private func requestToken(completionHandler: @escaping (String?, Error?) -> Void) {

        guard let tokenURL = tokenURL else {
            completionHandler(nil, RestError.failure(400, "Websocket authentication requires tokenURL"))
            return
        }

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = RestRequest(
            session: session,
            authMethod: self,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: tokenURL,
            headerParameters: [:])

        request.responseString { response in
            switch response.result {
            case .success(let token):
                self.token = token
                completionHandler(token, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }

    /**
     Returns an NSError if the response/data represents an error. Otherwise, returns nil.

     - parameter response: an http response from the token url
     - parameter data: raw body data from the token url response
     */
    private func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> Error {
        // default error description
        let code = response.statusCode
        var message = "Token authentication failed."

        // update error description, if available
        do {
            let json = try JSON.decoder.decode([String: JSON].self, from: data)
            if case let .some(.string(description)) = json["description"] {
                message = description
            }
        } catch { /* no need to catch -- falls back to default description */ }

        return RestError.failure(code, message)
    }
}

/** Authenticate with an API key. */
public class APIKeyAuthentication: AuthenticationMethod {

    private let name: String
    private let key: String
    private let location: Location

    public enum Location {
        case header
        case query
    }

    public init(name: String, key: String, location: Location) {
        self.name = name
        self.key = key
        self.location = location
    }

    public func authenticate(request: RestRequest, completionHandler: @escaping (RestRequest?, Error?) -> Void) {
        var request = request
        switch location {
        case .header: request.headerParameters[name] = key
        case .query: request.queryItems.append(URLQueryItem(name: name, value: key))
        }
        completionHandler(request, nil)
    }

    // Dummy method
    public func authenticate(request: URLRequest, completionHandler: @escaping (URLRequest?, Error?) -> Void) {
        completionHandler(request, nil)
    }
}

/** Authenticate with a static IAM access token. */
public class IAMAccessToken: AuthenticationMethod {

    private let accessToken: String

    public init(accessToken: String) {
        self.accessToken = accessToken
    }

    public func authenticate(request: RestRequest, completionHandler: @escaping (RestRequest?, Error?) -> Void) {
        var request = request
        request.headerParameters["Authorization"] = "Bearer \(accessToken)"
        completionHandler(request, nil)
    }

    public func authenticate(request: URLRequest, completionHandler: @escaping (URLRequest?, Error?) -> Void) {
        var request = request
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        completionHandler(request, nil)
    }
}

/** Authenticate with an IAM API key. The API key is used to automatically retrieve and refresh access tokens. */
public class IAMAuthentication: AuthenticationMethod {

    private let apiKey: String
    private let url: String
    private var token: IAMToken?
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    public init(apiKey: String, url: String? = nil) {
        self.apiKey = apiKey
        if let url = url {
            self.url = url
        } else {
            self.url = "https://iam.bluemix.net/identity/token"
        }
        self.token = nil
    }

    internal func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> Error {
        let genericMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        return RestError.failure(response.statusCode, genericMessage)
    }

    public func authenticate(request: RestRequest, completionHandler: @escaping (RestRequest?, Error?) -> Void) {
        var request = request
        getToken { token, error in
            if let token = token {
                request.headerParameters["Authorization"] = "Bearer \(token.accessToken)"
                completionHandler(request, nil)
            } else {
                completionHandler(nil, error ?? RestError.failure(400, "Token Manager error"))
            }
        }
    }

    public func authenticate(request: URLRequest, completionHandler: @escaping (URLRequest?, Error?) -> Void) {
        var request = request
        getToken { token, error in
            if let token = token {
                request.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
                completionHandler(request, nil)
            } else {
                completionHandler(nil, error ?? RestError.failure(400, "Token Manager error"))
            }
        }
    }

    private func getToken(completionHandler: @escaping (IAMToken?, Error?) -> Void) {
        // request a new access token if not present
        guard let token = token, !token.isRefreshTokenExpired else {
            requestToken(completionHandler: completionHandler)
            return
        }

        // refresh the access token if it expired
        guard !token.isAccessTokenExpired else {
            refreshToken(completionHandler: completionHandler)
            return
        }

        // use the existing, valid access token
        completionHandler(token, nil)
    }

    private func requestToken(completionHandler: @escaping (IAMToken?, Error?) -> Void) {
        let headerParameters = ["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"]
        let form = ["grant_type=urn:ibm:params:oauth:grant-type:apikey", "apikey=\(apiKey)", "response_type=cloud_iam"]
        let request = RestRequest(
            session: session,
            authMethod: BasicAuthentication(username: "bx", password: "bx"),
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: url,
            headerParameters: headerParameters,
            messageBody: form.joined(separator: "&").data(using: .utf8)
        )
        request.responseObject { (response: RestResponse<IAMToken>) in
            switch response.result {
            case .success(let token):
                self.token = token
                completionHandler(token, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }

    private func refreshToken(completionHandler: @escaping (IAMToken?, Error?) -> Void) {
        guard let token = token else { completionHandler(nil, RestError.serializationError); return }
        let headerParameters = ["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"]
        let form = ["grant_type=refresh_token", "refresh_token=\(token.refreshToken)"]
        let request = RestRequest(
            session: session,
            authMethod: BasicAuthentication(username: "bx", password: "bx"),
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: url,
            headerParameters: headerParameters,
            messageBody: form.joined(separator: "&").data(using: .utf8)
        )
        request.responseObject { (response: RestResponse<IAMToken>) in
            switch response.result {
            case .success(let token):
                self.token = token
                completionHandler(token, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}

/** An IAM token. */
private struct IAMToken: Decodable {

    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let expiration: Int

    var isAccessTokenExpired: Bool {
        let buffer = 0.8
        let expirationDate = Date(timeIntervalSince1970: Double(expiration))
        let refreshDate = expirationDate.addingTimeInterval(-1.0 * (1.0 - buffer) * Double(expiresIn))
        return refreshDate.timeIntervalSinceNow <= 0
    }

    var isRefreshTokenExpired: Bool {
        let sevenDays: TimeInterval = 7 * 24 * 60 * 60
        let expirationDate = Date(timeIntervalSince1970: Double(expiration))
        let refreshExpirationDate = expirationDate.addingTimeInterval(sevenDays)
        return refreshExpirationDate.timeIntervalSinceNow <= 0
    }

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case expiration = "expiration"
    }
}
