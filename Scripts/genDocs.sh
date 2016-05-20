#!/bin/bash

# jazzyParams="-c -g https://github.com/watson-developer-cloud/ios-sdk --skip-undocumented --hide-documentation-coverage"
jazzyParams="-c -g https://github.com/watson-developer-cloud/ios-sdk --hide-documentation-coverage"

rm -r ./Documentation/Service/AlchemyLanguageV1
rm -r ./Documentation/Service/AlchemyVisionV1
rm -r ./Documentation/Service/DialogV1 
rm -r ./Documentation/Service/LanguageTranslationV2
rm -r ./Documentation/Service/NaturalLanguageClassifierV1
rm -r ./Documentation/Service/PersonalityInsightsV2 
rm -r ./Documentation/Service/VisualRecognitionV3
rm -r ./Documentation/Service/SpeechToTextV1
rm -r ./Documentation/Service/TextToSpeechV1 
rm -r ./Documentation/Service/ToneAnalyzerV3 

jazzy -x '-project,WatsonDeveloperCloud.xcodeproj,-scheme,AlchemyLanguageV1' $jazzyParams --exclude ./WatsonDeveloperCloud/WatsonCore/Utilities/AlchemyService.swift,./WatsonDeveloperCloud/AlchemyVision/AlchemyVisionConstants.swift
mv ./docs ./Documentation/Service/AlchemyLanguageV1
jazzy -x '-project,WatsonDeveloperCloud.xcodeproj,-scheme,AlchemyVisionV1' $jazzyParams --exclude ./WatsonDeveloperCloud/WatsonCore/Utilities/AlchemyService.swift,./WatsonDeveloperCloud/AlchemyVision/AlchemyVisionConstants.swift
mv ./docs ./Documentation/Service/AlchemyVisionV1
jazzy -x '-project,WatsonDeveloperCloud.xcodeproj,-scheme,DialogV1' $jazzyParams --exclude ./WatsonDeveloperCloud/WatsonCore/Utilities/AlchemyService.swift,./WatsonDeveloperCloud/AlchemyVision/AlchemyVisionConstants.swift
mv ./docs ./Documentation/Service/DialogV1 
jazzy -x '-project,WatsonDeveloperCloud.xcodeproj,-scheme,LanguageTranslationV2' $jazzyParams
mv ./docs ./Documentation/Service/LanguageTranslationV2 
jazzy -x '-project,WatsonDeveloperCloud.xcodeproj,-scheme,NaturalLanguageClassifierV1' $jazzyParams
mv ./docs ./Documentation/Service/NaturalLanguageClassifierV1 
jazzy -x '-project,WatsonDeveloperCloud.xcodeproj,-scheme,PersonalityInsightsV2' $jazzyParams
mv ./docs ./Documentation/Service/PersonalityInsightsV2 
jazzy -x '-project,WatsonDeveloperCloud.xcodeproj,-scheme,VisualRecognitionV3' $jazzyParams
mv ./docs ./Documentation/Service/VisualRecognitionV3 
jazzy -x '-project,WatsonDeveloperCloud.xcodeproj,-scheme,SpeechToTextV1' $jazzyParams
mv ./docs ./Documentation/Service/SpeechToTextV1 
jazzy -x '-project,WatsonDeveloperCloud.xcodeproj,-scheme,TextToSpeechV1' $jazzyParams
mv ./docs ./Documentation/Service/TextToSpeechV1 
jazzy -x '-project,WatsonDeveloperCloud.xcodeproj,-scheme,ToneAnalyzerV3' $jazzyParams
mv ./docs ./Documentation/Service/ToneAnalyzerV3 
