/**
 * (C) Copyright IBM Corp. 2018, 2019.
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
import IBMSwiftSDKCore

// Typealias rest types
public typealias WatsonResponse = RestResponse
public typealias WatsonError = RestError
public typealias WatsonJSON = JSON

// Typealias Authenticators provided by the core
public typealias WatsonAuthenticator = Authenticator
public typealias WatsonIAMAuthenticator = IAMAuthenticator
public typealias WatsonBasicAuthenticator = BasicAuthenticator
public typealias WatsonCloudPakForDataAuthenticator = CloudPakForDataAuthenticator
public typealias WatsonTokenSourceAuthenticator = TokenSourceAuthenticator
public typealias WatsonBearerTokenAuthenticator = BearerTokenAuthenticator
public typealias WatsonNoAuthAuthenticator = NoAuthAuthenticator


/// Contains functionality and information common to all of the services
internal struct Shared {

    struct Constant {
        static let credentialsFileName = "ibm-credentials.env"
        static let serviceURL = "url"
        static let username = "username"
        static let password = "password"
        static let apiKey = "apikey"
        static let iamApiKey = "iam_apikey"
        static let iamURL = "iam_url"
        static let icpPrefix = "icp-"
    }

    static let sdkVersion = "3.2.0"

    /// The "User-Agent" header to be sent with every RestRequest
    static let userAgent: String? = {
        let sdk = "watson-apis-swift-sdk"

        let operatingSystem: String = {
            #if os(iOS)
            return "iOS"
            #elseif os(watchOS)
            return "watchOS"
            #elseif os(tvOS)
            return "tvOS"
            #elseif os(macOS)
            return "macOS"
            #elseif os(Linux)
            return "Linux"
            #else
            return "Unknown"
            #endif
        }()
        let operatingSystemVersion: String = {
            // swiftlint:disable:next identifier_name
            let os = ProcessInfo.processInfo.operatingSystemVersion
            return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
        }()
        return "\(sdk)/\(sdkVersion) \(operatingSystem)/\(operatingSystemVersion)"
    }()

    /// These headers must be sent with every request in order to collect SDK metrics
    static func getSDKHeaders(serviceName: String, serviceVersion: String, methodName: String) -> [String: String] {
        let serviceInfo = "service_name=\(serviceName);service_version=\(serviceVersion);operation_id=\(methodName);async=true"

        return [
            "X-IBMCloud-SDK-Analytics": serviceInfo,
        ]
    }
}

#if os(Linux)
extension Shared {

    /// Get all credentials for the given service from a credentials file (ibm-credentials.env)
    /// See the discussion below for an example of what the credentials file could look like.
    ///
    ///     VISUAL_RECOGNITION_APIKEY=1234abcd
    ///     VISUAL_RECOGNITION_URL=https://test.us-south.containers.cloud.ibm.com/visual-recognition/api
    ///     VISUAL_RECOGNITION_IAM_URL=https://cloud.ibm.com/iam
    ///     DISCOVERY_USERNAME=me
    ///     DISCOVERY_PASSWORD=hunter2
    static func extractCredentials(serviceName: String) -> [String: String]? {

        // first look for an env variable called IBM_CREDENTIALS_FILE
        // it should be the path to the file
        let credentialsFileName = ProcessInfo.processInfo.environment["IBM_CREDENTIALS_FILE"] ??
            Constant.credentialsFileName

        let credentialsFile = URL(fileURLWithPath: credentialsFileName)
        guard let fileLines = try? String(contentsOf: credentialsFile).components(separatedBy: .newlines) else {
            return nil
        }
        // Turn each credential into a key/value pair
        let serviceCredentials = fileLines
            .filter { $0.lowercased().starts(with: serviceName.lowercased()) }
            .reduce([:]) { (result, credentialLine) -> [String: String] in
                let credentials = credentialLine.split(separator: "=", maxSplits: 1)
                let lowerCaseKey = credentials[0].lowercased()
                let removalIndex = lowerCaseKey.index(lowerCaseKey.startIndex, offsetBy: serviceName.count + 1)
                let key = String(lowerCaseKey[removalIndex...])
                let value = String(credentials[1])

                return result.merging([key: value]) { (_, new) in new }
            }
        return serviceCredentials
    }

}
#endif
