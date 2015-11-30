# Watson iOS SDK


[![Build Status](https://magnum.travis-ci.com/IBM-MIL/Watson-iOS-SDK.svg?token=YPHGLjpSd2i3xBsMhsyL&branch=master)](https://magnum.travis-ci.com/IBM-MIL/Watson-iOS-SDK) [![codecov.io](http://codecov.io/github/IBM-MIL/Watson-iOS-SDK/coverage.svg?branch=develop)](https://codecov.io/github/IBM-MIL/Watson-iOS-SDK?branch=develop)

The Watson iOS SDK are a collection of services to allow developers to quickly add Watson Cognitive Computing services to their Swift 2.0+ applications.

## Table of Contents
* [Installation](#installation)
* [Usage](#usage)
* [Examples](#examples)
* [IBM Watson Services](#ibm-watson-services)
	* [AlchemyLanguage](#alchemylanguage)
	* [AlchemyVision](#alchemyvision)
	* [Dialog](#dialog)
	* [Language Translation](#language-translation)
	* [Natural Language Classifier](#natural-language-classifier)
	* [Personality Insights](#personality-insights)
	* [Speech to Text](#speech-to-text)	
	* [Text to Speech](#text-to-speech)
* [Build + Test](#build--test)
* [Open Source @ IBM](#open-source--ibm)
* [License](#license)
* [Contributing](#contributing)

## Installation

The Watson iOS SDK requires some third-party libraries such as ObjectMapper and Alamofire. To download these frameworks to the project path, make sure you are in the root of the project directory and run 

``` 
carthage update
```

## Examples 


A sample app can be found in the [BoxContentSDKSampleApp](../../tree/master/BoxContentSDKSampleApp) folder. The sample app demonstrates how to authenticate a user, and manage the user's files and folders.


## Tests

Tests can be found in the 'BoxContentSDKTests' target. [Use XCode to execute the tests](https://developer.apple.com/library/ios/recipes/xcode_help-test_navigator/RunningTests/RunningTests.html#//apple_ref/doc/uid/TP40013329-CH4-SW1). Travis CI will also execute tests for pull requests and pushes to the repository.

## IBM Watson Services

The Watson Developer Cloud offers a variety of services for building cognitive applications.


### AlchemyLanguage

The AlchemyLanguage API utilizes sophisticated natural language processing techniques to provide high-level semantic information about your content.


##### AlchemyLanguage Features

* Entity Extraction
* Sentiment Analysis
* Keyword Extraction
* Concept Tagging
* Relation Extraction
* Taxonomy Classification
* Author Extraction
* Language Detection
* Text Extraction
* Microformats Parsing
* Feed Detection


##### Requirements

* Review the original AlchemyLanguage API [here](http://www.alchemyapi.com/products/alchemylanguage)
* An Alchemy [API Key](http://www.alchemyapi.com/api/register.html)


##### Usage

Instantiate an **AlchemyLanguage** object and set its api key via either

```swift

let alchemyLanguageInstance = AlchemyLanguage(apiKey: **String**)

```

or 

```swift

let alchemyLanguageInstance = AlchemyLanguage()
alchemyLanguageInstance._apiKey = **API_KEY**


```

API calls are instance methods, and model class instances are returned as part of our callback.

e.g. 

```swift

        alchemyLanguageInstance.getEntities(requestType: .HTML,
            html: nil,
            url: "http://www.google.com",
            text: nil) {

            (error, entities) in

            // returned data is inside "entities" in this case
            // code here

       }

```


### Text to Speech

The Text to Speech service gives your app the ability to synthesize spoken text in a variety of voices.

Create a TextToSpeech service:

```swift
let service = TextToSpeech()
service.setUsernameAndPassword(username: "yourname", password: "yourpass")
```

To call the service to synthesize text:

```swift 
service.synthesize("Hello World", oncompletion: {
	data, error in 
	
	if let data = data {
	
	}
)
```

When the callback function is invoked, and the request was successful, the data object is an NSData structure containing WAVE formatted audio in 48kHz and mono-channel.

If you wish to play the audio through the device's speakers, create an AVAudioPlayer with that NSData object:

``` swift
let audioPlayer = try AVAudioPlayer(data: data)
audioPlayer.prepareToPlay()
audioPlayer.play()
```

The Watson TTS service contains support for many voices with different genders, languages, and dialects. For a complete list, see the [documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/text-to-speech/using.shtml#voices) or call the service's to list the possible voices in an asynchronous callback:

```swift
service.listVoices({
	voices, error in
	
	
})
```

For some example

Voice        | Language    | Gender
------------ | ----------- | --------------- 
de-DE_BirgitVoice     | German               | Female
de-DE_DieterVoice     | German               | Male
en-GB_KateVoice       | English (British)    | Female
en-US_AllisonVoice    | English (US)         | Female
en-US_LisaVoice       | English (US)         | Female
es-ES_Enrique         | Spanish (Castilian)  | Male
es-ES_Laura           | Spanish (Castilian)  | Female
es-US_Sofia           | Spanish (North American) | Female
fr-FR_Renee           | French               | Female
it-IT_Francesca       | Italian              | Female

To use the voice, such as Kate's, specify the voice identifier in the synthesize method:

```swift
service.synthesize("Hello World", voice: "en-GB_KateVoice", "oncompletion: {
	data, error in 
	
	if let data = data {
	
	}
)
```



## License

This library is licensed under Apache 2.0. Full license text is
available in [LICENSE](LICENSE).

This SDK is intended solely for use with an Apple iOS product and intended to be used in conjunction with officially licensed Apple development tools.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) on how to help out.

[personality_insights]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/personality-insights/
[language_identification]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/lidapi/
[machine_translation]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/mtapi/
[document_conversion]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/document-conversion/
[relationship_extraction]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/sireapi/
[language_translation]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/language-translation/
[visual_recognition]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/visual-recognition/
[tradeoff_analytics]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/tradeoff-analytics/
[text_to_speech]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/text-to-speech/
[speech_to_text]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/speech-to-text/
[tone-analyzer]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/tone-analyzer/
[dialog]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/dialog/
[concept-insights]: https://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/concept-insights/
[visual_insights]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/visual-insights/

[alchemy_language]: http://www.alchemyapi.com/products/alchemylanguage
[sentiment_analysis]: http://www.alchemyapi.com/products/alchemylanguage/sentiment-analysis
[alchemy_vision]: http://www.alchemyapi.com/products/alchemyvision
[alchemy_data_news]: http://www.alchemyapi.com/products/alchemydata-news


