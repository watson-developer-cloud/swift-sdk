/**
 * (C) Copyright IBM Corp. 2016, 2020.
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
import TextToSpeechV1
import AVFoundation

class TextToSpeechPlaybackTests: XCTestCase {

    private var textToSpeech: TextToSpeech!
    private let playAudio = true
    private let text = "Swift at IBM is awesome. You should try it!"

    private let ssmlString = "<speak xml:lang=\"En-US\" version=\"1.0\">" +
    "<say-as interpret-as=\"letters\">Hello</say-as></speak>"
    private let failedToInitializeAudioPlayerMessage = "Failed to initialize an AVAudioPlayer with the received data"

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateTextToSpeech()
    }

    /** Instantiate Text to Speech instance. */
    func instantiateTextToSpeech() {

        let authenticator = WatsonIAMAuthenticator.init(apiKey: WatsonCredentials.TextToSpeechAPIKey)
        textToSpeech = TextToSpeech(authenticator: authenticator)

        if let url = WatsonCredentials.TextToSpeechURL {
            textToSpeech.serviceURL = url
        }
        textToSpeech.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        textToSpeech.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 10.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    /** Synthesize text to spoken audio using the default parameters. */
    func testSynthesizeDefault() {
        let description = "Synthesize text to spoken audio using the default parameters."
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text: text, accept: "audio/wav") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let data = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThan(data.count, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(3)
                }
            } catch {
                XCTFail(self.failedToInitializeAudioPlayerMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testSynthesizeAllVoices() {
        let voices: [String : String] = [
            "ar-AR_OmarVoice": "تقوم خدمة I B M النص إلى خدمة الكلام بتحويل النص المكتوب إلى صوت طبيعي في مجموعة متنوعة من اللغات والأصوات.",
            "pt-BR_IsabelaVoice": "Consciente do seu patrimônio espiritual e moral, a União é fundamentada nos valores indivisíveis ",
            "pt-BR_IsabelaV3Voice": "Consciente do seu patrimônio espiritual e moral, a União é fundamentada nos valores indivisíveis ",
            "zh-CN_LiNaVoice": "基于海量数据的云计算、大数据、人工智能、区块链等新兴技术",
            "zh-CN_WangWeiVoice": "基于海量数据的云计算、大数据、人工智能、区块链等新兴技术",
            "zh-CN_ZhangJingVoice": "基于海量数据的云计算、大数据、人工智能、区块链等新兴技术",
            "nl-NL_EmmaVoice": "In dem Bewusstsein ihres geistig-religiösen und sittlichen Erbes ",
            "nl-NL_LiamVoice": "In dem Bewusstsein ihres geistig-religiösen und sittlichen Erbes ",
            "en-GB_KateVoice": "Conscious of its spiritual and moral heritage, the Union is founded on the indivisible,",
            "en-GB_KateV3Voice": "Conscious of its spiritual and moral heritage, the Union is founded on the indivisible,",
            "en-US_AllisonVoice": "Conscious of its spiritual and moral heritage, the Union is founded on the indivisible,",
            "en-US_AllisonV3Voice": "Conscious of its spiritual and moral heritage, the Union is founded on the indivisible,",
            "en-US_LisaVoice": "Conscious of its spiritual and moral heritage, the Union is founded on the indivisible,",
            "en-US_LisaV3Voice": "Conscious of its spiritual and moral heritage, the Union is founded on the indivisible,",
            "en-US_MichaelVoice": "Conscious of its spiritual and moral heritage, the Union is founded on the indivisible,",
            "en-US_MichaelV3Voice": "Conscious of its spiritual and moral heritage, the Union is founded on the indivisible,",
            "fr-FR_ReneeVoice": "Consciente de son patrimoine spirituel et moral, l'Union",
            "fr-FR_ReneeV3Voice": "Consciente de son patrimoine spirituel et moral, l'Union",
            "de-DE_BirgitVoice": "In dem Bewusstsein ihres geistig-religiösen und sittlichen",
            "de-DE_BirgitV3Voice": "In dem Bewusstsein ihres geistig-religiösen und sittlichen",
            "de-DE_DieterVoice": "In dem Bewusstsein ihres geistig-religiösen und sittlichen",
            "de-DE_DieterV3Voice": "In dem Bewusstsein ihres geistig-religiösen und sittlichen",
            "it-IT_FrancescaVoice": "L'Unione contribuisce alla salvaguardia e allo sviluppo di questi valori comuni nel rispetto della diversità delle culture e delle tradizioni dei popoli d'Europa",
            "it-IT_FrancescaV3Voice": "L'Unione contribuisce alla salvaguardia e allo sviluppo di questi valori comuni nel rispetto della diversità delle culture e delle tradizioni dei popoli d'Europa",
            "ja-JP_EmiVoice": "こちらでは配送手続きのご予約・変更を承っております",
            "ja-JP_EmiV3Voice": "こちらでは配送手続きのご予約・変更を承っております",
            "es-ES_EnriqueVoice": "Consciente de su patrimonio espiritual y moral, la Unión está ",
            "es-ES_EnriqueV3Voice": "Consciente de su patrimonio espiritual y moral, la Unión está ",
            "es-ES_LauraVoice": "Consciente de su patrimonio espiritual y moral, la Unión está ",
            "es-ES_LauraV3Voice": "Consciente de su patrimonio espiritual y moral, la Unión está ",
            "es-LA_SofiaVoice": "Consciente de su patrimonio espiritual y moral, la Unión está ",
            "es-LA_SofiaV3Voice": "Consciente de su patrimonio espiritual y moral, la Unión está ",
            "es-US_SofiaVoice": "Consciente de su patrimonio espiritual y moral, la Unión está ",
            "es-US_SofiaV3Voice": "Consciente de su patrimonio espiritual y moral, la Unión está ß"
        ]
            
        // test all voices
        for (voice, sampleText) in voices {
            let voiceDescription = "Test of the \(voice) voice."
            let voiceExpectation = self.expectation(description: voiceDescription)
            
            textToSpeech.synthesize(text: sampleText, accept: "audio/wav", voice: voice) {
                response, error in
                
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                
                guard let data = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                
                XCTAssertGreaterThan(data.count, 0)
                
                do {
                    let audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    if self.playAudio {
                        sleep(3)
                    }
                } catch {
                    XCTFail(self.failedToInitializeAudioPlayerMessage)
                }
                voiceExpectation.fulfill()
            }
            
            waitForExpectations()
        }
    }

    /** Synthesize SSML to spoken audio. */
    func testSynthesizeSSML() {
        let description = "Synthesize SSML to spoken audio."
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text: ssmlString, accept: "audio/wav") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let data = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThan(data.count, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(1)
                }
            } catch {
                XCTFail(self.failedToInitializeAudioPlayerMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // This test works when you run it individually, but for some reason, running it after the
    // testSynthesizeFlac() method causes this one to fail. The audio types aren't updated somehow,
    // and the service seems to think we are still requesting .flac instead of .opus.
    /** Synthesize text to spoken audio in Opus format. */
    func testSynthesizeOpus() {
        let description = "Synthesize text to spoken audio in Opus format."
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text: text, accept: "audio/ogg;codecs=opus") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let data = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThan(data.count, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(3)
                }
            } catch {
                XCTFail("Failed to create audio player.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
#endif
