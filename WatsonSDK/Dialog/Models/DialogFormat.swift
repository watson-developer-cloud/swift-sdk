//
//  DialogFormat.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/21/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation

extension Dialog {
    
    public enum DialogFormat: String {
        
        case OctetStream = "application/octet-stream"
        case WDSJSON = "application/wds+json"
        case WDSXML = "application/wds+xml"
        
        var mediaType: MediaType { return MediaType(rawValue: rawValue)! }
    }
}