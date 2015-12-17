#!/bin/bash
set -x #echo on

rm ./Cartfile.resolved 
# rm -rf ./Frameworks
rm -rf ./Carthage
mkdir -p ./Frameworks
carthage bootstrap --platform iOS
# cp -r ./Carthage/Build/iOS/*.framework ./Frameworks
