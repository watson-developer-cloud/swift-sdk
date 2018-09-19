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
        .library(name: "AssistantV1", targets: ["AssistantV1"]),
        .library(name: "AssistantV2", targets: ["AssistantV2"]),
        .library(name: "ConversationV1", targets: ["ConversationV1"]),
        .library(name: "DiscoveryV1", targets: ["DiscoveryV1"]),
        .library(name: "LanguageTranslatorV3", targets: ["LanguageTranslatorV3"]),
        .library(name: "NaturalLanguageClassifierV1", targets: ["NaturalLanguageClassifierV1"]),
        .library(name: "NaturalLanguageUnderstandingV1", targets: ["NaturalLanguageUnderstandingV1"]),
        .library(name: "PersonalityInsightsV3", targets: ["PersonalityInsightsV3"]),
        .library(name: "ToneAnalyzerV3", targets: ["ToneAnalyzerV3"]),
        .library(name: "VisualRecognitionV3", targets: ["VisualRecognitionV3"]),
    ],
    dependencies: [
        .package(url: "https://github.com/watson-developer-cloud/restkit.git", from: "1.2.0")
    ],
    targets: [
        .target(name: "AssistantV1", dependencies: ["RestKit"]),
        .testTarget(name: "AssistantV1Tests", dependencies: ["AssistantV1"]),
        .target(name: "AssistantV2", dependencies: ["RestKit"]),
        .testTarget(name: "AssistantV2Tests", dependencies: ["AssistantV2"]),
        .target(name: "ConversationV1", dependencies: ["RestKit"]),
        .testTarget(name: "ConversationV1Tests", dependencies: ["ConversationV1"]),
        .target(name: "DiscoveryV1", dependencies: ["RestKit"]),
        .testTarget(name: "DiscoveryV1Tests", dependencies: ["DiscoveryV1"]),
        .target(name: "LanguageTranslatorV3", dependencies: ["RestKit"]),
        .testTarget(name: "LanguageTranslatorV3Tests", dependencies: ["LanguageTranslatorV3"]),
        .target(name: "NaturalLanguageClassifierV1", dependencies: ["RestKit"]),
        .testTarget(name: "NaturalLanguageClassifierV1Tests", dependencies: ["NaturalLanguageClassifierV1"]),
        .target(name: "NaturalLanguageUnderstandingV1", dependencies: ["RestKit"]),
        .testTarget(name: "NaturalLanguageUnderstandingV1Tests", dependencies: ["NaturalLanguageUnderstandingV1"]),
        .target(name: "PersonalityInsightsV3", dependencies: ["RestKit"]),
        .testTarget(name: "PersonalityInsightsV3Tests", dependencies: ["PersonalityInsightsV3"]),
        .target(name: "ToneAnalyzerV3", dependencies: ["RestKit"]),
        .testTarget(name: "ToneAnalyzerV3Tests", dependencies: ["ToneAnalyzerV3"]),
        .target(name: "VisualRecognitionV3", dependencies: ["RestKit"]),
        .testTarget(name: "VisualRecognitionV3Tests", dependencies: ["VisualRecognitionV3"]),
    ]
)
