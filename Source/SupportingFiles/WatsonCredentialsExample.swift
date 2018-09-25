/**
 * Copyright IBM Corporation 2016
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

    static let ConversationUsername = "your-username-here"
    static let ConversationPassword = "your-password-here"
    static let ConversationWorkspace = "cogntive-car-sample-workspace"

    static let DiscoveryAPIKey: String? = "your-api-key-here" // set to nil to use basic auth
    static let DiscoveryUsername = "your-username-here"
    static let DiscoveryPassword = "your-password-here"
    static let DiscoveryURL: String? = nil

    static let LanguageTranslatorUsername = "your-username-here"
    static let LanguageTranslatorPassword = "your-password-here"

    static let LanguageTranslatorV3APIKey: String? = "your-api-key-here" // set to nil to use basic auth
    static let LanguageTranslatorV3Username = "your-username-here"
    static let LanguageTranslatorV3Password = "your-password-here"
    static let LanguageTranslatorV3URL: String? = nil

    static let NaturalLanguageClassifierAPIKey: String? = "your-api-key-here" // set to nil to use basic auth
    static let NaturalLanguageClassifierUsername = "your-username-here"
    static let NaturalLanguageClassifierPassword = "your-password-here"
    static let NaturalLanguageClassifierURL: String? = nil

    static let NaturalLanguageUnderstandingAPIKey: String? = "your-api-key-here" // set to nil to use basic auth
    static let NaturalLanguageUnderstandingUsername = "your-username-here"
    static let NaturalLanguageUnderstandingPassword = "your-password-here"
    static let NaturalLanguageUnderstandingURL: String? = nil

    static let PersonalityInsightsAPIKey: String? = "your-api-key-here" // set to nil to use basic auth
    static let PersonalityInsightsUsername = "your-username-here"
    static let PersonalityInsightsPassword = "your-password-here"
    static let PersonalityInsightsV3URL: String? = nil

    static let SpeechToTextAPIKey: String? = "your-api-key-here" // set to nil to use basic auth
    static let SpeechToTextUsername = "your-username-here"
    static let SpeechToTextPassword = "your-password-here"
    static let SpeechToTextURL: String? = nil

    static let TextToSpeechAPIKey: String? = "your-api-key-here" // set to nil to use basic auth
    static let TextToSpeechUsername = "your-username-here"
    static let TextToSpeechPassword = "your-password-here"
    static let TextToSpeechURL: String? = nil

    static let ToneAnalyzerAPIKey: String? = "your-api-key-here" // set to nil to use basic auth
    static let ToneAnalyzerUsername = "your-username-here"
    static let ToneAnalyzerPassword = "your-password-here"
    static let ToneAnalyzerURL: String? = nil

    static let VisualRecognitionAPIKey: String? = "your-api-key-here" // set to nil to use Legacy API Key
    static let VisualRecognitionLegacyAPIKey = "your-api-key-here"
    static let VisualRecognitionURL: String? = nil
    static let VisualRecognitionClassifierID = "carsvstrucks-classifier"
}
