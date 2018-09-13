//
//  SharedTests.swift
//  WatsonDeveloperCloud
//
//  Created by Anthony Oliveri on 9/13/18.
//  Copyright © 2018 IBM Corporation. All rights reserved.
//

import XCTest
import RestKit

class SharedTests: XCTestCase {

    func testGetAuthMethodFromBasicAuth() {
        let authMethod1 = Shared.getAuthMethod(username: "user", password: "password")
        XCTAssert(authMethod1 is BasicAuthentication)

        let authMethod2 = Shared.getAuthMethod(username: "apikey", password: "icp-s53f18as793f")
        XCTAssert(authMethod2 is BasicAuthentication)

        let authMethod3 = Shared.getAuthMethod(username: "apikey", password: "password")
        XCTAssert(authMethod3 is IAMAuthentication)
    }

    func testGetAuthMethodFromIAMAuth() {
        let authMethod1 = Shared.getAuthMethod(apiKey: "1234", iamURL: nil)
        XCTAssert(authMethod1 is IAMAuthentication)

        let authMethod2 = Shared.getAuthMethod(apiKey: "icp-as34567as45a76sdf", iamURL: nil)
        XCTAssert(authMethod2 is BasicAuthentication)
    }

    func testConfigureRestRequest() {
        Shared.configureRestRequest()
        let userAgent = RestRequest.userAgent
        XCTAssert(userAgent.contains(Shared.sdkVersion))

        #if os(iOS)
        XCTAssert(userAgent.contains("iOS"))
        #endif
    }
}
