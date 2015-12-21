# Watson Developer Cloud iOS SDK

[![Build Status](https://travis-ci.org/watson-developer-cloud/ios-sdk.svg?branch=master)](https://travis-ci.org/watson-developer-cloud/ios-sdk)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov.io](https://codecov.io/github/watson-developer-cloud/ios-sdk/coverage.svg?branch=master)](https://codecov.io/github/watson-developer-cloud/ios-sdk?branch=master)
[![Docs](https://img.shields.io/badge/Docs-0.1-green.svg?style=flat)](http://watson-developer-cloud.github.io/ios-sdk/)
[![Swift 2.1.1](https://img.shields.io/badge/Swift-2.1.1-green.svg?style=flat)](https://developer.apple.com/swift/)

The Watson Developer Cloud iOS SDK is a collection of services to allow developers to quickly add Watson Cognitive Computing services to their Swift iOS applications.

Visit our [Quickstart Guide](Quickstart.md) to build your first iOS app with Watson!

> *The Watson Developer Cloud iOS SDK is currently in beta.*

## Table of Contents
* [Installation](#installation)

* [IBM Watson Services](#ibm-watson-services)
  - [Alchemy Language](#alchemy-language)
  - [Alchemy Vision](#alchemy-vision)
  - [Dialog](#dialog)
  - [Language Translation](#language-translation)
  - [Natural Language Classifier](#natural-language-classifier)
  - [Personality Insights](#personality-insights)
  - [Speech to Text](#speech-to-text)
  - [Text to Speech](#text-to-speech)
* [Authentication](#authentication)
* [Building and Testing](#build--test)
* [Open Source @ IBM](#open-source--ibm)
* [License](#license)
* [Contributing](#contributing)

## Installation

The Watson Developer Cloud iOS SDK requires third-party dependencies such as ObjectMapper and Alamofire.  The dependency management tool Carthage is used to help manage those frameworks.  The recommended version of Carthage is v0.11 or higher.  

There are two main methods to install Carthage.  The first method is to download and run the Carthage.pkg installer.  You can locate the latest release [here.](https://github.com/Carthage/Carthage/releases)

The second method of installing is using Homebrew for the download and installation of carthage with the following commands

```shell
brew update && brew install carthage
```

Once the dependency manager is installed, the next step is to download the needed frameworks for the SDK to the project path.  Make sure you are in the root of the project directory and run the following command.  All of the frameworks can be found on the filesystem directory at location ./Carthage/Build/iOS/

``` shell
carthage update --platform iOS
```

For more details on using the iOS SDK in your application, please review the [Quickstart Guide](Quickstart.md).

**Frameworks Used:**

* [Alamofire](https://github.com/Alamofire/Alamofire)
* [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
* [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper/releases)
* [Starscream](https://github.com/daltoniam/Starscream)
* [HTTPStatusCodes](https://github.com/rhodgkins/SwiftHTTPStatusCodes)
* [XCGLogger](https://github.com/DaveWoodCom/XCGLogger)



## IBM Watson Services

**Getting started with Watson Developer Cloud and Bluemix**

The IBM Watson™ Developer Cloud (WDC) offers a variety of services for developing cognitive applications. Each Watson service provides a Representational State Transfer (REST) Application Programming Interface (API) for interacting with the service. Some services, such as the Speech to Text service, provide additional interfaces.

IBM Bluemix™ is the cloud platform in which you deploy applications that you develop with Watson Developer Cloud services. The Watson Developer Cloud documentation provides information for developing applications with Watson services in Bluemix. You can learn more about Bluemix from the following links:

The IBM Bluemix documentation, specifically the pages [What is Bluemix](https://www.ng.bluemix.net/docs/)? and the [Bluemix overview](https://www.ng.bluemix.net/docs/overview/index.html).
IBM developerWorks, specifically the [IBM Bluemix section of IBM developerWorks](https://www.ibm.com/developerworks/cloud/bluemix/) and the article that provides [An introduction to the application lifecycle on IBM Bluemix](http://www.ibm.com/developerworks/cloud/library/cl-intro-codename-bluemix-video/index.html?ca=dat).



### Alchemy Language

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

Instantiate an **AlchemyLanguage** object and set its api key via a **TokenAuthenticationStrategy**

```swift

let token = TokenAuthenticationStrategy(token: <API_KEY>)
let alchemyLanguageInstance = AlchemyLanguage(tokenAuthenticationStrategy: token)

```

API calls are instance methods, and model class instances are returned as part of our callback.

e.g.

```swift

alchemyLanguageInstance.getEntities(requestType: .URL,
  html: nil,
  url: "http://www.google.com",
  text: nil) {

    (error, entities) in

    // returned data is inside "entities" in this case
    // code here

}
```
### Alchemy Vision

AlchemyVision is an API that can analyze an image and return the objects, people, and text found within the image. AlchemyVision can enhance the way businesses make decisions by integrating image cognition.

##### Links
* AlchemyVision API docs [here](http://www.alchemyapi.com/products/alchemyla)
* Try out the [demo](http://www.alchemyapi.com/products/alchemyVision)

##### Requirements
* An Alchemy [API Key](http://www.alchemyapi.com/api/register.html)

##### Usage
Instantiate an **AlchemyVision** object and set its api key

```swift

let alchemyVisionInstance = AlchemyVision(apiKey: String)

```


API calls are instance methods, and model class instances are returned as part of our callback.

e.g.

```swift
serviceVision.recognizeFaces(VisionConstants.ImageFacesType.FILE,
    image: imageFromURL!,
    completionHandler: { imageFaceTags, error in

	// code here

})
```

### Dialog

The IBM Watson Dialog service provides a comprehensive and robust platform for managing conversations between virtual agents and users through an application programming interface (API). Developers automate branching conversations that use natural language to automatically respond to user questions, cross-sell and up-sell, walk users through processes or applications, or even hand-hold users through difficult tasks.

To use the Dialog service, developers script conversations as they would happen in the real world, upload them to a Dialog application, and enable back-and-forth conversations with a user.

Instantiate the Dialog service:

```swift
let service = Dialog(username: "yourusername", password: "yourpassword")
```

Create a Dialog application by uploading a Dialog file:

```swift
var dialogID: Dialog.DialogID?
service.createDialog(dialogName, fileURL: dialogFile) { dialogID, error in
	self.dialogID = dialogID
}
```

Start a conversation with the Dialog application:

```swift
var conversationID: Int?
var clientID: Int?
service.converse(dialogID!) { response, error in
	// save conversation parameters
	self.conversationID = response?.conversationID
	self.clientID = response?.clientID

	// print message from Watson
	print(response?.response)
}
```

Continue a conversation with the Dialog application:

```swift
service.converse(dialogID!, conversationID: conversationID!,
	clientID: clientID!, input: input) { response, error in

	// print message from Watson
	print(response?.response)
}
```

The following links provide additional information about the IBM Watson Dialog Service:

* [IBM Watson Dialog - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/dialog.html)
* [IBM Watson Dialog - Video](https://www.youtube.com/watch?v=Rn64SpnSq9I)
* [IBM Watson Dialog - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/dialog/)
* [IBM Watson Dialog - Demo](http://dialog-demo.mybluemix.net/?cm_mc_uid=57695492765114489852726&cm_mc_sid_50200000=1449164796)

### Language Translation

The IBM Watson™ Language Translation service provides an Application Programming Interface (API) that lets you select a domain, customize it, then identify or select the language of text, and then translate the text from one supported language to another.

How to instantiate and use the Language Translation service:

```swift
let service = LanguageTranslation(username: "yourusername", password: "yourpassword")
service.getIdentifiableLanguages({(languages:[IdentifiableLanguage]?, error) in

	// code here
})
```

The following links provide more information about the Language Translation service:

* [IBM Watson Language Translation - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/language-translation.html)
* [IBM Watson Language Translation - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/language-translation/)
* [IBM Watson Language Translation - Demo](https://language-translation-demo.mybluemix.net/)

### Natural Language Classifier

The IBM Watson™ Natural Language Classifier service uses machine learning algorithms to return the top matching predefined classes for short text inputs.

How to instantiate and use the Natural Language Classifier service:

```swift
let service = NaturalLanguageClassifier(username: "yourusername", password: "yourpassword")

service.classify(self.classifierIdInstanceId, text: "is it sunny?", completionHandler:{(classification, error) in

	// code here
})
```

The following links provide more information about the Natural Language Classifier service:

* [IBM Watson Natural Language Classifier - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/nl-classifier.html)
* [IBM Watson Natural Language Classifier - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/nl-classifier)
* [IBM Watson Natural Language Classifier - Demo](https://natural-language-classifier-demo.mybluemix.net/)

### Personality Insights

The IBM Watson™ Personality Insights service provides an Application Programming Interface (API) that enables applications to derive insights from social media, enterprise data, or other digital communications. The service uses linguistic analytics to infer personality and social characteristics, including Big Five, Needs, and Values, from text.

```swift
let service = PersonalityInsights(username: "yourusername", password: "yourpassword")

service!.getProfile("Some text here") { profile, error in

    // code here
}
```

The following links provide more information about the Personality Insights service:

* [IBM Watson Personality Insights - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/personality-insights.html)
* [IBM Watson Personality Insights - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/personality-insights)
* [IBM Watson Personality Insights - Demo](https://personality-insights-demo.mybluemix.net/)

### Speech to Text

The IBM Watson Speech to Text service uses speech recognition capabilities to convert English, Spanish, Brazilian Portuguese, Japanese, and Mandarin speech into text. The services takes audio data encoded in [Opus/OGG](https://www.opus-codec.org/), [FLAC](https://xiph.org/flac/), WAV, and Linear 16-bit PCM uncompressed formats. The service automatically downmixes to one channel during transcoding.

Create a SpeechToText service:

```swift
let stt = SpeechToText(authStrategy: strategy)
```

You can create an AVAudioRecorder with the necessary settings:

```swift

let filePath = NSURL(fileURLWithPath: "\(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])/SpeechToTextRecording.wav")

let session = AVAudioSession.sharedInstance()
var settings = [String: AnyObject]()

settings[AVSampleRateKey] = NSNumber(float: 44100.0)
settings[AVNumberOfChannelsKey] = NSNumber(int: 1)
do {
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        recorder = try AVAudioRecorder(URL: filePath, settings: settings)
} catch {
        // error
}
```

To make a call for transcription, use:

```swift
let data = NSData(contentsOfURL: recorder.url)

if let data = data {

        sttService.transcribe(data , format: .WAV, oncompletion: {

            response, error in

            // code here
        }
}
```



The following links provide additional information about the IBM Speech to Text service:

* [IBM Watson Speech to Text - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/speech-to-text.html)
* [IBM Watson Speech to Text - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/speech-to-text/)
* [IBM Watson Speech to Text - Demo](https://speech-to-text-demo.mybluemix.net/)


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
	     // code here
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
	  // code here

})
```

The following voices can be used:

Voice        | Language    | Gender
------------ | ----------- | ---------------
de-DE_BirgitVoice     | German               | Female
de-DE_DieterVoice     | German               | Male
en-GB_KateVoice       | English (British)    | Female
en-US_AllisonVoice    | English (US)         | Female
en-US_LisaVoice       | English (US)         | Female
es-ES_EnriqueVoice    | Spanish (Castilian)  | Male
es-ES_LauraVoice      | Spanish (Castilian)  | Female
es-US_SofiaVoice      | Spanish (North American) | Female
fr-FR_ReneeVoice      | French               | Female
it-IT_FrancescaVoice  | Italian              | Female

To use the voice, such as Kate's, specify the voice identifier in the synthesize method:

```swift
service.synthesize("Hello World", voice: "en-GB_KateVoice", "oncompletion: {
	data, error in

	if let data = data {
		// code here
	}
)
```

The following links provide more information about the Text To Speech service:

* [IBM Watson Text To Speech - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/text-to-speech.html)
* [IBM Text To Speech - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/text-to-speech/)
* [IBM Text To Speech - Demo](https://text-to-speech-demo.mybluemix.net/)

## Authentication

IBM Watson Services are hosted in the Bluemix platform. Before you can use each service in the SDK, the service must first be created in Bluemix, bound to an Application, and you must have the credentials that Bluemix generates for that service. Alchemy services use a single API key, and all the other Watson services use a username and password credential. For the services that have username and password credentials, a web service is used to grant a temporary Watson token to the client that can be used for subsequent calls.

It is not advisable in a full production app to embed the username and passwords in your application, since the application could be decompiled to extract those credentials. Instead, these credentials should remain on a deployed server, and should handle fetching the Watson token on behalf of the mobile application. Since there could be many strategies one could take to authenticate with Bluemix, we abstract the mechanism with a collection of classes that use the protocol *AuthenticationStrategy*.

To quickly get started with the SDK, you can use a *BasicAuthenticationStrategy*  when you create a service. You can specify the username and password, and it automatically handles fetching a temporary key from the token server. If the token expires, the strategy will fetch a new one.

You can create a new AuthenticationStrategy unique for your application by creating a new class using the *AuthenticationStrategy* protocol. The required method *refreshToken* must be implemented and this is responsible for fetching a new token from a web services and storing the internal property token inside of the class.

## Build + Test

***XCode*** is used to build the project for testing and deployment.  Select Product->Build For->Testing to build the project in XCode's menu.  

In order to build the project and run the unit tests, a **credentials.plist** file needs to be populated with proper credentials in order to comumnicate with the running Watson services.  A copy of this file is located in the project's folder under **WatsonDeveloperCloudTests**.  The **credentials.plist** file contains a key and value for each service's user name and password.  For example, Personality Insights has a key of PersonalityInsightsUsername for the user name and a key of PersonalityInsightsPassword for the password.  A user name and password can be optained from a running Watson service on Bluemix.  Please refer to the [IBM Watson Services](#ibm-watson-services) section for more information about Watson Services and Bluemix

There are many tests already in place, positive and negative, that can be displayed when selecting the Test Navigator in XCode.  Right click on the test you want to run and select Test in the context menu to run that specific test.  You can also select a full node and right-click to run all of the tests in that node or service.  

Tests can be found in the **WatsonDeveloperCloudTests** target, as well as in each individual service’s directory. All of them can be run through Xcode’s testing interface using [XCTest](https://developer.apple.com/library/ios/recipes/xcode_help-test_navigator/RunningTests/RunningTests.html#//apple_ref/doc/uid/TP40013329-CH4-SW1). Travis CI will also execute tests for pull requests and pushes to the repository.

## Open Source @ IBM
Find more open source projects on the [IBM Github Page](http://ibm.github.io/)

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
