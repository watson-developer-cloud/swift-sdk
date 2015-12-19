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

class TextToSpeechTests: XCTestCase {
    
    var service: TextToSpeech!
    let playAudio = true

    let testString = "All the problems of the world could be solved if men were only willing to think."
    let germanString = "Alle Probleme der Welt könnten gelöst werden, wenn Männer waren nur bereit, zu denken."
    let ssmlString = "<speak xml:lang=\"En-US\" version=\"1.0\"><say-as interpret-as=\"letters\">Hello</say-as></speak>"
    
    let timeout: NSTimeInterval = 20.0
    
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
        
        guard let username = credentials["TextToSpeechUsername"] else {
            XCTFail("Unable to read TextToSpeech username.")
            return
        }
        
        guard let password = credentials["TextToSpeechPassword"] else {
            XCTFail("Unable to read TextToSpeech password.")
            return
        }
        
        if service == nil {
            service = TextToSpeech(username: username, password: password)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
    * Fetches the list of available voices from Watson
    **/
    func testListLanguages() {
      
        let voicesExpectation = expectationWithDescription("Get Voices")
        
        service.listVoices { voices, error in
            
            print(voices)
            
            XCTAssertNotNil(voices)
            XCTAssertGreaterThan(voices!.count, 6, "Expected at least 6 voices to be returned");
            
            voicesExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    /**
    * Fetches the synthesized speech back and decompresses the Opus audio
    **/
    func testSynthesize() {
        
        let synthExpectation = expectationWithDescription("Synthesize Audio")
    
        service.synthesize(testString) { data, error in
            
                print(error)
                XCTAssertNil(error)
                XCTAssertNotNil(data)
                XCTAssertGreaterThan(data!.length, 100, "Expecting the decompressed audio to be more than 100 bytes")
            
                synthExpectation.fulfill()
                
                // service.playAudio(engine, data: data)
           
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    /**
     Tests if the user specifies a voice that does not exist.
    **/
    func testSynthesizeIncorrectVoice() {
        let voice = "No voice"
        let synthIncorrectExpectation = expectationWithDescription("Synthesize Incorrect Voice Audio")
        
        service.synthesize(testString, voice: voice) {
            data, error in
            
            XCTAssertNotNil(error)
            
            if let error = error {
                XCTAssertEqual(error.code, 404)
            }
         
            synthIncorrectExpectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    /**
     Tests if the user specifies a voice that does not exist.
     **/
    func testSynthesizeEmptyString() {
        
        let synthEmptyExpectation = expectationWithDescription("Synthesize Incorrect Voice Audio")
        
        service.synthesize("") { data, error in
            
            XCTAssertNotNil(error)
            
            if let error = error {
                XCTAssertEqual(error.code, 404)
            }
            
            synthEmptyExpectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    /**
     Uses the AVAudioPlayer to play the WAV file
    */
    func testSynthAndPlay() {
        
        let synthPlayExpectation = expectationWithDescription("Synthesize Audio")
        
        service.synthesize(testString) {
            data, error in
            
            if let data = data {
            
                do {
                    let audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
    
                    if (self.playAudio) {
                        sleep(10)
                    }
                    
                    synthPlayExpectation.fulfill()
                    
                    
                } catch {
                    XCTAssertTrue(false, "Could not initialize the AVAudioPlayer with the received data.")
                }
                
            }
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    /**
     * Uses the AVAudioPlayer to play the WAV file in a German voice
     **/
    func testSynthAndPlayDieter() {
        
        let playExpectation = expectationWithDescription("Synthesize German Audio")
        let dieterVoice = "de-DE_DieterVoice"
        
        service.synthesize(germanString, voice: dieterVoice) {
            data, error in
            
            if let data = data {
                
                do {
                    let audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    
                   if (self.playAudio) {
                        sleep(10)
                    }
                    
                    playExpectation.fulfill()
                    
                    
                } catch {
                    XCTAssertTrue(false, "Could not initialize the AVAudioPlayer with the received data.")
                }
                
            }
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    /**
     Uses the AVAudioPlayer to play the WAV file using SSML advanced features.
     */
    func testSynthAndPlaySSML() {
        
        let synthPlaySSMLExpectation = expectationWithDescription("Synthesize Audio")

        service.synthesize(ssmlString) { data, error in
            
            if let data = data {
                
                do {
                    let audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    
                   if (self.playAudio) {
                        sleep(10)
                    }
                    
                    synthPlaySSMLExpectation.fulfill()
                    
                    
                } catch {
                    XCTAssertTrue(false, "Could not initialize the AVAudioPlayer with the received data.")
                }
                
            }
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
}
