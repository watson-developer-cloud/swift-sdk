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

@testable import WatsonSDK

class TextToSpeechTests: XCTestCase {
    
    // Text to Speech Service
    private var service:TextToSpeech?
    
    
    private let playAudio = true
    
    // Phrase used for testing
    let testString = "All the problems of the world could be solved if men were only willing to think."
    
    let germanString = "Alle Probleme der Welt könnten gelöst werden, wenn Männer waren nur bereit, zu denken."
    
    let ssmlString = "<speak xml:lang=\"En-US\" version=\"1.0\"><say-as interpret-as=\"letters\">Hello</say-as></speak>"
    
    /// Timeout for an asynchronous call to return before failing the unit test
    private let timeout: NSTimeInterval = 20.0
    
    override func setUp() {
        
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                
                    let username = dict["TextToSpeechUsername"]
                    let password = dict["TextToSpeechPassword"]
                    
                    let basicAuth = BasicAuthenticationStrategy(
                        tokenURL: "https://stream.watsonplatform.net/authorization/api/v1/token",
                        serviceURL: "https://stream.watsonplatform.net/text-to-speech/api",
                        username: username!,
                        password: password!)
                    
                    service = TextToSpeech(authStrategy: basicAuth)
                
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
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
        
        service!.listVoices({
            voices, error in
            
            print(voices)
            
            XCTAssertGreaterThan(voices.count, 6, "Expected at least 6 voices to be returned");
            
            voicesExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    /**
    * Fetches the synthesized speech back and decompresses the Opus audio
    **/
    func testSynthesize() {
        
        let synthExpectation = expectationWithDescription("Synthesize Audio")
    
        service!.synthesize(testString, oncompletion: {
            data, error in
            
                print(error)
                XCTAssertNil(error)
                XCTAssertNotNil(data)
                XCTAssertGreaterThan(data!.length, 100, "Expecting the decompressed audio to be more than 100 bytes")
            
                synthExpectation.fulfill()
                
                // service.playAudio(engine, data: data)
           
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    /**
     Tests if the user specifies a voice that does not exist.
    **/
//    func testSynthesizeIncorrectVoice() {
//        let voice = "No voice"
//        let synthIncorrectExpectation = expectationWithDescription("Synthesize Incorrect Voice Audio")
//        
//        service!.synthesize(testString, voice: voice, oncompletion: {
//            data, error in
//            
//            XCTAssertNotNil(error)
//            
//            if let error = error {
//                XCTAssertEqual(error.code, 404)
//            }
//         
//            synthIncorrectExpectation.fulfill()
//            
//        })
//        
//        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
//    }
    
    /**
     Tests if the user specifies a voice that does not exist.
     **/
//    func testSynthesizeEmptyString() {
//        
//        let synthEmptyExpectation = expectationWithDescription("Synthesize Incorrect Voice Audio")
//        
//        service!.synthesize("", oncompletion: {
//            data, error in
//            
//            XCTAssertNotNil(error)
//            
//            if let error = error {
//                XCTAssertEqual(error.code, 404)
//            }
//            
//            synthEmptyExpectation.fulfill()
//            
//        })
//        
//        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
//    }
    
    /**
     Uses the AVAudioPlayer to play the WAV file
    */
//    func testSynthAndPlay() {
//        
//        let synthPlayExpectation = expectationWithDescription("Synthesize Audio")
//        
//        service!.synthesize(testString, oncompletion: {
//            data, error in
//            
//            if let data = data {
//            
//                do {
//                    let audioPlayer = try AVAudioPlayer(data: data)
//                    audioPlayer.prepareToPlay()
//                    audioPlayer.play()
//    
//                    if (self.playAudio) {
//                        sleep(10)
//                    }
//                    
//                    synthPlayExpectation.fulfill()
//                    
//                    
//                } catch {
//                    XCTAssertTrue(false, "Could not initialize the AVAudioPlayer with the received data.")
//                }
//                
//            }
//            
//        })
//        
//        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
//    }
//    
//    /**
//     * Uses the AVAudioPlayer to play the WAV file in a German voice
//     **/
//    func testSynthAndPlayDieter() {
//        
//        let playExpectation = expectationWithDescription("Synthesize German Audio")
//        let dieterVoice = "de-DE_DieterVoice"
//        
//        service!.synthesize(germanString, voice: dieterVoice,
//            oncompletion: {
//            data, error in
//            
//            if let data = data {
//                
//                do {
//                    let audioPlayer = try AVAudioPlayer(data: data)
//                    audioPlayer.prepareToPlay()
//                    audioPlayer.play()
//                    
//                   if (self.playAudio) {
//                        sleep(10)
//                    }
//                    
//                    playExpectation.fulfill()
//                    
//                    
//                } catch {
//                    XCTAssertTrue(false, "Could not initialize the AVAudioPlayer with the received data.")
//                }
//                
//            }
//            
//        })
//        
//        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
//    }
//    
//    /**
//     Uses the AVAudioPlayer to play the WAV file using SSML advanced features.
//     */
//    func testSynthAndPlaySSML() {
//        
//        let synthPlaySSMLExpectation = expectationWithDescription("Synthesize Audio")
//        
//        
//        
//        
//        service!.synthesize(ssmlString, oncompletion: {
//            data, error in
//            
//            if let data = data {
//                
//                do {
//                    let audioPlayer = try AVAudioPlayer(data: data)
//                    audioPlayer.prepareToPlay()
//                    audioPlayer.play()
//                    
//                   if (self.playAudio) {
//                        sleep(10)
//                    }
//                    
//                    synthPlaySSMLExpectation.fulfill()
//                    
//                    
//                } catch {
//                    XCTAssertTrue(false, "Could not initialize the AVAudioPlayer with the received data.")
//                }
//                
//            }
//            
//        })
//        
//        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
//    }


    
}
