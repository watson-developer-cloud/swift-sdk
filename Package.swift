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
        Target(name: "AlchemyDataNewsV1", dependencies: [.Target(name: "RestKit")]),
    ],
    dependencies: [
    ],
    exclude: ["Source/AlchemyVisionV1",
              "Source/AlchemyLanguageV1",
              "Source/ConversationV1",
              "Source/DialogV1",
              "Source/DocumentConversionV1",
              "Source/LanguageTranslatorV2",
              "Source/NaturalLanguageClassifierV1",
              "Source/PersonalityInsightsV2",
              "Source/RelationshipExtractionV1Beta",
              "Source/RetrieveAndRankV1",
              "Source/SpeechToTextV1",
              "Source/TextToSpeechV1",
              "Source/ToneAnalyzerV3",
              "Source/TradeoffAnalyticsV1",
              "Source/VisualRecognitionV3"]
)
