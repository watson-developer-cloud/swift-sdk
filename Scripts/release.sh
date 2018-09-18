#!/bin/bash

# This script takes the latest git tag from Github,
# and applies it to the version in every service's podspec.
# Once this is complete, the new versions are published to Cocoapods,
# and the SDK binary is built.

# Note that this script must be executed from the root directory
# of the swift-sdk, NOT inside the Scripts directory

### IMPORTANT ###: Make sure you understand what this script does before executing it!
# Comment out the DANGER ZONE sections below if you want to be extra careful

declare -a allPods=(
  "IBMWatsonAssistantV1.podspec"
  "IBMWatsonAssistantV2.podspec"
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
releaseVersion=$(git describe --abbrev=0 --tags)

# Update podspec versions
for podspec in "${allPods[@]}"
do
	podVersion=$(grep -o 'version.*=.*[0-9.][0-9.][0-9]' $podspec | cut -f 2 -d "'")
	if [[ $releaseVersion > $podVersion ]]; then
		sed -i '' -e "/s.version/s/${podVersion}/${releaseVersion}/g" $podspec
	fi
done

# Update README with new version
readmeVersion=$(grep -m 1 -o '~>.*[0-9.][0-9.][0-9]' README.md | cut -f 2 -d " ")
sed -i '' -e "s/${readmeVersion}/${releaseVersion}/g" README.md

# Update SDK version in Shared struct
sed -i '' -e "s/let sdkVersion = \".*\"/let sdkVersion = \"${releaseVersion}\"/g" Source/SupportingFiles/Shared.swift

# Commit the podspec updates, move the git tag, and push to Github
git add *.podspec
git add README.md
git add Source/SupportingFiles/Shared.swift
git commit -m "Release SDK version ${releaseVersion}"
### DANGER ZONE ###
git push
git tag -d $releaseVersion
git push --delete origin $releaseVersion
git tag $releaseVersion
git push origin $releaseVersion
### /DANGER ZONE ###

# Release to Cocoapods
for podspec in "${allPods[@]}"
do
  # This will only publish pods that have new versions
  ### DANGER ZONE ###
  pod trunk push $podspec --allow-warnings
  ### /DANGER ZONE ###
done

# Builds WatsonDeveloperCloud.framework.zip, which needs to be uploaded to Github under the latest release
sh ./Scripts/generate-binaries.sh
