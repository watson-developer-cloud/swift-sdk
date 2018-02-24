#!/bin/bash

# This script builds and tests each scheme of the Swift SDK using the
# iOS Simulator. This script will not run on Linux.

####################
# Environment Vars
####################

# the device to build for
DESTINATION=${DESTINATION:-"OS=11.3,name=iPhone 7"}

# the schemes to build, which must be invoked from the root directory of the project
SCHEMES=$(xcodebuild -list | awk 'schemes { if (NF>0) { print $1 } } /Schemes:$/ { schemes = 1 }')

####################
# Dependencies
####################

brew update > /dev/null
brew outdated carthage || brew upgrade carthage
carthage bootstrap --platform iOS

brew outdated swiftlint || brew upgrade swiftlint

####################
# Setup
####################

BUILD_ROOT=$(xcodebuild -showBuildSettings | grep '\<BUILD_ROOT\>' | awk '{print $3}')
if [[ -z "$BUILD_ROOT" ]]; then
   echo "Unable to locate BUILD_ROOT"
   exit 1
fi

# Xcode over-writes the coverage info with each build, so we create a directory
# where we accumulate all the coverage files
COVERAGE_DIR=$BUILD_ROOT/../Coverage
mkdir $COVERAGE_DIR
rm -rf $COVERAGE_DIR/*

# Delete any pre-existing coverage files
find $BUILD_ROOT/.. -name Coverage.profdata -exec rm {} +

####################
# Build and Test
####################

# set a pipeline's return status to the value of the last (rightmost) commmand
# to exit with a non-zero status, or zero if all commands exited successfully
# (required to check status code when using xcpretty)
set -o pipefail

# build each scheme
for SCHEME in ${SCHEMES}; do
  xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" -enableCodeCoverage YES test | xcpretty || RC=${RC:-$?}
  PROF_DIR=$(dirname $(find $BUILD_ROOT/.. -name Coverage.profdata))
  cp $PROF_DIR/*.profraw $COVERAGE_DIR
done

####################
# Merge profile data and create coverage report
####################

xcrun llvm-profdata merge -sparse $(ls $COVERAGE_DIR/*.profraw) -o $COVERAGE_DIR/Coverage.profdata

FRAMEWORKS=$(ls -d $BUILD_ROOT/Debug-iphonesimulator/*.framework)
BINARIES=$(echo $FRAMEWORKS | sed 's/\(\([A-Za-z0-9]*\).framework\)/\1\/\2/g' | sed 's/ / -object /g')

xcrun llvm-cov show -instr-profile $COVERAGE_DIR/Coverage.profdata $BINARIES > $COVERAGE_DIR/Coverage.txt

echo "Coverage report in $COVERAGE_DIR/Coverage.txt"

####################
# Return Exit Code
####################

exit ${RC:-0}
