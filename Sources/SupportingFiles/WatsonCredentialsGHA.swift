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
    static let AssistantAPIKey = ProcessInfo.processInfo.environment["ASSISTANT_APIKEY"] ?? "<no_apikey>"
    static let AssistantUsername = "your-username-here"
    static let AssistantPassword = "your-password-here"
    static let AssistantURL = ProcessInfo.processInfo.environment["ASSISTANT_URL"]
    static let AssistantWorkspace = "cogntive-car-sample-workspace"

    static let AssistantV2Username = "your-username-here"
    static let AssistantV2Password = "your-password-here"
    static let AssistantV2URL = ProcessInfo.processInfo.environment["ASSISTANT_URL"]
    static let AssistantV2ID = ProcessInfo.processInfo.environment["ASSISTANT_ASSISTANT_ID"]
    static let AssistantV2PremiumAPIKey: String? = nil
    static let AssistantV2PremiumURL: String? = nil
    static let AssistantV2PremiumAssistantID: String? = nil

    static let DiscoveryAPIKey = ProcessInfo.processInfo.environment["DISCOVERY_APIKEY"] ?? "<no_apikey>"
    static let DiscoveryUsername = "your-username-here"
    static let DiscoveryPassword = "your-password-here"
    static let DiscoveryURL = ProcessInfo.processInfo.environment["DISCOVERY_URL"]

    static let DiscoveryCPDToken = "your-token-here"
    static let DiscoveryCPDURL = "your-url-here"

    static let DiscoveryV2APIKey = ProcessInfo.processInfo.environment["DISCOVERY_V2_APIKEY"] ?? "<no_apikey>"
    static let DiscoveryV2ServiceURL = ProcessInfo.processInfo.environment["DISCOVERY_V2_URL"]
    static let DiscoveryV2ProjectID = ProcessInfo.processInfo.environment["DISCOVERY_V2_PROJECT_ID"]
    static let DiscoveryV2CollectionID = ProcessInfo.processInfo.environment["DISCOVERY_V2_COLLECTION_ID"]

    static let DiscoveryV2CPDUsername = "your-username-here"
    static let DiscoveryV2CPDPassword = "your-password-here"
    static let DiscoveryV2CPDURL = "your-url-here"
    static let DiscoveryV2CPDServiceURL = "your-serviceurl-here"
    static let DiscoveryV2CPDTestProjectID = "your-projectid-here"
    static let DiscoveryV2CPDTestCollectionID = "your-collectioid-here"

    static let LanguageTranslatorUsername = "your-username-here"
    static let LanguageTranslatorPassword = "your-password-here"
    static let LanguageTranslatorV3APIKey = ProcessInfo.processInfo.environment["LANGUAGE_TRANSLATOR_APIKEY"] ?? "<no_apikey>"
    static let LanguageTranslatorV3Username = "your-username-here"
    static let LanguageTranslatorV3Password = "your-password-here"
    static let LanguageTranslatorV3URL = ProcessInfo.processInfo.environment["LANGUAGE_TRANSLATOR_URL"]

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
}
