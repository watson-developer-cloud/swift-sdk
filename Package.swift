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

import PackageDescription

let package = Package(
  name: "WatsonDeveloperCloud",
    targets: [
        Target(name: "RestKit"),
        Target(name: "AlchemyDataNewsV1",            dependencies: [.Target(name: "RestKit")]),
        Target(name: "AlchemyLanguageV1",            dependencies: [.Target(name: "RestKit")]),
        Target(name: "AlchemyVisionV1",              dependencies: [.Target(name: "RestKit")]),
        Target(name: "ConversationV1",               dependencies: [.Target(name: "RestKit")]),
        Target(name: "DialogV1",                     dependencies: [.Target(name: "RestKit")]),
        Target(name: "DiscoveryV1",                  dependencies: [.Target(name: "RestKit")]),
        Target(name: "DocumentConversionV1",         dependencies: [.Target(name: "RestKit")]),
        Target(name: "LanguageTranslatorV2",         dependencies: [.Target(name: "RestKit")]),
        Target(name: "NaturalLanguageClassifierV1",  dependencies: [.Target(name: "RestKit")]),
        Target(name: "NaturalLanguageUnderstandingV1", dependencies: [.Target(name: "RestKit")]),
        Target(name: "PersonalityInsightsV2",        dependencies: [.Target(name: "RestKit")]),
        Target(name: "PersonalityInsightsV3",        dependencies: [.Target(name: "RestKit")]),
        Target(name: "RelationshipExtractionV1Beta", dependencies: [.Target(name: "RestKit")]),
        Target(name: "RetrieveAndRankV1",            dependencies: [.Target(name: "RestKit")]),
        Target(name: "ToneAnalyzerV3",               dependencies: [.Target(name: "RestKit")]),
        Target(name: "TradeoffAnalyticsV1",          dependencies: [.Target(name: "RestKit")]),
        Target(name: "VisualRecognitionV3",          dependencies: [.Target(name: "RestKit")]),
    ],
    dependencies: [
    ],
    exclude: [
        "Source/SpeechToTextV1",
        "Source/SupportingFiles/Dependencies",
        "Source/TextToSpeechV1"
    ]
)
