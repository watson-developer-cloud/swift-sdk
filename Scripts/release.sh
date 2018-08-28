#!/bin/bash

# This script takes the latest git tag from Github,
# and applies it to the version in every service's podspec.
# Once this is complete, the new versions are published to Cocoapods,
# and the SDK binary is built.

# Note that this script must be executed from the root directory
# of the swift-sdk, NOT inside the Scripts directory

declare -a allPods=(
  "IBMWatsonAssistantV1.podspec"
  "IBMWatsonConversationV1.podspec"
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

git fetch --tags

# Update podspec versions and release to Cocoapods
for podspec in "${allPods[@]}"
do
	podVersion=$(grep -o 'version.*=.*[0-9]' $podspec | cut -f 2 -d "'")
	latestRelease=$(git describe --abbrev=0 --tags)
	# Only release to Cocoapods if the pod's version is behind the latest git tag version
	if [[ $latestRelease > $podVersion ]]; then
		sed -i '' -e "/s.version/s/${podVersion}/${latestRelease}/g" $podspec
		pod trunk push $podspec
	fi
done

# Builds WatsonDeveloperCloud.framework.zip, which needs to be uploaded to Github under the latest release
sh ./Scripts/generate-binaries.sh