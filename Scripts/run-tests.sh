#!/bin/bash

# This script builds and tests each scheme of the Swift SDK using the
# iOS Simulator. This script will not run on Linux.

####################
# Environment Vars
####################

# the device to build for
DESTINATION=${DESTINATION:-"OS=11.2,name=iPhone 7"}

# the exit code of each build command
EXIT_CODES=()

# the schemes to build
SCHEMES=(
	"AssistantV1"
	"ConversationV1"
	"DiscoveryV1"
	"LanguageTranslatorV2"
	"NaturalLanguageClassifierV1"
	"NaturalLanguageUnderstandingV1"
	"PersonalityInsightsV3"
	"SpeechToTextV1"
	"TextToSpeechV1"
	"ToneAnalyzerV3"
	"VisualRecognitionV3"
)

####################
# Dependencies
####################

brew update
brew outdated carthage || brew upgrade carthage
carthage bootstrap --platform iOS

brew outdated swiftlint || brew upgrade swiftlint

####################
# Setup
####################

# Xcode over-writes the coverage info with each build, so we create a directory
# where we accumulate all the coverage files
BUILD_ROOT=$(xcodebuild -showBuildSettings | grep '\<BUILD_ROOT\>' | awk '{print $3}')
COVERAGE_DIR=$BUILD_ROOT/../Coverage
rm -rf $COVERAGE_DIR
mkdir $COVERAGE_DIR

####################
# Build and Test
####################

# set a pipeline's return status to the value of the last (rightmost) commmand
# to exit with a non-zero status, or zero if all commands exited successfully
# (required to check status code when using xcpretty)
set -o pipefail

# build each scheme
for SCHEME in ${SCHEMES[@]}; do
	xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" -enableCodeCoverage YES test | xcpretty
	EXIT_CODES+=($?)
	PROF_DIR=$(dirname $(find $BUILD_ROOT/.. -name Coverage.profdata))
	cp $PROF_DIR/*.profraw $COVERAGE_DIR
done

####################
# Create a composite coverage report
####################

xcrun llvm-profdata merge -sparse $(ls $COVERAGE_DIR/*.profraw) -o $COVERAGE_DIR/Coverage.profdata

FRAMEWORKS=$(ls -d $BUILD_ROOT/Debug-iphonesimulator/*.framework)
BINARIES=$(echo $FRAMEWORKS | sed 's/\(\([A-Za-z0-9]*\).framework\)/\1\/\2/g' | sed 's/ / -object /g')

xcrun llvm-cov show -instr-profile $COVERAGE_DIR/Coverage.profdata $BINARIES > $COVERAGE_DIR/Coverage.txt

# Composite coverage report in $COVERAGE_DIR/Coverage.txt"

####################
# Set Exit Code
####################

# exit with the first non-zero status or zero if all builds exited successfully
for EXIT_CODE in ${EXIT_CODES[@]}; do
	if [ $EXIT_CODE -ne 0 ]
	then
		exit $EXIT_CODE
	fi
done
exit 0
