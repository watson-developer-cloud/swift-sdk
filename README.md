# Watson Developer Cloud iOS SDK

[![Build Status](https://travis-ci.org/watson-developer-cloud/ios-sdk.svg?branch=master)](https://travis-ci.org/watson-developer-cloud/ios-sdk)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov.io](https://codecov.io/github/watson-developer-cloud/ios-sdk/coverage.svg?branch=master)](https://codecov.io/github/watson-developer-cloud/ios-sdk?branch=master)
[![Docs](https://img.shields.io/badge/Docs-0.3.0-green.svg?style=flat)](http://watson-developer-cloud.github.io/ios-sdk/)
[![Swift 2.2](https://img.shields.io/badge/Swift-2.2-green.svg?style=flat)](https://developer.apple.com/swift/)

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
  - [Tone Analyzer](#tone-analyzer)
  - [Visual Recognition](#visual-recognition)
* [Authentication](#authentication)
* [Building and Testing](#build--test)
* [Open Source @ IBM](#open-source--ibm)
* [License](#license)
* [Contributing](#contributing)

## Upgrading to Xcode 7.3

Apple released Xcode 7.3 and Swift 2.2 on March 21, 2016. To use the Watson Developer Cloud iOS SDK with Xcode 7.3 you will have to rebuild all dependencies (including those with pre-built binaries) because there is no binary compatability between Swift 2.1 and Swift 2.2.

Please use the terminal to navigate to your project directory and execute the following command: `carthage update --platform iOS --no-use-binaries`

This will rebuild all dependencies (including those with pre-built binaries) using Xcode 7.3 and Swift 2.2. Be aware that you will receive many warnings related to deprecations that will occur in Swift 3. These warnings do not affect the operation of the SDK and will be addressed in future releases of our dependencies.

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
* [Freddy](https://github.com/Alamofire/Alamofire)
* [Starscream](https://github.com/daltoniam/Starscream)

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

let alchemyLanguage = AlchemyLanguage(apiKey: "your-apikey-here")

```

API calls are instance methods, and model class instances are returned as part of our callback.

e.g.

```swift

alchemyLanguage.getEntities(requestType: .URL,
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
* AlchemyVision API docs [here](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/alchemy-vision.html)
* Try out the [demo](http://vision.alchemy.ai)

##### Requirements
* An Alchemy [API Key](http://www.alchemyapi.com/api/register.html)

##### Usage
Instantiate an **AlchemyVision** object and set its api key

```swift

let alchemyVision = AlchemyVision(apiKey: "your-apikey-here")

```


API calls are instance methods, and model class instances are returned as part of our callback.

e.g.

```swift
let failure = { (error: NSError) in print(error) }

alchemyVision.getRankedImageFaceTags(url: url,
                                     failure: failure) { facetags in
	code here
}
```

### Dialog

The IBM Watson Dialog service provides a comprehensive and robust platform for managing conversations between virtual agents and users through an application programming interface (API). Developers automate branching conversations that use natural language to automatically respond to user questions, cross-sell and up-sell, walk users through processes or applications, or even hand-hold users through difficult tasks.

To use the Dialog service, developers script conversations as they would happen in the real world, upload them to a Dialog application, and enable back-and-forth conversations with a user.

Instantiate the Dialog service:

```swift
let dialog = Dialog(username: "your-username-here", password: "your-password-here")
```

Create a Dialog application by uploading a Dialog file:

```swift
var dialogID: Dialog.DialogID?
let failure = { (error: NSError) in print(error) }
dialog.createDialog(dialogName,
                    fileURL: fileURL,
                    failure: failure) { (dialogID) in
    // code here
}
```

Start a conversation with the Dialog application:

```swift
var conversationID: Int?
var clientID: Int?
let failure = { (error: NSError) in print(error) }
dialog.converse(dialogID!,
                failure: failure) { conversationResponse in
    // save conversation parameters
    self.conversationID = conversationResponse.conversationID
    self.clientID = conversationResponse.clientID
    
    // print message from Watson
    print(conversationResponse.response)
}
```

Continue a conversation with the Dialog application:

```swift
let failure = { (error: NSError) in print(error) }
dialog.converse(dialogID!,
                conversationID: conversationID!,
                clientID: clientID!,
                input: input,
                failure: failure) { conversationResponse in
                
    // print message from Watson
    print(conversationResponse.response)
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
let languageTranslation = LanguageTranslation(username: "your-username-here", password: "your-password-here")
let failure = { (error: NSError) in print(error) }
languageTranslation.getIdentifiableLanguages(failure) { identifiableLanguage in
    // code here
}
```

The following links provide more information about the Language Translation service:

* [IBM Watson Language Translation - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/language-translation.html)
* [IBM Watson Language Translation - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/language-translation/)
* [IBM Watson Language Translation - Demo](https://language-translation-demo.mybluemix.net/)

### Natural Language Classifier

The IBM Watson™ Natural Language Classifier service uses machine learning algorithms to return the top matching predefined classes for short text inputs.

How to instantiate and use the Natural Language Classifier service:

```swift
let naturalLanguageClassifier = NaturalLanguageClassifier(username: "your-username-here", password: "your-password-here")
let failure = { (error: NSError) in print(error) }
naturalLanguageClassifier.classify(self.classifierIdInstanceId,
                                   text: "is it sunny?",
                                   failure: failure) { classification in
    // code here
}
```

The following links provide more information about the Natural Language Classifier service:

* [IBM Watson Natural Language Classifier - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/nl-classifier.html)
* [IBM Watson Natural Language Classifier - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/nl-classifier)
* [IBM Watson Natural Language Classifier - Demo](https://natural-language-classifier-demo.mybluemix.net/)

### Personality Insights

The IBM Watson™ Personality Insights service provides an Application Programming Interface (API) that enables applications to derive insights from social media, enterprise data, or other digital communications. The service uses linguistic analytics to infer personality and social characteristics, including Big Five, Needs, and Values, from text.

```swift
let personalityInsights = PersonalityInsights(username: "your-username-here", password: "your-password-here")
let failure = { (error: NSError) in print(error) }
personalityInsights.getProfile(text: "Some text here",
                               failure: failure) { profile in
    // code here                          
}
```

The following links provide more information about the Personality Insights service:

* [IBM Watson Personality Insights - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/personality-insights.html)
* [IBM Watson Personality Insights - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/personality-insights)
* [IBM Watson Personality Insights - Demo](https://personality-insights-livedemo.mybluemix.net)

### Speech to Text

The IBM Watson Speech to Text service enables you to add speech transcription capabilities to your application. It uses machine intelligence to combine information about grammar and language structure to generate an accurate transcription. Transcriptions are supported for various audio formats and languages.

#### Recorded Audio

The following example demonstrates how to use the Speech to Text service to transcribe an audio file.

```swift
let bundle = NSBundle(forClass: self.dynamicType)
guard let fileURL = bundle.URLForResource("filename", withExtension: "wav") else {
	print("File could not be loaded.")
	return
}

let speechToText = SpeechToText(username: "your-username-here", password: "your-password-here")
let settings = TranscriptionSettings(contentType: .WAV)
let failure = { (error: NSError) in print(error) }

speechToText.transcribe(fileURL,
                        settings: settings,
                        failure: failure) { results in
    if let transcription = results.last?.alternatives.last?.transcript {
        print(transcription)
    }
}
```

#### Streaming Audio

Audio can also be streamed from the microphone to the Speech to Text service for real-time transcriptions. The following example demonstrates how to use the Speech to Text service with streaming audio. (Unfortunately, the microphone is not accessible from within the Simulator. Only applications on a physical device can stream microphone audio to Speech to Text.)

```swift
let speechToText = SpeechToText(username: "your-username-here", password: "your-password-here")

var settings = TranscriptionSettings(contentType: .L16(rate: 44100, channels: 1))
settings.continuous = true
settings.interimResults = true

let failure = { (error: NSError) in print(error) }
let stopStreaming = speechToText.transcribe(settings,
                                            failure: failure) { results in
    if let transcription = results.last?.alternatives.last?.transcript {
        print(transcription)
    }
}

// Streaming will continue until either an end-of-speech event is detected by
// the Speech to Text service or the `stopStreaming` function is executed.
```

#### Custom Capture Sessions

Advanced users who want to create and manage their own `AVCaptureSession` can construct an `AVCaptureAudioDataOutput` to stream audio to the Speech to Text service. This is particularly useful for users who would like to visualize an audio waveform, save audio to disk, or otherwise access the microphone audio data while simultaneously streaming to the Speech to Text service.

The following example demonstrates how to use an `AVCaptureSession` to stream audio to the Speech to Text service.

```swift
class ViewController: UIViewController {
    var captureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let speechToText = SpeechToText(username: "your-username-here", password: "your-password-here")
        
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else {
            return
        }
        
        let microphoneDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        let microphoneInput = try? AVCaptureDeviceInput(device: microphoneDevice)
        if captureSession.canAddInput(microphoneInput) {
            captureSession.addInput(microphoneInput)
        }
        
        var settings = TranscriptionSettings(contentType: .L16(rate: 44100, channels: 1))
        settings.continuous = true
        settings.interimResults = true
        
        let failure = { (error: NSError) in print(error) }
        let outputOpt = speechToText.createTranscriptionOutput(settings,
                                                               failure: failure) { results in
            if let transcription = results.last?.alternatives.last?.transcript {
                print(transcription)
            }
        }
        
        guard let output = outputOpt else {
            return
        }
        let transcriptionOutput = output.0
        let stopStreaming = output.1
        
        if captureSession.canAddOutput(transcriptionOutput) {
            captureSession.addOutput(transcriptionOutput)
        }
        
        captureSession.startRunning()
    }
    
    // Streaming will continue until either an end-of-speech event is detected by
    // the Speech to Text service, the `stopStreaming` function is executed, or
    // the capture session is stopped.
```
#### Additional Information

The following links provide additional information about the IBM Speech to Text service:

* [IBM Watson Speech to Text - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/speech-to-text.html)
* [IBM Watson Speech to Text - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/speech-to-text/)
* [IBM Watson Speech to Text - Demo](https://speech-to-text-demo.mybluemix.net/)

### Text to Speech

The Text to Speech service gives your app the ability to synthesize spoken text in a variety of voices.

Create a TextToSpeech service:

```swift
let textToSpeech = TextToSpeech(username: "your-username-here", password: "your-password-here")
```

To call the service to synthesize text:

```swift
let failure = { (error: NSError) in print(error) }
textToSpeech.synthesize("Hello World", failure: failure) { data in
        // code here
}
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
let failure = { (error: NSError) in print(error) }
textToSpeech.getVoices(failure) { voices in
    	  // code here
}
```

You can review the different voices and languages [here](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/text-to-speech/using.shtml#voices).

To use the voice, such as Kate's, specify the voice identifier in the synthesize method:

```swift
textToSpeech.synthesize("Hello World", voice: SynthesisVoice.GB_Kate) { data in
    // code here
}
```

The following links provide more information about the Text To Speech service:

* [IBM Watson Text To Speech - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/text-to-speech.html)
* [IBM Watson Text To Speech - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/text-to-speech/)
* [IBM Watson Text To Speech - Demo](https://text-to-speech-demo.mybluemix.net/)

### Tone Analyzer

The Tone Analyzer service uses linguistic analysis to detect three types of tones from text: emotion, social tendencies, and language style.

How to instantiate and use the Tone Analyzer service:

```swift
let username = "your-username-here"
let password = "your-password-here"
let versionDate = "YYYY-MM-DD" // use today's date for the most recent version
let service = ToneAnalyzer(username: username, password: password, versionDate: versionDate)

let failure = { (error: NSError) in print(error) }
service.getTone("Text that you want to get the tone of", failure: failure) { responseTone in
    print(responseTone.documentTone)
}
```

The following links provide more information about the Text To Speech service:

* [IBM Watson Tone Analyzer - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/tone-analyzer.html)
* [IBM Watson Tone Analyzer - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/tone-analyzer/)
* [IBM Watson Tone Analyzer - Demo](https://tone-analyzer-demo.mybluemix.net/)

### Visual Recognition

The Tone Analyzer service uses linguistic analysis to detect three types of tones from text: emotion, social tendencies, and language style.

How to instantiate and use the Tone Analyzer service:

```swift
let apiKey = "your-apikey-here"
let versionDate = "YYYY-MM-DD" // use today's date for the most recent version

let service = VisualRecognition(apiKey: apiKey, version: versionDate)

let failure = { (error: NSError) in print(error) }
service.detectFaces(url, failure: failure) { imagesWithFaces in
    // code here
}
```

The following links provide more information about the Text To Speech service:

* [IBM Watson Visual Recognition - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/visual-recognition.html)
* [IBM Watson Visual Recognition - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/visual-recognition/)
* [IBM Watson Visual Recognition - Demo](http://visual-recognition-demo.mybluemix.net/)

## Authentication

IBM Watson Services are hosted in the Bluemix platform. Before you can use each service in the SDK, the service must first be created in Bluemix, bound to an Application, and you must have the credentials that Bluemix generates for that service. Alchemy services use a single API key, and all the other Watson services use a username and password credential. For the services that have username and password credentials, a web service is used to grant a temporary Watson token to the client that can be used for subsequent calls.

It is not advisable in a full production app to embed the username and passwords in your application, since the application could be decompiled to extract those credentials. Instead, these credentials should remain on a deployed server, and should handle fetching the Watson token on behalf of the mobile application.


## Build + Test

***XCode*** is used to build the project for testing and deployment.  Select Product->Build For->Testing to build the project in XCode's menu.  

In order to build the project and run the unit tests, a **credentials.plist** file needs to be populated with proper credentials in order to comumnicate with the running Watson services.  A copy of this file is located in the project's folder under **Source/SupportingFiles**.  The **credentials.plist** file contains a key and value for each service's user name and password.  For example, Personality Insights has a key of PersonalityInsightsUsername for the user name and a key of PersonalityInsightsPassword for the password.  A user name and password can be optained from a running Watson service on Bluemix.  Please refer to the [IBM Watson Services](#ibm-watson-services) section for more information about Watson Services and Bluemix

There are many tests already in place, positive and negative, that can be displayed when selecting the Test Navigator in XCode.  Right click on the test you want to run and select Test in the context menu to run that specific test.  You can also select a full node and right-click to run all of the tests in that node or service.  

Tests can be found in the **ServiceName+Tests** target, as well as in each individual service’s directory. All of them can be run through Xcode’s testing interface using [XCTest](https://developer.apple.com/library/ios/recipes/xcode_help-test_navigator/RunningTests/RunningTests.html#//apple_ref/doc/uid/TP40013329-CH4-SW1). Travis CI will also execute tests for pull requests and pushes to the repository.

## Open Source @ IBM
Find more open source projects on the [IBM Github Page](http://ibm.github.io/)

## License

This library is licensed under Apache 2.0. Full license text is
available in [LICENSE](LICENSE).

This SDK is intended solely for use with an Apple iOS product and intended to be used in conjunction with officially licensed Apple development tools.

## Contributing

See [CONTRIBUTING](.github/CONTRIBUTING.md) on how to help out.

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
