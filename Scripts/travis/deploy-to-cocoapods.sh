# Publishes the latest version of all services to Cocoapods

set -e

# needed to resolve a caching issue
# that can break deployments on `pod trunk push`
rm -rf ~/.cocoapods/repos

git pull # Needed to get the new version created by semantic-release

declare -a allPods=(
  "IBMWatsonAssistantV1.podspec"
  "IBMWatsonAssistantV2.podspec"
  "IBMWatsonDiscoveryV1.podspec"
  "IBMWatsonDiscoveryV2.podspec"
  "IBMWatsonLanguageTranslatorV3.podspec"
  "IBMWatsonNaturalLanguageUnderstandingV1.podspec"
  "IBMWatsonSpeechToTextV1.podspec"
  "IBMWatsonTextToSpeechV1.podspec"
)

for podspec in "${allPods[@]}"
do
  # This will only publish pods if their version has been updated
  pod trunk push $podspec --allow-warnings
done
