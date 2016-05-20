#!/bin/bash
set -x #echo on

rm ./Cartfile.resolved 
rm -rf ./Carthage
mkdir -p ./Frameworks
carthage bootstrap --platform iOS

