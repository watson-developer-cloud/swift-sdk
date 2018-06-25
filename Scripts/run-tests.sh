#!/bin/bash

# This script builds and tests each scheme of the Swift SDK using the
# iOS Simulator. This script will not run on Linux.

####################
# Environment Vars
####################

# the device to build for
DESTINATION="OS=11.3,name=iPhone 7"

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
# Build and Test
####################

# set a pipeline's return status to the value of the last (rightmost) commmand
# to exit with a non-zero status, or zero if all commands exited successfully
# (required to check status code when using xcpretty)
set -o pipefail

# Make sure RC is not set from the parent environment
unset RC

# build each scheme
for SCHEME in ${SCHEMES}; do
	xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" test | xcpretty || RC=${RC:-$?}
done

####################
# Set Exit Code
####################

# exit with the first non-zero status or zero if all builds exited successfully
exit ${RC:-0}
