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

// Note: The Speech to Text and Text to Speech services are not supported with
// Swift Package Manager. Unfortunately, the package manager does not provide
// a convenient way to include the dependencies required for these services
// (e.g. libogg, libopus, and Starscream). If you would like to use Speech
// to Text or Text to Speech, please try an alternative dependency management
// tool (e.g. Carthage). If you would like support for the Swift Package Manager,
// feel free to open an issue or even contribute a pull request that adds
// support for the required libraries.

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
        .target(name: "AlchemyDataNewsV1", dependencies: []),
        .testTarget(name: "AlchemyDataNewsV1Tests", dependencies: ["AlchemyDataNewsV1"]),
        .target(name: "AlchemyLanguageV1", dependencies: []),
        .testTarget(name: "AlchemyLanguageV1Tests", dependencies: ["AlchemyLanguageV1"]),
        .target(name: "AlchemyVisionV1", dependencies: []),
        .target(name: "ConversationV1", dependencies: []),
        .testTarget(name: "ConversationV1Tests", dependencies: ["ConversationV1"]),
        .target(name: "DialogV1", dependencies: []),
        .target(name: "DiscoveryV1", dependencies: []),
        .testTarget(name: "DiscoveryV1Tests", dependencies: ["DiscoveryV1"]),
        .target(name: "DocumentConversionV1", dependencies: []),
        .testTarget(name: "DocumentConversionV1Tests", dependencies: ["DocumentConversionV1"]),
        .target(name: "LanguageTranslatorV2", dependencies: []),
        .testTarget(name: "LanguageTranslatorV2Tests", dependencies: ["LanguageTranslatorV2"]),
        .target(name: "NaturalLanguageClassifierV1", dependencies: []),
        .testTarget(name: "NaturalLanguageClassifierV1Tests", dependencies: ["NaturalLanguageClassifierV1"]),
        .target(name: "NaturalLanguageUnderstandingV1", dependencies: []),
        .testTarget(name: "NaturalLanguageUnderstandingV1Tests", dependencies: ["NaturalLanguageUnderstandingV1"]),
        .target(name: "PersonalityInsightsV2", dependencies: []),
        .target(name: "PersonalityInsightsV3", dependencies: []),
        .testTarget(name: "PersonalityInsightsV3Tests", dependencies: ["PersonalityInsightsV3"]),
        .target(name: "RelationshipExtractionV1Beta", dependencies: []),
        .testTarget(name: "RelationshipExtractionV1BetaTests", dependencies: ["RelationshipExtractionV1Beta"]),
        .target(name: "RetrieveAndRankV1", dependencies: []),
        .testTarget(name: "RetrieveAndRankV1Tests", dependencies: ["RetrieveAndRankV1"]),
        .target(name: "ToneAnalyzerV3", dependencies: []),
        .testTarget(name: "ToneAnalyzerV3Tests", dependencies: ["ToneAnalyzerV3"]),
        .target(name: "TradeoffAnalyticsV1", dependencies: []),
        .testTarget(name: "TradeoffAnalyticsV1Tests", dependencies: ["TradeoffAnalyticsV1"]),
        .target(name: "VisualRecognitionV3", dependencies: []),
        .testTarget(name: "VisualRecognitionV3Tests", dependencies: ["VisualRecognitionV3"]),
    ]

)
