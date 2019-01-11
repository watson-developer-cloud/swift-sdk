# Publishes the latest version of all services to Cocoapods

set -e

git pull # Needed to get the new version created by semantic-release

declare -a allPods=(
  "IBMWatsonAssistantV1.podspec"
  "IBMWatsonAssistantV2.podspec"
  "IBMWatsonCompareComplyV1.podspec"
  "IBMWatsonDiscoveryV1.podspec"
  "IBMWatsonLanguageTranslatorV3.podspec"
  "IBMWatsonNaturalLanguageClassifierV1.podspec"
  "IBMWatsonNaturalLanguageUnderstandingV1.podspec"
  "IBMWatsonPersonalityInsightsV3.podspec"
  "IBMWatsonSpeechToTextV1.podspec"
  "IBMWatsonTextToSpeechV1.podspec"
  "IBMWatsonToneAnalyzerV3.podspec"
  "IBMWatsonVisualRecognitionV3.podspec"
)

for podspec in "${allPods[@]}"
do
  # This will only publish pods if their version has been updated
  pod trunk push $podspec --allow-warnings
done
