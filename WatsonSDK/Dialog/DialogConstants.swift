//
//  DialogConstants.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/19/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation

extension Dialog {
    
    internal struct Constants {
        
        static let serviceURL = "https://gateway.watsonplatform.net/dialog/api"
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