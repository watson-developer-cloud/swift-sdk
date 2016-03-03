//
//  WatsonError.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 3/2/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation

func createError(domain: String, description: String) -> NSError {
    let code = -1
    let userInfo = [NSLocalizedDescriptionKey: description]
    let error = NSError(domain: domain, code: code, userInfo: userInfo)
    return error
}
