// swift-tools-version:4.0

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
    products: [
        .library(name: "AlchemyDataNewsV1", targets: ["AlchemyDataNewsV1"]),
        .library(name: "AlchemyLanguageV1", targets: ["AlchemyLanguageV1"]),
        .library(name: "AlchemyVisionV1", targets: ["AlchemyVisionV1"]),
        .library(name: "ConversationV1", targets: ["ConversationV1"]),
        .library(name: "DialogV1", targets: ["DialogV1"]),
        .library(name: "DiscoveryV1", targets: ["DiscoveryV1"]),
        .library(name: "DocumentConversionV1", targets: ["DocumentConversionV1"]),
        .library(name: "LanguageTranslatorV2", targets: ["LanguageTranslatorV2"]),
        .library(name: "NaturalLanguageClassifierV1", targets: ["NaturalLanguageClassifierV1"]),
        .library(name: "NaturalLanguageUnderstandingV1", targets: ["NaturalLanguageUnderstandingV1"]),
        .library(name: "PersonalityInsightsV2", targets: ["PersonalityInsightsV2"]),
        .library(name: "PersonalityInsightsV3", targets: ["PersonalityInsightsV3"]),
        .library(name: "RelationshipExtractionV1Beta", targets: ["RelationshipExtractionV1Beta"]),
        .library(name: "RetrieveAndRankV1", targets: ["RetrieveAndRankV1"]),
        .library(name: "ToneAnalyzerV3", targets: ["ToneAnalyzerV3"]),
        .library(name: "TradeoffAnalyticsV1", targets: ["TradeoffAnalyticsV1"]),
        .library(name: "VisualRecognitionV3", targets: ["VisualRecognitionV3"]),
    ],
    targets: [
        .target(name: "RestKit", dependencies: []),
        .target(name: "AlchemyDataNewsV1", dependencies: ["RestKit"]),
        .target(name: "AlchemyLanguageV1", dependencies: ["RestKit"]),
        .target(name: "AlchemyVisionV1", dependencies: ["RestKit"]),
        .target(name: "ConversationV1", dependencies: ["RestKit"]),
        .target(name: "DialogV1", dependencies: ["RestKit"]),
        .target(name: "DiscoveryV1", dependencies: ["RestKit"]),
        .target(name: "DocumentConversionV1", dependencies: ["RestKit"]),
        .target(name: "LanguageTranslatorV2", dependencies: ["RestKit"]),
        .target(name: "NaturalLanguageClassifierV1", dependencies: ["RestKit"]),
        .target(name: "NaturalLanguageUnderstandingV1", dependencies: ["RestKit"]),
        .target(name: "PersonalityInsightsV2", dependencies: ["RestKit"]),
        .target(name: "PersonalityInsightsV3", dependencies: ["RestKit"]),
        .target(name: "RelationshipExtractionV1Beta", dependencies: ["RestKit"]),
        .target(name: "RetrieveAndRankV1", dependencies: ["RestKit"]),
        .target(name: "ToneAnalyzerV3", dependencies: ["RestKit"]),
        .target(name: "TradeoffAnalyticsV1", dependencies: ["RestKit"]),
        .target(name: "VisualRecognitionV3", dependencies: ["RestKit"]),
    ]
)
