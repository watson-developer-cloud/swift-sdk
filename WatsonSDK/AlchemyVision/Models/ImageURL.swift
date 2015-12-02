//
//  ImageURL.swift
//  WatsonSDK
//
//  Created by Vincent Herrin on 11/28/15.
//  Copyright © 2015 IBM Watson Developer Cloud. All rights reserved.
//

import Foundation

public struct ImageURL {
    
    let path: String
    let url: NSURL?
    
    public init(path: String, url: NSURL) {
        self.path = path
        self.url = url
    }
}