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

class SpeechToTextTests: XCTestCase {
    
    var service: SpeechToText!
    var recorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    let timeout: NSTimeInterval = 30.0
    
    override func setUp() {
        super.setUp()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.pathForResource("Credentials", ofType: "plist") else {
            XCTFail("Unable to locate credentials file.")
            return
        }
        
        let dict = NSDictionary(contentsOfFile: url)
        guard let credentials = dict as? Dictionary<String, String> else {
            XCTFail("Unable to read credentials file.")
            return
        }
        
        guard let username = credentials["SpeechToTextUsername"] else {
            XCTFail("Unable to read SpeechToText username.")
            return
        }
        
        guard let password = credentials["SpeechToTextPassword"] else {
            XCTFail("Unable to read SpeechToText password.")
            return
        }
        
        if service == nil {
            service = SpeechToText(username: username, password: password)
        }
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
        } catch {
            XCTFail("Unable to configure AVAudioSession.")
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEncoding() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.URLForResource("test", withExtension: "raw") else {
            XCTFail("Unable to locate test.raw file.")
            return
        }
        guard let data = NSData(contentsOfURL: url) else {
            XCTFail("Unable to read text.raw file.")
            return
        }
        
        let encodedAudio = service.encodeOpus(data)
        XCTAssertLessThan(encodedAudio.length, data.length,
            "Encoded audio must be smaller than the original.")
    }
    
    func testSimpleFLACTranscription() {
        transcribe("SpeechSample", withExtension: "flac", format: .FLAC)
    }
    
    func testSimpleWAVTranscription() {
        transcribe("SpeechSample", withExtension: "wav", format: .WAV)
    }
    
    func testSimpleOGGTranscription() {
        transcribe("SpeechSample", withExtension: "ogg", format: .OPUS)
    }
    
    func transcribe(filename: String, withExtension: String, format: MediaType) {
        let expectation = expectationWithDescription("Testing transcribe.")
        
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.URLForResource(filename, withExtension: withExtension) else {
            XCTFail("Unable to locate SpeechSample.flac.")
            return
        }
        guard let audioData = NSData(contentsOfURL: url) else {
            XCTFail("Unable to read SpeechSample.flac.")
            return
        }
        
        service.transcribe(audioData, format: format) { response, error in
            guard let response = response else {
                XCTFail("Expected a non-nil response.")
                return
            }
            
            guard let results = response.results else {
                XCTFail("Expected a non-nil result.")
                return
            }
            
            XCTAssertGreaterThan(results.count, 0, "Must return more than zero results")
            
            guard let alternatives = results[0].alternatives else {
                XCTFail("Must return more than zero results.")
                return
            }
            
            XCTAssertGreaterThan(alternatives.count, 0, "Must return more than zero results")
            
            guard let transcript = alternatives[0].transcript else {
                XCTFail("Expected a non-nil transcript.")
                return
            }
            
            XCTAssertEqual(transcript, "several tornadoes touch down as a line of severe thunderstorms swept through Colorado on Sunday ")
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout) {
            error in XCTAssertNil(error, "Timeout")
        }
    }
    
    // func testContinuousRecording() {
    //     service.startListening()
    // }
    
    //    func testRecording() {
    //
    //        let recordExpectation = expectationWithDescription("Record")
    //
    //        let recordSettings = [
    //            // AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatLinearPCM),
    //            AVNumberOfChannelsKey: 1,
    //            AVSampleRateKey : 16000.0
    //        ]
    //
    //        let dirsPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    //        let docsDir = dirsPaths[0] as String
    //        let soundFilePath = docsDir + "/test.wav"
    //
    //        print("Saving recorded audio file in \(soundFilePath)")
    //        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool) -> Void
    //            in
    //            if granted {
    //                let soundFileURL = NSURL(string: soundFilePath)
    //
    //                if let soundFileURL = soundFileURL {
    //
    //                    do {
    //
    //                        self.recorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
    //
    //                        self.recorder.meteringEnabled = true
    //
    //                        // self.recorder.prepareToRecord()
    //                        self.recorder.recordForDuration(3.0)
    //
    //                        sleep(5)
    //
    //                        print(self.recorder.recording)
    //
    //                        self.recorder.stop()
    //
    //                        recordExpectation.fulfill()
    //
    //                    } catch {
    //
    //
    //                        XCTAssertTrue(false, "Could not create audio recorder")
    //                    }
    //                }
    //
    //            }
    //            
    //        })
    //        
    //        waitForExpectationsWithTimeout(timeout) {
    //            error in XCTAssertNil(error, "Timeout")
    //        }
    //    }
}
