#!/bin/bash

# Set the output directory
outdir=${1:-gh-pages}

################################################################################
# Define list of services
################################################################################

services=(
  AssistantV1
  AssistantV2
  ConversationV1
  DiscoveryV1
  LanguageTranslatorV3
  NaturalLanguageClassifierV1
  NaturalLanguageUnderstandingV1
  PersonalityInsightsV3
  SpeechToTextV1
  TextToSpeechV1
  ToneAnalyzerV3
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

if [ -d "${outdir}" ]; then
  echo "The output directory ${outdir} already exists."
  echo "Please remove the directory and try again."
  exit
fi

mkdir ${outdir}
mkdir ${outdir}/services

################################################################################
# Run Jazzy to generate documentation
################################################################################

for service in ${services[@]}; do
  mkdir ${outdir}/services/${service}
  xcodebuild_arguments=-project,WatsonDeveloperCloud.xcodeproj,-scheme,${service}
  jazzy \
    --module ${service} \
    --xcodebuild-arguments $xcodebuild_arguments \
    --output ${outdir}/services/${service} \
    --clean \
    --readme Source/${service}/README.md \
    --documentation README.md \
    --github_url https://github.com/watson-developer-cloud/swift-sdk \
    --hide-documentation-coverage
done

################################################################################
# Generate index.html and copy supporting files
################################################################################

(
  version=$(git describe --tags)
  cat Scripts/generate-documentation-resources/index-prefix | sed "s/SDK_VERSION/$version/"
  for service in ${services[@]}; do
    echo "<li><a target="_blank" href="./services/${service}/index.html">${service}</a></li>"
  done
  echo -e "          </section>\n        </section>"
  sed -n '/<section id="footer">/,/<\/section>/p' ${outdir}/services/${services[0]}/index.html
  cat Scripts/generate-documentation-resources/index-postfix
) > ${outdir}/index.html

cp -r Scripts/generate-documentation-resources/* ${outdir}
rm ${outdir}/index-prefix ${outdir}/index-postfix

################################################################################
# Collect undocumented.json files
################################################################################

declare -a undocumenteds
undocumenteds=($(ls -r ${outdir}/services/*/undocumented.json))

(
  echo "["
  if [ ${#undocumenteds[@]} -gt 0 ]; then
    echo -e -n "\t"
    cat "${undocumenteds[0]}"
    unset undocumenteds[0]
    for f in "${undocumenteds[@]}"; do
      echo ","
      echo -e -n "\t"
      cat "$f"
    done
  fi
  echo -e "\n]"
) > ${outdir}/undocumented.json
