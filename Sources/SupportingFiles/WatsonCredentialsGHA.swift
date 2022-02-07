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
import Foundation

struct WatsonCredentials {
    static let AssistantAPIKey: String? = "your-api-key-here" // set to nil to use basic auth
    static let AssistantUsername = "your-username-here"
    static let AssistantPassword = "your-password-here"
    static let AssistantURL: String? = nil
    static let AssistantWorkspace = "cogntive-car-sample-workspace"

    static let AssistantV2Username = "your-username-here"
    static let AssistantV2Password = "your-password-here"
    static let AssistantV2URL: String? = nil
    static let AssistantV2ID = "cognitive-car-sample-id"

    static let DiscoveryAPIKey: String? = "your-api-key-here" // set to nil to use basic auth
    static let DiscoveryUsername = "your-username-here"
    static let DiscoveryPassword = "your-password-here"
    static let DiscoveryURL: String? = nil

    static let LanguageTranslatorUsername = "your-username-here"
    static let LanguageTranslatorPassword = "your-password-here"
    static let LanguageTranslatorV3APIKey = ProcessInfo.processInfo.environment["LANGUAGE_TRANSLATOR_APIKEY"] ?? "<no_apikey>"
    static let LanguageTranslatorV3Username = "your-username-here"
    static let LanguageTranslatorV3Password = "your-password-here"
    static let LanguageTranslatorV3URL = ProcessInfo.processInfo.environment["LANGUAGE_TRANSLATOR_URL"]

    static let NaturalLanguageClassifierAPIKey = ProcessInfo.processInfo.environment["NATURAL_LANGUAGE_CLASSIFIER_APIKEY"] ?? "<no_apikey>"
    static let NaturalLanguageClassifierUsername = "your-username-here"
    static let NaturalLanguageClassifierPassword = "your-password-here"
    static let NaturalLanguageClassifierURL = ProcessInfo.processInfo.environment["NATURAL_LANGUAGE_CLASSIFIER_URL"]

    static let NaturalLanguageUnderstandingAPIKey = ProcessInfo.processInfo.environment["NATURAL_LANGUAGE_UNDERSTANDING_APIKEY"] ?? "<no_apikey>"
    static let NaturalLanguageUnderstandingUsername = "your-username-here"
    static let NaturalLanguageUnderstandingPassword = "your-password-here"
    static let NaturalLanguageUnderstandingURL = ProcessInfo.processInfo.environment["NATURAL_LANGUAGE_UNDERSTANDING_URL"]

    static let SpeechToTextAPIKey = ProcessInfo.processInfo.environment["SPEECH_TO_TEXT_APIKEY"] ?? "<no_apikey>"
    static let SpeechToTextUsername = "your-username-here"
    static let SpeechToTextPassword = "your-password-here"
    static let SpeechToTextURL = ProcessInfo.processInfo.environment["SPEECH_TO_TEXT_URL"]

    static let TextToSpeechAPIKey = ProcessInfo.processInfo.environment["TEXT_TO_SPEECH_APIKEY"] ?? "<no_apikey>"
    static let TextToSpeechUsername = "your-username-here"
    static let TextToSpeechPassword = "your-password-here"
    static let TextToSpeechURL = ProcessInfo.processInfo.environment["TEXT_TO_SPEECH_URL"]

    static let ToneAnalyzerAPIKey = ProcessInfo.processInfo.environment["TONE_ANALYZER_APIKEY"] ?? "<no_apikey>"
    static let ToneAnalyzerUsername = "your-username-here"
    static let ToneAnalyzerPassword = "your-password-here"
    static let ToneAnalyzerURL = ProcessInfo.processInfo.environment["TONE_ANALYZER_URL"]
}
