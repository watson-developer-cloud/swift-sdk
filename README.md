# Watson iOS SDK


[![Build Status](https://magnum.travis-ci.com/IBM-MIL/Watson-iOS-SDK.svg?token=YPHGLjpSd2i3xBsMhsyL&branch=master)](https://magnum.travis-ci.com/IBM-MIL/Watson-iOS-SDK) [![codecov.io](http://codecov.io/github/IBM-MIL/Watson-iOS-SDK/coverage.svg?branch=develop)](https://codecov.io/github/IBM-MIL/Watson-iOS-SDK?branch=develop)

## Table of Contents
* [Installation](#installation)
* [Usage](#usage)
* [Examples](#examples)
* [IBM Watson Services](#ibm-watson-services)
	* [Alchemy Language](#alchemy-language)
	* [Alchemy Vision](#alchemy-vision)
	* [Dialog](#dialog)
	* [Language Translation](#language-translation)
	* [Natural Language Classifier](#natural-language-classifier)
	* [Personality Insights](#personality-insights)
	* [Speech to Text](#speech-to-text)	
	* [Text to Speech](#text-to-speech)

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


### Alchemy Language


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

Probably Apache 2.0

## Contributing

**Stub text, insert text here when ready.**

See [CONTRIBUTING](CONTRIBUTING.md) on how to help out.

