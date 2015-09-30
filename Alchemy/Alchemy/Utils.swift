//
//  Utils.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/28/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

// ADD COMMENTS

let debug = true
/*

/**
Convert UIImage into base64

- parameter image: UIImage

- returns: base64 string
*/
func convertImageToBase64(image: UIImage) -> String {
    
    var imageData = UIImagePNGRepresentation(image)
    let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
    
    return base64String
    
}

/**
Convert base64 string into an UIImage

- parameter base64String:String

- returns: UIImage if there a now issues
*/
func convertBase64ToImage(base64String: String) -> UIImage {
    
    let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0) )
    
    var decodedimage = UIImage(data: decodedData!)

    return decodedimage!
    
}

*/


public func addOrUpdateQueryStringParameter(url: String, key: String, value: String?) -> String {
    if let components = NSURLComponents(string: url),
        var queryItems = (components.queryItems ?? []) as? [NSURLQueryItem] {
            // Key doesn't exist if reaches here
            if let v = value {
                // Add key to URL query string
                queryItems.append(NSURLQueryItem(name: key, value: v))
                components.queryItems = queryItems
                return components.string!
            }
    }
    
    return url
}


public func addQueryStringParameter(url: String, values: [String: String]) -> String {
    var newUrl = url
    
    for item in values {
        newUrl = addOrUpdateQueryStringParameter(newUrl, key: item.0, value: item.1)
    }
    
    return newUrl
}
