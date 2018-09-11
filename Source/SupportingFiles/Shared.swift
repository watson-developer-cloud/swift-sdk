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
struct Shared {

    static let sdkVersion = "0.33.1"

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
