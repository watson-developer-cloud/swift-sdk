// swift-tools-version:5.3
/**
 * (C) Copyright IBM Corp. 2016, 2019.
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
    platforms: [
        .iOS(.v10), .macOS(.v10_15),
    ],
    products: [
        .library(name: "AssistantV1", targets: ["AssistantV1"]),
        .library(name: "AssistantV2", targets: ["AssistantV2"]),
        .library(name: "CompareComplyV1", targets: ["CompareComplyV1"]),
        .library(name: "DiscoveryV1", targets: ["DiscoveryV1"]),
        .library(name: "DiscoveryV2", targets: ["DiscoveryV2"]),
        .library(name: "LanguageTranslatorV3", targets: ["LanguageTranslatorV3"]),
        .library(name: "NaturalLanguageClassifierV1", targets: ["NaturalLanguageClassifierV1"]),
        .library(name: "NaturalLanguageUnderstandingV1", targets: ["NaturalLanguageUnderstandingV1"]),
        .library(name: "PersonalityInsightsV3", targets: ["PersonalityInsightsV3"]),
        .library(name: "SpeechToTextV1", targets: ["SpeechToTextV1"]),
        .library(name: "TextToSpeechV1", targets: ["TextToSpeechV1"]),
        .library(name: "ToneAnalyzerV3", targets: ["ToneAnalyzerV3"]),
        .library(name: "VisualRecognitionV3", targets: ["VisualRecognitionV3"]),
        .library(name: "VisualRecognitionV4", targets: ["VisualRecognitionV4"]),
        
    ],
    dependencies: [
        .package(name: "IBMSwiftSDKCore", url: "https://github.com/IBM/swift-sdk-core", from: "1.0.0"),
        .package(name: "Starscream", url: "https://github.com/daltoniam/Starscream", from: "4.0.0"),
    ],
    targets: [
        .systemLibrary(name: "Clibogg", path: "Sources/SupportingFiles/Dependencies/Clibogg", pkgConfig: "ogg", providers: [.brew(["libogg"])]),
        .systemLibrary(name: "Clibopus", path: "Sources/SupportingFiles/Dependencies/Clibopus", pkgConfig: "opus", providers: [.brew(["opus"])]),
        .target(name: "Copustools", path: "Sources/SupportingFiles/Dependencies/Copustools"),
        .target(name: "AssistantV1", dependencies: ["IBMSwiftSDKCore"], path: "Sources/AssistantV1"),
        .target(name: "AssistantV2", dependencies: ["IBMSwiftSDKCore"], path: "Sources/AssistantV2"),
        .target(name: "CompareComplyV1", dependencies: ["IBMSwiftSDKCore"], path: "Sources/CompareComplyV1"),
        .target(name: "DiscoveryV1", dependencies: ["IBMSwiftSDKCore"], path: "Sources/DiscoveryV1"),
        .target(name: "DiscoveryV2", dependencies: ["IBMSwiftSDKCore"], path: "Sources/DiscoveryV2"),
        .target(name: "LanguageTranslatorV3", dependencies: ["IBMSwiftSDKCore"], path: "Sources/LanguageTranslatorV3"),
        .target(name: "NaturalLanguageClassifierV1", dependencies: ["IBMSwiftSDKCore"], path: "Sources/NaturalLanguageClassifierV1"),
        .target(name: "NaturalLanguageUnderstandingV1", dependencies: ["IBMSwiftSDKCore"], path: "Sources/NaturalLanguageUnderstandingV1"),
        .target(name: "PersonalityInsightsV3", dependencies: ["IBMSwiftSDKCore"], path: "Sources/PersonalityInsightsV3"),
        .target(name: "SpeechToTextV1", dependencies: ["IBMSwiftSDKCore", "Starscream", "Clibogg", "Clibopus"], path: "Sources/SpeechToTextV1"),
        .target(name: "TextToSpeechV1", dependencies: ["IBMSwiftSDKCore", "Clibogg", "Clibopus", "Copustools"], path: "Sources/TextToSpeechV1"),
        .target(name: "ToneAnalyzerV3", dependencies: ["IBMSwiftSDKCore"], path: "Sources/ToneAnalyzerV3"),
        .target(name: "VisualRecognitionV3", dependencies: ["IBMSwiftSDKCore"], path: "Sources/VisualRecognitionV3"),
        .target(name: "VisualRecognitionV4", dependencies: ["IBMSwiftSDKCore"], path: "Sources/VisualRecognitionV4"),
        .testTarget(name: "AssistantV1Tests", dependencies: ["AssistantV1"]),
        .testTarget(name: "AssistantV2Tests", dependencies: ["AssistantV2"]),
        .testTarget(name: "CompareComplyV1Tests", dependencies: ["CompareComplyV1"]),
        .testTarget(name: "DiscoveryV1Tests", dependencies: ["DiscoveryV1"]),
        .testTarget(name: "DiscoveryV2Tests", dependencies: ["DiscoveryV2"]),
        .testTarget(name: "LanguageTranslatorV3Tests", dependencies: ["LanguageTranslatorV3"]),
        .testTarget(name: "NaturalLanguageClassifierV1Tests", dependencies: ["NaturalLanguageClassifierV1"]),
        .testTarget(name: "NaturalLanguageUnderstandingV1Tests", dependencies: ["NaturalLanguageUnderstandingV1"]),
        .testTarget(name: "PersonalityInsightsV3Tests", dependencies: ["PersonalityInsightsV3"]),
        .testTarget(name: "SpeechToTextV1Tests", dependencies: ["SpeechToTextV1"]),
        .testTarget(name: "TextToSpeechV1Tests", dependencies: ["TextToSpeechV1"]),
        .testTarget(name: "ToneAnalyzerV3Tests", dependencies: ["ToneAnalyzerV3"]),
        .testTarget(name: "VisualRecognitionV3Tests", dependencies: ["VisualRecognitionV3"]),
        .testTarget(name: "VisualRecognitionV4Tests", dependencies: ["VisualRecognitionV4"]),
        
    ]
)
