#!/bin/bash

# This script builds and tests each scheme of the Swift SDK using the
# iOS Simulator. This script will not run on Linux.

####################
# Environment Vars
####################

# the device to build for
DESTINATION="OS=13.0,name=iPhone 11"

# Build an array of tests to suppress
# this environment variable is set within
# Travis
IFS=","
read -ra SUPPRESS_TEST <<< $TESTS_TO_SUPPRESS
unset IFS

# the schemes to build, which must be invoked from the root directory of the project
SCHEMES=$(xcodebuild -list | awk 'schemes { if (NF>0) { print $1 } } /Schemes:$/ { schemes = 1 }')

####################
# Build and Test
####################
# Make sure RC is not set from the parent environment
unset RC

# build each scheme
for SCHEME in ${SCHEMES}; do
  # if the scheme name matches a scheme name that was passed in
  # with the command, we want to suppress it
  SHOULD_SUPPRESS=false
  for SUPPRESSED_TEST_SUITE in ${SUPPRESS_TEST[@]}; do
    if [ $SCHEME == $SUPPRESSED_TEST_SUITE ]; then
      SHOULD_SUPPRESS=true
    fi
  done

  # if the current scheme matched our suppress schemes
  # disable pipefail
  # otherwise, enable it
  if [ $SHOULD_SUPPRESS == true ]; then
    echo "Suppressing test suite errors for $SCHEME"
    set +o pipefail
  else
    set -o pipefail
  fi

	xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" test | xcpretty || RC=${RC:-$?}
done

####################
# Set Exit Code
####################

# exit with the first non-zero status or zero if all builds exited successfully
exit ${RC:-0}
