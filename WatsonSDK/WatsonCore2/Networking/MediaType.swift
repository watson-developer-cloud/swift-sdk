//
//  MediaType.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/17/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation

/// Common MIME media types for use in HTTP headers.
public enum MediaType: String {
    case Plain = "text/plain"
    case HTML = "text/html"
    case JSON = "application/json"
    case CSV = "text/csv"
    case OctetStream = "application/octet-stream"
    case WDSJSON = "application/wds+json"
    case WDSXML = "application/wds+xml"
}