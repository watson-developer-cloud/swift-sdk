#!/bin/bash

pushd `dirname $0` > /dev/null
root=`pwd`
popd > /dev/null
cd $root
cd ..

carthage build --no-skip-current
carthage archive --output WatsonDeveloperCloud.framework.zip