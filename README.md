# Watson iOS SDK


[![Build Status](https://magnum.travis-ci.com/IBM-MIL/Watson-iOS-SDK.svg?token=YPHGLjpSd2i3xBsMhsyL&branch=master)](https://magnum.travis-ci.com/IBM-MIL/Watson-iOS-SDK) [![codecov.io](http://codecov.io/github/IBM-MIL/Watson-iOS-SDK/coverage.svg?branch=develop)](https://codecov.io/github/IBM-MIL/Watson-iOS-SDK?branch=develop)

The Watson iOS SDK is a collection of services to allow developers to quickly add Watson Cognitive Computing services to their Swift 2.0+ applications.

[Quickstart Guide](https://github.com/IBM-MIL/Watson-iOS-SDK/blob/develop/Quickstart.md)

## Table of Contents
* [Installation](#installation)
* [Usage](#usage)
* [Examples](#examples)
* [IBM Watson Services](#ibm-watson-services)
	* [Alchemy Language](#alchemylanguage)
	* [Alchemy Vision](#alchemyvision)
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
 
The Watson iOS SDK requires third-party dependencies such as ObjectMapper and Alamofire.  The dependency managagment tool Carthage is used to help manage those frameworks.  There are two main methods to install Carthage.  The first method is to download and run the Carthage.pkg installer.  You can locate the latest release [here.](https://github.com/Carthage/Carthage/releases)

The second method of installing is using Homebrew for the download and installation of carthage with the following commands

```
brew update && brew install carthage
```

Once the dependency manager is installed, the next step is to download the needed frameworks for the SDK to the project path.  Make sure you are in the root of the project directory and run the following command.

``` 
carthage update
```


## Examples 


A sample app can be found in the [WatsonSDK-DemoApplication](../../tree/master/Examples/WatsonSDK-DemoApplication) folder. The sample app demonstrates how instantiate and use some of the provided Watson SDK Services.


## Tests

Tests can be found in the 'BoxContentSDKTests' target. [Use XCode to execute the tests](https://developer.apple.com/library/ios/recipes/xcode_help-test_navigator/RunningTests/RunningTests.html#//apple_ref/doc/uid/TP40013329-CH4-SW1). Travis CI will also execute tests for pull requests and pushes to the repository.

## IBM Watson Services

The Watson Developer Cloud offers a variety of services for building cognitive applications.


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

Instantiate an **AlchemyLanguage** object and set its api key

```swift

let alchemyLanguageInstance = AlchemyLanguage(apiKey: String)

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
let service = Dialog(user: "yourusername", password: "yourpassword")
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
let service = LanguageTranslation(user: "yourusername", password: "yourpassword")
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
let service = NaturalLanguageClassifier(user: "yourusername", password: "yourpassword")

service.classify(self.classifierIdInstanceId, text: "is it sunny?", completionHandler:{(classification, error) in

	// code here
})
```

The following links provide more information about the Natural Language Classifier service:

* [IBM Watson Natural Language Classifier - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/nl-classifier.html)
* [IBM Watson Natural Language Classifier - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/nl-classifier)
* [IBM Watson Natural Language Classifier - Demo](https://natural-language-classifier-demo.mybluemix.net/)

### Personanlity Insights

The IBM Watson™ Personality Insights service provides an Application Programming Interface (API) that enables applications to derive insights from social media, enterprise data, or other digital communications. The service uses linguistic analytics to infer personality and social characteristics, including Big Five, Needs, and Values, from text. 

```swift
let service = PersonalityInsights(user: "yourusername", password: "yourpassword")

service!.getProfile("Some text here") { profile, error in
    
    // code here
}
```

The following links provide more information about the Personality Insights service:

* [IBM Watson Personality Insights - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/personality-insights.html)
* [IBM Watson Personality Insights - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/personality-insights)
* [IBM Watson Personality Insights - Demo](https://personality-insights-demo.mybluemix.net/)

### Speech to Text

The IBM Watson Speech to Text service uses speech recognition capabilities to convert English, Spanish, Brazilian Portuguese, Japanese, and Mandarin speech into text.

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

The following links provide more information about the Text To Speech service:

* [IBM Watson Text To Speech - Service Page](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/text-to-speech.html)
* [IBM Text To Speech - Documentation](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/text-to-speech/)
* [IBM Text To Speech - Demo](https://text-to-speech-demo.mybluemix.net/)

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


