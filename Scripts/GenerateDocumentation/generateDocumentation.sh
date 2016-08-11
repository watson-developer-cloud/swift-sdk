#!/bin/bash

################################################################################
# Define list of services
################################################################################

services=(
  AlchemyDataNewsV1
  AlchemyLanguageV1
  AlchemyVisionV1
  ConversationV1
  ConversationV1Experimental
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
# Define parameters for Jazzy
################################################################################

jazzyParams="
  --clean \
  --github_url https://github.com/watson-developer-cloud/ios-sdk \
  --hide-documentation-coverage"

################################################################################
# Change directory to repository root
################################################################################

echo "Changing directory to repository root."
cd ../..

################################################################################
# Create folder for generated documentation
################################################################################

if [ -d "gh-pages" ]; then
  echo "gh-pages directory already exists"
  echo "please remove the directory and try again"
  exit
fi

mkdir gh-pages
mkdir gh-pages/services

################################################################################
# Run Jazzy to generate documentation
################################################################################

for service in ${services[@]}; do
  xcodebuild_arguments=-project,WatsonDeveloperCloud.xcodeproj,-scheme,${service}
  jazzy -x $xcodebuild_arguments $jazzyParams
  mv docs gh-pages/services/${service}
done

################################################################################
# Generate index.html and copy supporting files
################################################################################

cp Scripts/GenerateDocumentation/resources/index-prefix gh-pages/index.html
for service in ${services[@]}; do
  html="<li><a target="_blank" href="./services/${service}/index.html">${service}</a></li>"
  echo ${html} >> gh-pages/index.html
done
cat Scripts/GenerateDocumentation/resources/index-postfix >> gh-pages/index.html

cp -r Scripts/GenerateDocumentation/resources/* gh-pages/
rm gh-pages/index-prefix gh-pages/index-postfix

################################################################################
# Collect undocumented.json files
################################################################################

touch gh-pages/undocumented.json
echo "[" >> gh-pages/undocumented.json

declare -a undocumenteds
undocumenteds=($(ls -r gh-pages/services/*/undocumented.json))

if [ ${#undocumenteds[@]} -gt 0 ]; then
  echo -e -n "\t" >> gh-pages/undocumented.json
  cat "${undocumenteds[0]}" >> gh-pages/undocumented.json
  unset undocumenteds[0]
  for f in "${undocumenteds[@]}"; do
    echo "," >> gh-pages/undocumented.json
    echo -e -n "\t" >> gh-pages/undocumented.json
    cat "$f" >> gh-pages/undocumented.json
  done
fi

echo "" >> gh-pages/undocumented.json
echo "]" >> gh-pages/undocumented.json

################################################################################
# Print message about copying contents to gh-pages branch
################################################################################

echo ""
echo "Documentation was successfully generated at gh-pages/."
echo "See gh-pages/undocumented.json for warnings and undocumented code."
echo ""
echo "Please test the generated documentation. Then manually move"
echo "the contents of the gh-pages folder to the gh-pages branch."
echo "After doing so, delete the gh-pages folder from this directory."
echo ""
