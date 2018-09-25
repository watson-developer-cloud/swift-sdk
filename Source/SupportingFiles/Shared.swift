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
import RestKit

/// Contains functionality and information common to all of the services
internal struct Shared {

    static let sdkVersion = "0.35.0"
    static let apiKey = "apikey"
    static let icpPrefix = "icp-"

    /// For Basic Authentication, switch to using IAM tokens for "apikey" usernames,
    /// but only for api keys that are not for ICP (which currently does not support IAM token authentication)
    static func getAuthMethod(username: String, password: String) -> AuthenticationMethod {
        if username == Shared.apiKey && !password.starts(with: Shared.icpPrefix) {
            return IAMAuthentication(apiKey: password, url: nil)
        } else {
            return BasicAuthentication(username: username, password: password)
        }
    }

    /// For IAM Authentication, switch to using Basic Authentication for ICP api keys
    /// This is a workaround that is needed until ICP (IBM Cloud Private) supports IAM tokens
    static func getAuthMethod(apiKey: String, iamURL: String?) -> AuthenticationMethod {
        if apiKey.starts(with: Shared.icpPrefix) {
            return BasicAuthentication(username: Shared.apiKey, password: apiKey)
        } else {
            return IAMAuthentication(apiKey: apiKey, url: iamURL)
        }
    }

    /// RestKit sends a "User-Agent" header with every RestRequest
    /// This sets the value of that header, which includes the current version of the Swift SDK
    static func configureRestRequest() {
        RestRequest.userAgent = {
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
    }
}
