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
  DocumentConversionV1
  LanguageTranslatorV2
  NaturalLanguageClassifierV1
  PersonalityInsightsV2
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

if [ -d "docs/services" ]; then
  echo "The docs/services directory already exists."
  echo "Please remove the directory and try again."
  exit
fi

mkdir docs/services

################################################################################
# Run Jazzy to generate documentation
################################################################################

for service in ${services[@]}; do
  mkdir docs/services/${service}
  xcodebuild_arguments=-project,WatsonDeveloperCloud.xcodeproj,-scheme,${service}
  jazzy \
    --xcodebuild-arguments $xcodebuild_arguments \
    --output docs/services/${service} \
    --clean \
    --github_url https://github.com/watson-developer-cloud/ios-sdk \
    --hide-documentation-coverage
done

################################################################################
# Generate index.html and copy supporting files
################################################################################

cp Scripts/generate-documentation-resources/index-prefix docs/index.html
for service in ${services[@]}; do
  html="<li><a target="_blank" href="./services/${service}/index.html">${service}</a></li>"
  echo ${html} >> docs/index.html
done
cat Scripts/generate-documentation-resources/index-postfix >> docs/index.html

cp -r Scripts/generate-documentation-resources/* docs/
rm docs/index-prefix docs/index-postfix

################################################################################
# Collect undocumented.json files
################################################################################

touch docs/undocumented.json
echo "[" >> docs/undocumented.json

declare -a undocumenteds
undocumenteds=($(ls -r docs/services/*/undocumented.json))

if [ ${#undocumenteds[@]} -gt 0 ]; then
  echo -e -n "\t" >> docs/undocumented.json
  cat "${undocumenteds[0]}" >> docs/undocumented.json
  unset undocumenteds[0]
  for f in "${undocumenteds[@]}"; do
    echo "," >> docs/undocumented.json
    echo -e -n "\t" >> docs/undocumented.json
    cat "$f" >> docs/undocumented.json
  done
fi

echo "" >> docs/undocumented.json
echo "]" >> docs/undocumented.json
