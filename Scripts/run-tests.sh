#!/bin/bash

set -o pipefail
exitCode=0
IOS_SDK=${IOS_SDK:-"iphonesimulator10.3"}
IOS_DESTINATION=${IOS_DESTINATION:-"OS=10.3.1,name=iPhone 7"}

function checkStatus {
    if [[ $exitCode == 0 && $1 != 0 ]]; then
        exitCode=$1
    fi
}

function uploadCodecov {
    bash <(curl -s https://codecov.io/bash)
}

xcodebuild build -scheme "RestKit" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" | xcpretty
checkStatus $?
xcodebuild test -scheme "AlchemyDataNewsV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "AlchemyLanguageV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "AlchemyVisionV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "ConversationV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "DialogV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "DiscoveryV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "DocumentConversionV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "LanguageTranslatorV2" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "NaturalLanguageClassifierV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "NaturalLanguageUnderstandingV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "PersonalityInsightsV2" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "PersonalityInsightsV3" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "RelationshipExtractionV1Beta" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "RetrieveAndRankV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "SpeechToTextV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "TextToSpeechV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "ToneAnalyzerV3" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "TradeoffAnalyticsV1" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES" | xcpretty
checkStatus $? && uploadCodecov
xcodebuild test -scheme "VisualRecognitionV3" -sdk "$IOS_SDK" -destination "$IOS_DESTINATION" -enableCodeCoverage "YES"
checkStatus $? && uploadCodecov

exit $exitCode