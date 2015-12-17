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

extension Dialog {
    
    internal struct Constants {
        
        static let serviceURL = "https://gateway.watsonplatform.net/dialog/api"
        static let tokenURL = "https://gateway.watsonplatform.net/authorization/api/v1/token"
        static let errorDoman = "com.watsonplatform.dialog"
        
        // MARK: Content Operations
        static func content(dialogID: DialogID) -> String {
            return "/v1/dialogs/\(dialogID)/content"
        }
        static let dialogs = "/v1/dialogs"
        static func dialogID(dialogID: DialogID) -> String {
            return "/v1/dialogs/\(dialogID)"
        }
        
        // MARK: Conversation Operations
        static func conversation(dialogID: DialogID) -> String {
            return "/v1/dialogs/\(dialogID)/conversation"
        }
        
        // MARK: Profile Opeations
        static func profile(dialogID: DialogID) -> String {
            return "/v1/dialogs/\(dialogID)/profile"
        }
    }
}