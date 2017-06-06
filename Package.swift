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
        Target(name: "AlchemyDataNewsV1"),
        Target(name: "AlchemyLanguageV1"),
        Target(name: "AlchemyVisionV1"),
        Target(name: "ConversationV1"),
        Target(name: "DialogV1"),
        Target(name: "DiscoveryV1"),
        Target(name: "DocumentConversionV1"),
        Target(name: "LanguageTranslatorV2"),
        Target(name: "NaturalLanguageClassifierV1"),
        Target(name: "NaturalLanguageUnderstandingV1"),
        Target(name: "PersonalityInsightsV2"),
        Target(name: "PersonalityInsightsV3"),
        Target(name: "RelationshipExtractionV1Beta"),
        Target(name: "RetrieveAndRankV1"),
        Target(name: "ToneAnalyzerV3"),
        Target(name: "TradeoffAnalyticsV1"),
        Target(name: "VisualRecognitionV3"),
    ],
    dependencies: [
        .Package(url: "git@github.ibm.com:MIL/RestKit.git", majorVersion: 0)
    ],
    exclude: [
        "Source/SpeechToTextV1",
        "Source/SupportingFiles/Dependencies",
        "Source/TextToSpeechV1"
    ]
)
