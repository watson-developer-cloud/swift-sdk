#!/bin/bash

API_KEY="your-api-key-here"
VERSION=2018-03-19

curl -X POST \
    -F "car_positive_examples=@Resources/cars.zip" \
    -F "negative_examples=@Resources/trucks.zip" \
    -F "name=CarsVsTrucks - do not delete" \
    "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classifiers?api_key=${API_KEY}&version=${VERSION}"

