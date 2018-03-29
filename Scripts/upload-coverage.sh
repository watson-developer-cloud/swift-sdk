#!/bin/bash

# This script uploads the consolidated code coverage report for the Swift SDK.

# Note: to upload a coverage report, set the CODECOV_TOKEN environment variable
#    export CODECOV_TOKEN=<codecov token>

if [ -z "$CODECOV_TOKEN" ]; then
	echo "Set the CODECOV_TOKEN environment variable with the codecov.io access token" 
	exit 1
fi

BUILD_ROOT=$(xcodebuild -showBuildSettings | grep '\<BUILD_ROOT\>' | awk '{print $3}')

COVERAGE_DIR=$BUILD_ROOT/../Coverage

if [ ! -e "$COVERAGE_DIR/Coverage.txt" ]; then
	echo "No coverage report found.  Execute the run_tests.sh script to create a coverage report"
	exit 1
fi

bash <(curl -s https://codecov.io/bash) -f $COVERAGE_DIR/Coverage.txt

