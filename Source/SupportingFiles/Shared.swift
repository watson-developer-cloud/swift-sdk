//
//  Shared.swift
//  WatsonDeveloperCloud
//
//  Created by Anthony Oliveri on 9/4/18.
//  Copyright © 2018 Glenn R. Fisher. All rights reserved.
//

import Foundation
import RestKit


/// Contains functionality and information common to all of the services
struct Shared {

    static let sdkVersion = "0.33.0"

    static func configureRestRequest() {
        RestRequest.sdkVersion = sdkVersion
    }
}
