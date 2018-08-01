//
//  TestUtilities.swift
//  WatsonDeveloperCloud
//
//  Created by Anthony Oliveri on 8/1/18.
//  Copyright © 2018 Glenn R. Fisher. All rights reserved.
//

import Foundation


// MARK: - Messages used in XCTFail

let missingResultMessage = "Missing result from response"
let missingErrorMessage = "Expected error not received"

func unexpectedErrorMessage(_ error: Error) -> String {
    return "Received an unexpected error: \(error)"
}
