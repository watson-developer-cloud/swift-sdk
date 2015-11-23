//
//  SpeechToTextTests.swift
//  SpeechToTextTests
//
//  Created by Glenn Fisher on 11/6/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import XCTest
@testable import WatsonSDK

class SpeechToTextTests: XCTestCase {
    
    private let service = SpeechToText()
    private var inputText: String?
    private let timeout: NSTimeInterval = 30.0
    
    var recorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                service.setUsernameAndPassword(dict["SpeechToTextUsername"]!, password: dict["SpeechToTextPassword"]!)
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            
        } catch {
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEncoding() {
        let url = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "raw")
        if let url = url
        {
            if let data = NSData(contentsOfURL: url)
            {
                let encodedAudio = service.encodeOpus( data)
                
                XCTAssertLessThan(encodedAudio.length, data.length, "Encoded audio must be smaller than the original.")
            } else {
                XCTAssert(true, "Could not load test PCM file")
            }
            
        }
    
    }
    
    func testRecording() {
    
        let recordExpectation = expectationWithDescription("Record")
        
        let recordSettings = [
            AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatLinearPCM),
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey : 16000.0
        ]
        
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool) -> Void
            in
            if granted {
                let soundFileURL = NSURL(string: "test.raw")
                
                if let soundFileURL = soundFileURL {
                    
                    do {
                        
                        self.recorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
                    
                        self.recorder.meteringEnabled = true
                        
                        self.recorder.delegate = self.service
                        // self.recorder.prepareToRecord()
                        self.recorder.recordForDuration(3.0)
                        
                        sleep(5)
                        
                        print(self.recorder.recording)
                        
                        self.recorder.stop()
                        
                        recordExpectation.fulfill()
                        
                    } catch {
                        
                        
                        XCTAssertTrue(false, "Could not create audio recorder")
                    }
                }

            }
            
        })
        
        waitForExpectationsWithTimeout(timeout) {
            error in XCTAssertNil(error, "Timeout")
        }
    }
    
    
    func testWebsockets() {
        let expectation = expectationWithDescription("WebSockets")
        service.transcribe(NSBundle(forClass: self.dynamicType).URLForResource("SpeechSample", withExtension: "flac")!) {
            transcription in
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(timeout) {
            error in XCTAssertNil(error, "Timeout")
        }
    }
    
}
