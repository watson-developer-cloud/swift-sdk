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





## License

Probably Apache 2.0

## Contributing

**Stub text, insert text here when ready.**

See [CONTRIBUTING](CONTRIBUTING.md) on how to help out.

