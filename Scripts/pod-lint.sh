#!/bin/bash

# This script runs a linter on every pod in the Swift SDK.
# This must be run to ensure that every pod is ready to be published to Cocoapods.
# The flag --allow-warnings is required for pods that have build warnings (like deprecation notices).
set -e

pod lib lint IBMWatsonAssistantV1.podspec --allow-warnings
pod lib lint IBMWatsonAssistantV2.podspec --allow-warnings
pod lib lint IBMWatsonCompareComplyV1.podspec --allow-warnings
pod lib lint IBMWatsonDiscoveryV1.podspec --allow-warnings
pod lib lint IBMWatsonDiscoveryV2.podspec --allow-warnings
pod lib lint IBMWatsonLanguageTranslatorV3.podspec --allow-warnings
pod lib lint IBMWatsonNaturalLanguageClassifierV1.podspec --allow-warnings
pod lib lint IBMWatsonNaturalLanguageUnderstandingV1.podspec --allow-warnings
pod lib lint IBMWatsonPersonalityInsightsV3.podspec --allow-warnings

pod lib lint IBMWatsonSpeechToTextV1.podspec --allow-warnings
# Cleanup from the podspec prepare_command
git checkout Sources/SupportingFiles/Dependencies
rm Sources/SupportingFiles/Dependencies/Libraries/*stt.a
find Sources/SupportingFiles/Dependencies/Source -maxdepth 1 -type f -delete

pod lib lint IBMWatsonTextToSpeechV1.podspec --allow-warnings
# Cleanup from the podspec prepare_command
git checkout Sources/SupportingFiles/Dependencies
rm Sources/SupportingFiles/Dependencies/Libraries/*tts.a
find Sources/SupportingFiles/Dependencies/Source -maxdepth 1 -type f -delete

pod lib lint IBMWatsonToneAnalyzerV3.podspec --allow-warnings
pod lib lint IBMWatsonVisualRecognitionV3.podspec --allow-warnings
pod lib lint IBMWatsonVisualRecognitionV4.podspec --allow-warnings
