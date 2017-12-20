#!/bin/bash

set -o pipefail
exitCode=0
DESTINATION="OS=11.2,name=iPhone 7"

function checkStatus {
    if [[ $exitCode == 0 && $1 != 0 ]]; then
        exitCode=$1
    fi
}

schemes=(
	"AlchemyDataNewsV1"
	"AlchemyLanguageV1"
	"AlchemyVisionV1"
	"ConversationV1"
	"DialogV1"
	"DiscoveryV1"
	"DocumentConversionV1"
	"LanguageTranslatorV2"
	"NaturalLanguageClassifierV1"
	"NaturalLanguageUnderstandingV1"
	"PersonalityInsightsV2"
	"PersonalityInsightsV3"
	"RelationshipExtractionV1Beta"
	"RetrieveAndRankV1"
	"SpeechToTextV1"
	"TextToSpeechV1"
	"ToneAnalyzerV3"
	"TradeoffAnalyticsV1"
	"VisualRecognitionV3"
)

for scheme in ${schemes[@]}; do
	xcodebuild -scheme "$scheme" -destination "$DESTINATION" | xcpretty
	checkStatus $?
done

exit $exitCode
