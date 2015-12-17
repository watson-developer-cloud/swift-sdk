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

import XCTest
@testable import WatsonDeveloperCloud

class AuthenticationTests: XCTestCase {
    
    private let timeout: NSTimeInterval = 30.0
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFacebookOAuth() {
        
        let facebookExpectation: XCTestExpectation = expectationWithDescription("Facebook Authentication")
        
        // identify credentials file
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.pathForResource("Credentials", ofType: "plist") else {
            XCTFail("Unable to locate credentials file.")
            return
        }
        
        // load credentials from file
        let dict = NSDictionary(contentsOfFile: url)
        guard let credentials = dict as? Dictionary<String, String> else {
            XCTFail("Unable to read credentials file.")
            return
        }
        
        // read Dialog username
        guard let fbToken = credentials["FacebookOAuth"] else {
            XCTFail("Unable to read the Facebook OAuth token.")
            return
        }
        
        guard let tokenURL = credentials["FacebookOAuthURL"] else {
            XCTFail("Unable to read the token URL.")
            return
        }
        
        let fbAuthentication = FacebookAuthenticationStrategy(
            tokenURL: tokenURL,
            fbToken: fbToken
            )
        
        
        fbAuthentication.refreshToken {
            error in
            
                XCTAssertNotNil(fbAuthentication.token)
                XCTAssertNil(error)
            
                Log.sharedLogger.info("Received a Watson token \(fbAuthentication.token)")
            
                facebookExpectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(timeout) {
            error in XCTAssertNil(error, "Timeout")
        }

        
    }
    
    func testFacebookOAuthBadCredentials() {
        
        let facebookNegativeExpectation: XCTestExpectation =
            expectationWithDescription("Facebook Negative Authentication")
        
        // identify credentials file
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.pathForResource("Credentials", ofType: "plist") else {
            XCTFail("Unable to locate credentials file.")
            return
        }
        
        // load credentials from file
        let dict = NSDictionary(contentsOfFile: url)
        guard let credentials = dict as? Dictionary<String, String> else {
            XCTFail("Unable to read credentials file.")
            return
        }
        
        guard let tokenURL = credentials["FacebookOAuthURL"] else {
            XCTFail("Unable to read the token URL.")
            return
        }
        
        let fbAuthentication = FacebookAuthenticationStrategy(
            tokenURL: tokenURL,
            fbToken: "SomeBogusOAuthTokenGoesHere"
        )
        
        fbAuthentication.refreshToken {
            error in
            
            XCTAssertNil(fbAuthentication.token)
            XCTAssertNotNil(error)
            
            Log.sharedLogger.info("Received a Watson token \(fbAuthentication.token)")
            
            facebookNegativeExpectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(timeout) {
            error in XCTAssertNil(error, "Timeout")
        }
        
    }

    
}