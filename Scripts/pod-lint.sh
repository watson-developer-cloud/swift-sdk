#!/bin/bash

# This script runs a linter on every pod in the Swift SDK.
# This must be run to ensure that every pod is ready to be published to Cocoapods.
# The flag --allow-warnings is required for pods that have build warnings (like deprecation notices).

pod lib lint IBMWatsonAssistantV1.podspec
pod lib lint IBMWatsonConversationV1.podspec
pod lib lint IBMWatsonDiscoveryV1.podspec
pod lib lint IBMWatsonLanguageTranslatorV3.podspec
pod lib lint IBMWatsonNaturalLanguageClassifierV1.podspec
pod lib lint IBMWatsonNaturalLanguageUnderstandingV1.podspec
pod lib lint IBMWatsonPersonalityInsightsV3.podspec

pod lib lint IBMWatsonSpeechToTextV1.podspec --allow-warnings
git reset --hard
git clean -df

pod lib lint IBMWatsonTextToSpeechV1.podspec --allow-warnings
git reset --hard
git clean -df

pod lib lint IBMWatsonToneAnalyzerV3.podspec
pod lib lint IBMWatsonVisualRecognitionV3.podspec