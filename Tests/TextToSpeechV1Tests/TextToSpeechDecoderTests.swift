/**
 * (C) Copyright IBM Corp. 2019.
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

// swiftlint:disable function_body_length force_try force_unwrapping file_length

#if !os(Linux)

import XCTest
@testable import TextToSpeechV1

class TextToSpeechDecoderTests: XCTestCase {

    func testDecoder() {
        let filename = "audio"
        let fileExt = "ogg"
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: fileExt) else {
            XCTFail("Unable to locate \(filename).\(fileExt)")
            return
        }
        let fileData = try! Data(contentsOf: file)

        do {
            let decodedAudio = try TextToSpeechDecoder(audioData: fileData)
            let result = decodedAudio.pcmDataWithHeaders
            XCTAssertNotNil(result)
        } catch {
            XCTFail("TextToSpeechDecoder failed: \(error)")
        }
    }
}
#endif
