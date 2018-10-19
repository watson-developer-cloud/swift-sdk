#!/bin/bash

pushd `dirname $0` > /dev/null
root=`pwd`
popd > /dev/null
cd $root
cd ..

carthage update
carthage build --no-skip-current
carthage archive --output IBMWatsonSDK.framework.zip
