#!/bin/bash

USERNAME="your-username-here"
PASSWORD="your-password-here"

curl -X POST -u "${USERNAME}":"${PASSWORD}" \
    -H 'Accept: application/json' -H 'X-Watson-Learning-Opt-Out: true' -H 'X-Watson-Test: true' \
    -F training_metadata="{\"language\":\"en\",\"name\":\"swift-sdk-test-classifier - DO NOT DELETE\"}" \
    -F training_data=@weather_data_train.csv \
   "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers"
