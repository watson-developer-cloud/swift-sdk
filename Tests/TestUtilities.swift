/**
 * Copyright IBM Corporation 2018
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

import Foundation
import XCTest

let exampleURL = URL(string: "http://example.com")!

// MARK: - Messages used in XCTFail

let missingResultMessage = "Missing result from response"
let missingErrorMessage = "Expected error not received"
func unexpectedErrorMessage(_ error: Error) -> String {
    return "Received an unexpected error: \(error)"
}
func missingBodyMessage(_ error: Error) -> String {
    return "Missing or incorrect request body. \(error)"
}

// MARK: - Service instantiation

let accessToken = "my_access_token"
let versionDate = "2019-01-11"

// MARK: - Mocking requests

let dummyResponse = HTTPURLResponse(url: exampleURL, statusCode: 200, httpVersion: nil, headerFields: nil)!

/**
 * MockURLProtocol from WWDC 2018 Session 417 Testing Tips & Tricks
 */
class MockURLProtocol: URLProtocol {

    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // Don't delete this method!  Without it, your tests will crash
        // in com.apple.CFNetwork.CustomProtocols
    }

}


// MARK: - Analyzing request bodies

/**
 * Used to convert request httpBodyStream to Data
 */
extension Data {
    init(reading input: InputStream) {
        self.init()
        input.open()

        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            self.append(buffer, count: read)
        }
        buffer.deallocate()

        input.close()
    }
}

/**
 * Parse the body of a request as a multipart/form-data body and return a count of fields passed in the body
 */
func numberOfFieldsInMultiPartFormBody(request: URLRequest) -> Int? {
    guard let contentType = request.value(forHTTPHeaderField: "content-type") else {
        XCTFail("contentType header not present")
        return nil
    }
    XCTAssertTrue(contentType.lowercased().starts(with: "multipart/form-data"))
    guard let boundaryIndex = contentType.range(of: "boundary=")?.upperBound else {
        XCTFail("boundary string not present in contentType header")
        return nil
    }
    let boundary = String(contentType.suffix(from: boundaryIndex))
    guard let boundaryData = boundary.data(using: .utf8) else {
        XCTFail("content boundary")
        return nil
    }

    guard let contentLength = (request.value(forHTTPHeaderField: "content-length").flatMap { val in Int(val) }) else {
        XCTFail("contentLength header not present")
        return nil
    }

    guard let body = request.httpBodyStream else {
        XCTFail("request body not present")
        return nil
    }

    var bytesToRead = contentLength
    body.open()
    var bodyData = Data()
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bytesToRead)
    while body.hasBytesAvailable && bytesToRead > 0 {
        let read = body.read(buffer, maxLength: bytesToRead)
        bodyData.append(buffer, count: read)
        bytesToRead -= read
    }
    buffer.deallocate()
    body.close()

    var count = 0
    var rangeStart = bodyData.startIndex
    while true {
        if let boundaryRange = bodyData.range(of: boundaryData, options: [], in: rangeStart ..< bodyData.endIndex) {
            count += 1
            rangeStart = boundaryRange.upperBound
        } else {
            break
        }
    }

    // The number of form fields is one less than the number of boundary strings found
    return count-1
}
