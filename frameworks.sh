#!/bin/bash
set -x #echo on

rm ./Cartfile.resolved 
# rm -rf ./Frameworks
rm -rf ./Carthage
read -p "removed Cartfile.resolved and Carthage directory"
mkdir -p ./Frameworks
carthage bootstrap --platform iOS
# cp -r ./Carthage/Build/iOS/*.framework ./Frameworks
