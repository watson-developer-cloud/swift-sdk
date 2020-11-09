#!/bin/bash

USERNAME="your-username-here"
PASSWORD="your-password-here"

curl -X POST -u "${USERNAME}":"${PASSWORD}" \
    -H 'Accept: application/json' -H 'X-Watson-Learning-Opt-Out: true' -H 'X-Watson-Test: true' \
    -F training_metadata="{\"language\":\"en\",\"name\":\"swift-sdk-test-classifier - DO NOT DELETE\"}" \
    -F training_data=@weather_data_train.csv \
   "https://api.us-south.natural-language-classifier.watson.cloud.ibm.com/v1/classifiers"
