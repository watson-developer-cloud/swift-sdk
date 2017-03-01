#!/bin/bash

################################################################################
# Define list of services
################################################################################

services=(
  AlchemyDataNewsV1
  AlchemyLanguageV1
  AlchemyVisionV1
  ConversationV1
  DialogV1
  DiscoveryV1
  DocumentConversionV1
  LanguageTranslatorV2
  NaturalLanguageClassifierV1
  NaturalLanguageUnderstandingV1
  PersonalityInsightsV2
  PersonalityInsightsV3
  RelationshipExtractionV1Beta
  RetrieveAndRankV1
  SpeechToTextV1
  TextToSpeechV1
  ToneAnalyzerV3
  TradeoffAnalyticsV1
  VisualRecognitionV3
)

################################################################################
# Change directory to repository root
################################################################################

pushd `dirname $0` > /dev/null
root=`pwd`
popd > /dev/null
cd $root
cd ..

################################################################################
# Create folder for generated documentation
################################################################################

if [ -d "docs/swift-api" ]; then
  echo "The docs/swift-api directory already exists."
  echo "Please remove the directory and try again."
  exit
fi

mkdir docs/swift-api
mkdir docs/swift-api/services

################################################################################
# Run Jazzy to generate documentation
################################################################################

for service in ${services[@]}; do
  mkdir docs/swift-api/services/${service}
  xcodebuild_arguments=-project,WatsonDeveloperCloud.xcodeproj,-scheme,${service}
  jazzy \
    --xcodebuild-arguments $xcodebuild_arguments \
    --output docs/swift-api/services/${service} \
    --clean \
    --github_url https://github.com/watson-developer-cloud/ios-sdk \
    --hide-documentation-coverage
done

################################################################################
# Generate index.html and copy supporting files
################################################################################

cp Scripts/generate-documentation-resources/index-prefix docs/index.html
for service in ${services[@]}; do
  html="<li><a target="_blank" href="./swift-api/services/${service}/index.html">${service}</a></li>"
  echo ${html} >> docs/index.html
done
cat Scripts/generate-documentation-resources/index-postfix >> docs/index.html

cp -r Scripts/generate-documentation-resources/* docs/swift-api
rm docs/swift-api/index-prefix docs/swift-api/index-postfix

################################################################################
# Collect undocumented.json files
################################################################################

touch docs/swift-api/undocumented.json
echo "[" >> docs/swift-api/undocumented.json

declare -a undocumenteds
undocumenteds=($(ls -r docs/swift-api/services/*/undocumented.json))

if [ ${#undocumenteds[@]} -gt 0 ]; then
  echo -e -n "\t" >> docs/swift-api/undocumented.json
  cat "${undocumenteds[0]}" >> docs/swift-api/undocumented.json
  unset undocumenteds[0]
  for f in "${undocumenteds[@]}"; do
    echo "," >> docs/swift-api/undocumented.json
    echo -e -n "\t" >> docs/swift-api/undocumented.json
    cat "$f" >> docs/swift-api/undocumented.json
  done
fi

echo "" >> docs/swift-api/undocumented.json
echo "]" >> docs/swift-api/undocumented.json
