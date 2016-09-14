# Watson Developer Cloud iOS SDK

[![Build Status](https://travis-ci.org/watson-developer-cloud/ios-sdk.svg?branch=master)](https://travis-ci.org/watson-developer-cloud/ios-sdk)
[![codecov.io](https://codecov.io/github/watson-developer-cloud/ios-sdk/coverage.svg?branch=master)](https://codecov.io/github/watson-developer-cloud/ios-sdk?branch=master)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Documentation](https://img.shields.io/badge/Documentation-API-blue.svg?style=flat)](http://watson-developer-cloud.github.io/ios-sdk/)
[![CLA assistant](https://cla-assistant.io/readme/badge/watson-developer-cloud/ios-sdk)](https://cla-assistant.io/watson-developer-cloud/ios-sdk)

## Overview

The Watson Developer Cloud iOS SDK makes it easy for mobile developers to build Watson-powered applications. With the iOS SDK you can leverage the power of Watson's advanced artificial intelligence, machine learning, and deep learning techniques to understand unstructured data and engage with mobile users in new ways.

Follow our [Quickstart Guide](https://github.com/watson-developer-cloud/ios-sdk/blob/master/Documentation/Quickstart.md) to build your first Watson-powered app!

## Contents

### General

* [Requirements](#requirements)
* [Installation](#installation)
* [Service Instances](#service-instances)
* [Xcode 7 Compatibility](#xcode-7-compatibility)
* [Contributing](#contributing)
* [License](#license)

### Services

* [AlchemyData News](#alchemydata-news)
* [AlchemyLanguage](#alchemylanguage)
* [Conversation](#conversation)
* [Dialog](#dialog)
* [Document Conversion](#document-conversion)
* [Language Translator](#language-translator)
* [Natural Language Classifier](#natural-language-classifier)
* [Personality Insights](#personality-insights)
* [Retrieve and Rank](#retrieve-and-rank)
* [Speech to Text](#speech-to-text)
* [Text to Speech](#text-to-speech)
* [Tone Analyzer](#tone-analyzer)
* [Tradeoff Analytics](#tradeoff-analytics)
* [Visual Recognition](#visual-recognition)

## Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 2.3+

## Installation

### Dependency Management

The Watson Developer Cloud iOS SDK uses [Carthage](https://github.com/Carthage/Carthage) to manage dependencies and build binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/):

```bash
$ brew update
$ brew install carthage
```

To use the Watson Developer Cloud iOS SDK in your application, specify it in your `Cartfile`:

```
github "watson-developer-cloud/ios-sdk"
```

Then run the following command to build the dependencies and frameworks:

```bash
$ carthage update --platform iOS
```

Finally, drag-and-drop the built frameworks into your Xcode project and import them as desired.

### App Transport Security

App Transport Security was introduced with iOS 9 to enforce secure Internet connections. To securely connect to IBM Watson services, please add the following exception to your application's `Info.plist` file.

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>watsonplatform.net</key>
        <dict>
            <key>NSTemporaryExceptionRequiresForwardSecrecy</key>
            <false/>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSTemporaryExceptionMinimumTLSVersion</key>
            <string>TLSv1.0</string>
        </dict>
    </dict>
</dict>
```

## Service Instances

[IBM Watson Developer Cloud](https://www.ibm.com/watson/developercloud/) offers a variety of services for developing cognitive applications. The complete list of Watson Developer Cloud services is available from the [services catalog](https://www.ibm.com/watson/developercloud/services-catalog.html). Services are instantiated using the [IBM Bluemix](http://www.ibm.com/cloud-computing/bluemix/) cloud platform.

Follow these steps to create a service instance and obtain its credentials:

1. Log in to Bluemix at [https://bluemix.net](https://bluemix.net).
2. Create a service instance:
    1. From the Dashboard, select "Use Services or APIs".
    2. Select the service you want to use.
    3. Click "Create".
3. Copy your service credentials:
    1. Click "Service Credentials" on the left side of the page.
    2. Copy the service's `username` and `password` (or `api_key` for Alchemy).

You will need to provide these service credentials in your mobile application. For example:

```swift
let textToSpeech = TextToSpeech(username: "your-username-here", password: "your-password-here")
```

Note that service credentials are different from your Bluemix username and password.

See [Getting Started](https://www.ibm.com/watson/developercloud/doc/getting_started/) for more information on getting started with the Watson Developer Cloud and Bluemix.

## Xcode 7 Compatibility

As of v0.8.0, the iOS SDK is written in Swift 2.3 using Xcode 8. Unfortunately, Swift 2.3 is not backwards compatible with Xcode 7. We are not committed to maintaining Xcode 7 support but may occasionally publish a v0.7.x release with critical bug fixes.

To continue using the iOS SDK with Xcode 7, we recommend following the v0.7.x release branch with the following change to your Cartfile:

`github "watson-developer-cloud/ios-sdk" ~> 0.7.0`

## Contributing

We would love any and all help! If you would like to contribute, please read our [CONTRIBUTING](https://github.com/watson-developer-cloud/ios-sdk/blob/master/.github/CONTRIBUTING.md) documentation with information on getting started.

## License

This library is licensed under Apache 2.0. Full license text is
available in [LICENSE](https://github.com/watson-developer-cloud/ios-sdk/blob/master/LICENSE).

This SDK is intended solely for use with an Apple iOS product and intended to be used in conjunction with officially licensed Apple development tools.

## AlchemyData News

AlchemyData News provides news and blog content enriched with natural language processing to allow for highly targeted search and trend analysis. Now you can query the world's news sources and blogs like a database.

The following example demonstrates how to use the AlchemyData News service:

```swift
import AlchemyDataNewsV1

let apiKey = "your-apikey-here"
let alchemyDataNews = AlchemyDataNews(apiKey: apiKey)

let start = "now-1d" // yesterday
let end = "now" // today
let query = [
    "q.enriched.url.title": "O[IBM^Apple]",
    "return": "enriched.url.title,enriched.url.entities.entity.text,enriched.url.entities.entity.type"
]
let failure = { (error: NSError) in print(error) }

alchemyDataNews.getNews(start, end: end, query: query, failure: failure) { news in
    print(news)
}
```

Refine your query by referring to the [Count and TimeSlice Queries](http://docs.alchemyapi.com/docs/counts) and [API Fields](http://docs.alchemyapi.com/docs/full-list-of-supported-news-api-fields) documentation.

The following links provide more information about the IBM AlchemyData News service:

* [IBM AlchemyData News - Service Page](https://www.ibm.com/watson/developercloud/alchemy-data-news.html)
* [IBM AlchemyData News - Documentation](http://docs.alchemyapi.com/)
* [IBM AlchemyData News - Demo](http://querybuilder.alchemyapi.com/builder)

## AlchemyLanguage

AlchemyLanguage is a collection of text analysis functions that derive semantic information from your content. You can input text, HTML, or a public URL and leverage sophisticated natural language processing techniques to get a quick high-level understanding of your content and obtain detailed insights such as directional sentiment from entity to object.

AlchemyLanguage has a number of features, including:

- Entity Extraction
- Sentiment Analysis
- Keyword Extraction
- Concept Tagging
- Relation Extraction
- Taxonomy Classification
- Author Extraction
- Language Detection
- Text Extraction
- Microformats Parsing
- Feed Detection

The following example demonstrates how to use the AlchemyLanguage service:

```swift
import AlchemyLanguageV1

let apiKey = "your-apikey-here"
let alchemyLanguage = AlchemyLanguage(apiKey: apiKey)

let url = "https://github.com/watson-developer-cloud/ios-sdk"
let failure = { (error: NSError) in print(error) }
alchemyLanguage.getTextSentiment(forURL: url, failure: failure) { sentiment in
    print(sentiment)
}
```

The following links provide more information about the IBM AlchemyLanguage service:

* [IBM AlchemyLanguage - Service Page](http://www.ibm.com/watson/developercloud/alchemy-language.html)
* [IBM AlchemyLanguage - Documentation](http://www.ibm.com/watson/developercloud/doc/alchemylanguage/)
* [IBM AlchemyLanguage - Demo](https://alchemy-language-demo.mybluemix.net/)

## Conversation

With the IBM Watson Conversation service you can create cognitive agents--virtual agents that combine machine learning, natural language understanding, and integrated dialog scripting tools to provide outstanding customer engagements.

The following example shows how to start a conversation with the Conversation service:

```swift
import ConversationV1

let username = "your-username-here"
let password = "your-password-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let conversation = Conversation(username: username, password: password, version: version)

let workspaceID = "your-workspace-id-here"
let failure = { (error: NSError) in print(error) }
var context: Context? // save context to continue conversation
conversation.message(workspaceID, failure: failure) { response in
    print(response.output.text)
    context = response.context
}
```

The following example shows how to continue an existing conversation with the Conversation service:

```swift
let text = "Turn on the radio."
let failure = { (error: NSError) in print(error) }
conversation.message(workspaceID, text: text, context: context, failure: failure) { response in
    print(response.output.text)
    context = response.context
}
```

The following links provide more information about the IBM Conversation service:

* [IBM Watson Conversation - Service Page](http://www.ibm.com/watson/developercloud/conversation.html)
* [IBM Watson Conversation - Documentation](http://www.ibm.com/watson/developercloud/doc/conversation/overview.shtml)

## Dialog

The IBM Watson Dialog service provides a comprehensive and robust platform for managing conversations between virtual agents and users through an application programming interface (API). Developers automate branching conversations that use natural language to automatically respond to user questions, cross-sell and up-sell, walk users through processes or applications, or even hand-hold users through difficult tasks.

To use the Dialog service, developers script conversations as they would happen in the real world, upload them to a Dialog application, and enable back-and-forth conversations with a user.

The following example demonstrates how to instantiate a `Dialog` object:

```swift
import DialogV1

let username = "your-username-here"
let password = "your-password-here"
let dialog = Dialog(username: username, password: password)
```

The following example demonstrates how to create a dialog application:

```swift
// store dialog id to access application
var dialogID: DialogID?

// load dialog file
guard let fileURL = NSBundle.mainBundle().URLForResource("your-dialog-filename", withExtension: "xml") else {
    print("Failed to locate dialog file.")
    return
}

// create dialog application
let name = "your-dialog-name"
let failure = { (error: NSError) in print(error) }
dialog.createDialog(dialogName, fileURL: fileURL, failure: failure) { dialogID in
    self.dialogID = dialogID
    print(dialogID)
}
```

The following example demonstrates how to start a conversation with a dialog application:

```swift
// store ids to continue conversation
var conversationID: Int?
var clientID: Int?

let failure = { (error: NSError) in print(error) }
dialog.converse(dialogID!, failure: failure) { response in
    self.conversationID = response.conversationID
    self.clientID = response.clientID
    print(response.response)
}
```

The following example demonstrates how to continue a conversation with a dialog application:

```swift
let input = "your-text-here"
let failure = { (error: NSError) in print(error) }
dialog.converse(dialogID!, conversationID: conversationID!, clientID: clientID!, input: input, failure: failure) { response in
    print(conversationResponse.response)
}
```

The following links provide more information about the IBM Watson Dialog service:

* [IBM Watson Dialog - Service Page](http://www.ibm.com/watson/developercloud/dialog.html)
* [IBM Watson Dialog - Documentation](http://www.ibm.com/watson/developercloud/doc/dialog/)
* [IBM Watson Dialog - Demo](http://dialog-demo.mybluemix.net/?cm_mc_uid=57695492765114489852726&cm_mc_sid_50200000=1449164796)

## Document Conversion

The IBM Watson Document Conversion Service converts a single HTML, PDF, or Microsoft Word™ document. The input document is transformed into normalized HTML, plain text, or a set of JSON-formatted Answer units that can be used with other Watson services, like the Watson Retrieve and Rank Service.

The following example demonstrates how to convert a document with the Document Conversation service:

```swift
import DocumentConversionV1

let username = "your-username-here"
let password = "your-password-here"
let version = "2015-12-15"
let documentConversion = DocumentConversion(username: username, password: password, version: version)

// load document
guard let document = NSBundle.mainBundle().URLForResource("your-dialog-filename", withExtension: "xml") else {
    print("Failed to locate dialog file.")
    return
}

// convert document
let config = documentConversion.writeConfig(ReturnType.Text)
let failure = { (error: NSError) in print(error) }
documentConversion.convertDocument(config, document: document, failure: failure) { text in
    print(text)
}
```

The following links provide more information about the IBM Document Conversion service:

* [IBM Watson Document Conversion - Service Page](http://www.ibm.com/watson/developercloud/document-conversion.html)
* [IBM Watson Document Conversion - Documentation](http://www.ibm.com/watson/developercloud/doc/document-conversion/)
* [IBM Watson Document Conversion - Demo](https://document-conversion-demo.mybluemix.net/)

## Language Translator

The IBM Watson Language Translator service lets you select a domain, customize it, then identify or select the language of text, and then translate the text from one supported language to another.

The following example demonstrates how to use the Language Translator service:

```swift
import LanguageTranslatorV2

let username = "your-username-here"
let password = "your-password-here"
let languageTranslator = LanguageTranslator(username: username, password: password)

let failure = { (error: NSError) in print(error) }
languageTranslator.translate("Hello", source: "en", target: "es", failure: failure) { translation in
    print(translation)
}
```

The following links provide more information about the IBM Watson Language Translator service:

* [IBM Watson Language Translator - Service Page](http://www.ibm.com/watson/developercloud/language-translation.html)
* [IBM Watson Language Translator - Documentation](http://www.ibm.com/watson/developercloud/doc/language-translation/)
* [IBM Watson Language Translator - Demo](https://language-translation-demo.mybluemix.net/)

## Natural Language Classifier

The IBM Watson Natural Language Classifier service enables developers without a background in machine learning or statistical algorithms to create natural language interfaces for their applications. The service interprets the intent behind text and returns a corresponding classification with associated confidence levels. The return value can then be used to trigger a corresponding action, such as redirecting the request or answering a question.

The following example demonstrates how to use the Natural Language Classifier service:

```swift
import NaturalLanguageClassifierV1

let username = "your-username-here"
let password = "your-password-here"
let naturalLanguageClassifier = NaturalLanguageClassifier(username: username, password: password)

let classifierID = "your-trained-classifier-id"
let text = "your-text-here"
let failure = { (error: NSError) in print(error) }
naturalLanguageClassifier.classify(classifierID, text: text, failure: failure) { classification in
    print(classification)
}
```

The following links provide more information about the Natural Language Classifier service:

* [IBM Watson Natural Language Classifier - Service Page](http://www.ibm.com/watson/developercloud/nl-classifier.html)
* [IBM Watson Natural Language Classifier - Documentation](http://www.ibm.com/watson/developercloud/doc/nl-classifier)
* [IBM Watson Natural Language Classifier - Demo](https://natural-language-classifier-demo.mybluemix.net/)

## Personality Insights

The IBM Watson Personality Insights service enables applications to derive insights from social media, enterprise data, or other digital communications. The service uses linguistic analytics to infer personality and social characteristics, including Big Five, Needs, and Values, from text.

The following example demonstrates how to use the Personality Insights service:

```swift
import PersonalityInsightsV2

let username = "your-username-here"
let password = "your-password-here"
let personalityInsights = PersonalityInsights(username: username, password: password)

let text = "your-input-text"
let failure = { (error: NSError) in print(error) }
personalityInsights.getProfile(text: text, failure: failure) { profile in
    print(profile)                      
}
```

The following links provide more information about the Personality Insights service:

* [IBM Watson Personality Insights - Service Page](http://www.ibm.com/watson/developercloud/personality-insights.html)
* [IBM Watson Personality Insights - Documentation](http://www.ibm.com/watson/developercloud/doc/personality-insights)
* [IBM Watson Personality Insights - Demo](https://personality-insights-livedemo.mybluemix.net)

## Retrieve and Rank

The IBM Watson Retrieve and Rank service combines Apache Solr and a machine learning algorithm, two information retrieval components, into a single service in order to provide users with the most relevant search information.

The following example demonstrates how to instantiate a `Retrieve and Rank` object.

```swift
import RetrieveAndRankV1

let username = "your-username-here"
let password = "your-password-here"
let retrieveAndRank = RetrieveAndRank(username: username, password: password)
```

The following example demonstrates how to create a Solr Cluster, configuration, and collection.

```swift
let failure = { (error: NSError) in print(error) }

// Create and store the Solr Cluster so you can access it later.
var cluster: SolrCluster?
retrieveAndRank.createSolrCluster("your-cluster-name-here", failure: failure) { solrCluster in
    cluster = solrCluster
}

// Load the configuration file.
guard let configFile = NSBundle.mainBundle().URLForResource("your-config-filename", withExtension: "zip") else {
    print("Failed to locate configuration file.")
    return
}
let configurationName = "your-config-name-here"
// Create the configuration. Make sure the Solr Cluster status is READY first.
retrieveAndRank.uploadSolrConfiguration(
    cluster.solrClusterID,
    configName: configurationName,
    zipFile: configFile,
    failure: failure)

// Create and store your Solr collection name.
let collectionName = "your-collection-name-here"
retrieveAndRank.createSolrCollection(
    cluster.solrClusterID,
    name: collectionName,
    configName: configurationName,
    failure)

// Load the documents you want to add to your collection.
guard let collectionFile = NSBundle.mainBundle().URLForResource("your-collection-filename", withExtension: "json") else {
    print("Failed to locate collection file.")
    return
}
// Upload the documents to your collection.
retrieveAndRank.updateSolrCollection(
    cluster.solrClusterID,
    collectionName: collectionName,
    contentType: "application/json",
    contentFile: collectionFile,
    failure: failure)
```

The following example demonstrates how to use the Retrieve and Rank service to retrieve answers without ranking them.

```swift
retrieveAndRank.search(
    cluster.solrClusterID,
    collectionName: collectionName,
    query: "your-query-here",
    returnFields: "your-return-fields-here",
    failure: failure) { response in
        
    print(response)
}
```

The following example demonstrates how to create and train a Ranker.

``` swift
// Load the ranker training data file.
guard let rankerTrainingFile = NSBundle.mainBundle().URLForResource("your-ranker-training-data-filename", withExtension: "json") else {
    print("Failed to locate collection file.")
    return
}

// Create and store the ranker.
var ranker = RankerDetails?
retrieveAndRank.createRanker(
    rankerTrainingFile,
    name: "your-ranker-name-here",
    failure: failure) { rankerDetails in
    
    ranker = rankerDetails
}
```

The following example demonstrates how to use the service to retrieve and rank the results.

```swift
retrieveAndRank.searchAndRank(
    cluster.solrClusterID,
    collectionName: collectionName,
    rankerID: ranker.rankerID,
    query: "your-query-here",
    returnFields: "your-return-fields-here",
    failure: failure) { response in
        
    print(response)
}
```

The following links provide more information about the Retrieve and Rank service:

* [IBM Watson Retrieve and Rank - Service Page](http://www.ibm.com/watson/developercloud/retrieve-rank.html)
* [IBM Watson Retrieve and Rank - Documentation](http://www.ibm.com/watson/developercloud/doc/retrieve-rank/)
* [IBM Watson Retrieve and Rank - Demo](http://retrieve-and-rank-demo.mybluemix.net/rnr-demo/dist/#/)

## Speech to Text

The IBM Watson Speech to Text service enables you to add speech transcription capabilities to your application. It uses machine intelligence to combine information about grammar and language structure to generate an accurate transcription. Transcriptions are supported for various audio formats and languages.

The `SpeechToText` class is the SDK's primary interface for performing speech recognition requests. It supports the transcription of audio files, audio data, and streaming microphone data. Advanced users, however, may instead wish to use the `SpeechToTextSession` class that exposes more control over the WebSockets session.

#### Recognition Request Settings

The `RecognitionSettings` class is used to define the audio format and behavior of a recognition request. These settings are transmitted to the service when [initating a request](https://www.ibm.com/watson/developercloud/doc/speech-to-text/websockets.shtml#WSstart).

The following example demonstrates how to define a recognition request that transcribes Opus-formatted audio data with interim results until the stream terminates:

```swift
var settings = RecognitionSettings(contentType: .WAV)
settings.interimResults = true
settings.continuous = true
```

See the [class documentation](http://watson-developer-cloud.github.io/ios-sdk/services/SpeechToTextV1/Structs/RecognitionSettings.html) or [service documentation](https://www.ibm.com/watson/developercloud/doc/speech-to-text/details.shtml) for more information about the available settings.

#### Microphone Audio and Compression

The Speech to Text framework makes it easy to perform speech recognition with microphone audio. The framework internally manages the microphone, starting and stopping it with various function calls (such as `recognizeMicrophone(settings:model:learningOptOut:compress:failure:success)` and `stopRecognizeMicrophone()` or `startMicrophone(compress:)` and `stopMicrophone()`).

Knowing when to stop the microphone depends upon the recognition request's `continuous` setting:
     
- If `false`, then the service ends the recognition request at the first end-of-speech incident (denoted by a half-second of non-speech or when the stream terminates). This will coincide with a `final` transcription result. So the `success` or `onResults` callback should be configured to stop the microphone when a final transcription result is received.

- If `true`, then the microphone will typically be stopped by user-feedback. For example, your application may have a button to start/stop the request, or you may stream the microphone for the duration of a long press on a UI element.

To reduce latency and bandwidth, the microphone audio is compressed to Opus format by default. To disable compression, set the `compress` parameter to `false`.

It's important to specify the correct audio format for recognition requests that use the microphone:

```swift
// compressed microphone audio uses the Opus format
let settings = RecognitionSettings(contentType: .Opus)

// uncompressed microphone audio uses a 16-bit mono PCM format at 16 kHz
let settings = RecognitionSettings(contentType: .L16(rate: 16000, channels: 1))
```

#### Transcribe Recorded Audio

The following example demonstrates how to use the Speech to Text service to transcribe a WAV audio file.

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToText = SpeechToText(username: username, password: password)

let audio = NSBundle.mainBundle().URLForResource("filename", withExtension: "wav")!
var settings = RecognitionSettings(contentType: .WAV)
settings.interimResults = true
let failure = { (error: NSError) in print(error) }
speechToText.recognize(audio, settings: settings, failure: failure) { results in
    print(results.bestTranscript)
}
```

#### Transcribe Microphone Audio

Audio can be streamed from the microphone to the Speech to Text service for real-time transcriptions. The following example demonstrates how to use the Speech to Text service to transcribe microphone audio:

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToText = SpeechToText(username: username, password: password)

func startStreaming() {
    var settings = RecognitionSettings(contentType: .Opus)
    settings.continuous = true
    settings.interimResults = true
    let failure = { (error: NSError) in print(error) }
    let request = speechToText.recognizeMicrophone(settings, failure: failure) { results in
        print(results.bestTranscript)
    }
}

func stopStreaming() {
    speechToText.stopRecognizeMicrophone()
}
```

#### Session Management and Advanced Features

Advanced users may want more customizability than provided by the `SpeechToText` class. The `SpeechToTextSession` class exposes more control over the WebSockets connection and also includes several advanced features for accessing the microphone. Before using `SpeechToTextSession`, it's helpful to be familiar with the [Speech to Text WebSocket interface](https://www.ibm.com/watson/developercloud/doc/speech-to-text/websockets.shtml).

The following steps describe how to execute a recognition request with `SpeechToTextSession`:

1. Connect: Invoke `connect()` to connect to the service.
2. Start Recognition Request: Invoke `startRequest(settings:)` to start a recognition request.
3. Send Audio: Invoke `recognize(audio:)` or `startMicrophone(compress:)`/`stopMicrophone()` to send audio to the service.
4. Stop Recognition Request: Invoke `stopRequest()` to end the recognition request. The service will automatically stop the request if the `continuous` setting is not set to `true`. If the recognition request is already stopped, then sending a stop message will have no effect.
5. Disconnect: Invoke `disconnect()` to wait for any remaining results to be received and then disconnect from the service.

All text and data messages sent by `SpeechToTextSession` are queued, with the exception of `connect()` which immediately connects to the server. The queue ensures that the messages are sent in-order and also buffers messages while waiting for a connection to be established. This behavior is generally transparent.

A `SpeechToTextSession` also provides several (optional) callbacks. The callbacks can be used to learn about the state of the session or access microphone data.

- `onConnect`: Invoked when the session connects to the Speech to Text service.
- `onMicrophoneData`: Invoked with microphone audio when a recording audio queue buffer has been filled. If microphone audio is being compressed, then the audio data is in Opus format. If uncompressed, then the audio data is in 16-bit PCM format at 16 kHz.
- `onPowerData`: Invoked every 0.025s when recording with the average dB power of the microphone.
- `onResults`: Invoked when transcription results are received for a recognition request.
- `onError`: Invoked when an error or warning occurs.
- `onDisconnect`: Invoked when the session disconnects from the Speech to Text service.

The following example demonstrates how to use `SpeechToTextSession` to transcribe microphone audio:

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToTextSession = SpeechToTextSession(username: username, password: password)

func startStreaming() {
    // define callbacks
    speechToTextSession.onConnect = { print("connected") }
    speechToTextSession.onDisconnect = { print("disconnected") }
    speechToTextSession.onError = { error in print(error) }
    speechToTextSession.onPower = { decibels in print(decibels) }
    speechToTextSession.onMicrophoneData = { data in print("received data") }
    speechToTextSession.onResults = { results in print(results.bestTranscript) }

    // define recognition request settings
    var settings = RecognitionSettings(contentType: .Opus)
    settings.interimResults = true
    settings.continuous = true

    // start streaming microphone audio for transcription
    speechToTextSession.connect()
    speechToTextSession.startRequest(settings)
    speechToTextSession.startMicrophone()
}

func stopStreaming() {
    speechToTextSession.stopMicrophone()
    speechToTextSession.stopRequest()
    speechToTextSession.disconnect()
}
```

#### Additional Information

The following links provide more information about the IBM Speech to Text service:

* [IBM Watson Speech to Text - Service Page](http://www.ibm.com/watson/developercloud/speech-to-text.html)
* [IBM Watson Speech to Text - Documentation](http://www.ibm.com/watson/developercloud/doc/speech-to-text/)
* [IBM Watson Speech to Text - Demo](https://speech-to-text-demo.mybluemix.net/)

## Text to Speech

The IBM Watson Text to Speech service synthesizes natural-sounding speech from input text in a variety of languages and voices that speak with appropriate cadence and intonation.

The following example demonstrates how to use the Text to Speech service:

```swift
import TextToSpeechV1

let username = "your-username-here"
let password = "your-password-here"
let textToSpeech = TextToSpeech(username: username, password: password)

let text = "your-text-here"
let failure = { (error: NSError) in print(error) }
textToSpeech.synthesize(text, failure: failure) { data in
    let audioPlayer = try AVAudioPlayer(data: data)
    audioPlayer.prepareToPlay()
    audioPlayer.play()
}
```

The Text to Speech service supports a number of [voices](http://www.ibm.com/watson/developercloud/doc/text-to-speech/using.shtml#voices) for different genders, languages, and dialects. The following example demonstrates how to use the Text to Speech service with a particular voice:

```swift
import TextToSpeechV1

let username = "your-username-here"
let password = "your-password-here"
let textToSpeech = TextToSpeech(username: username, password: password)

let text = "your-text-here"
let failure = { (error: NSError) in print(error) }
textToSpeech.synthesize(text, voice: SynthesisVoice.GB_Kate, failure: failure) { data in
    let audioPlayer = try AVAudioPlayer(data: data)
    audioPlayer.prepareToPlay()
    audioPlayer.play()
}
```

The following links provide more information about the IBM Text To Speech service:

* [IBM Watson Text To Speech - Service Page](http://www.ibm.com/watson/developercloud/text-to-speech.html)
* [IBM Watson Text To Speech - Documentation](http://www.ibm.com/watson/developercloud/doc/text-to-speech/)
* [IBM Watson Text To Speech - Demo](https://text-to-speech-demo.mybluemix.net/)

## Tone Analyzer

The IBM Watson Tone Analyzer service can be used to discover, understand, and revise the language tones in text. The service uses linguistic analysis to detect three types of tones from written text: emotions, social tendencies, and writing style.

Emotions identified include things like anger, fear, joy, sadness, and disgust. Identified social tendencies include things from the Big Five personality traits used by some psychologists. These include openness, conscientiousness, extraversion, agreeableness, and emotional range. Identified writing styles include confident, analytical, and tentative.

The following example demonstrates how to use the Tone Analyzer service:

```swift
import ToneAnalyzerV3

let username = "your-username-here"
let password = "your-password-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let toneAnalyzer = ToneAnalyzer(username: username, password: password, version: version)

let text = "your-input-text"
let failure = { (error: NSError) in print(error) }
toneAnalyzer.getTone(text, failure: failure) { tones in
    print(tones)
}
```

The following links provide more information about the IBM Watson Tone Analyzer service:

* [IBM Watson Tone Analyzer - Service Page](http://www.ibm.com/watson/developercloud/tone-analyzer.html)
* [IBM Watson Tone Analyzer - Documentation](http://www.ibm.com/watson/developercloud/doc/tone-analyzer/)
* [IBM Watson Tone Analyzer - Demo](https://tone-analyzer-demo.mybluemix.net/)

## Tradeoff Analytics

The IBM Watson Tradeoff Analytics service helps people make better choices when faced with multiple, often conflicting, goals and alternatives. By using mathematical filtering techniques to identify the best candidate options based on different criteria, the service can help users explore the tradeoffs between options to make complex decisions. The service combines smart visualization and analytical recommendations for easy and intuitive exploration of tradeoffs.

The following example demonstrates how to use the Tradeoff Analytics service:

```swift
import TradeoffAnalyticsV1

let username = "your-username-here"
let password = "your-password-here"
let tradeoffAnalytics = TradeoffAnalytics(username: username, password: password)

// define columns
let price = Column(
    key: "price",
    type: .Numeric,
    goal: .Minimize,
    isObjective: true
)
let ram = Column(
    key: "ram",
    type: .Numeric,
    goal: .Maximize,
    isObjective: true
)
let screen = Column(
    key: "screen",
    type: .Numeric,
    goal: .Maximize,
    isObjective: true
)
let os = Column(
    key: "os",
    type: .Categorical,
    isObjective: true,
    range: Range.CategoricalRange(categories: ["android", "windows-phone", "blackberry", "ios"]),
    preference: ["android", "ios"]
)

// define options
let galaxy = Option(
    key: "galaxy",
    values: ["price": .Int(50), "ram": .Int(45), "screen": .Int(5), "os": .String("android")],
    name: "Galaxy S4"
)
let iphone = Option(
    key: "iphone",
    values: ["price": .Int(99), "ram": .Int(40), "screen": .Int(4), "os": .String("ios")],
    name: "iPhone 5"
)
let optimus = Option(
    key: "optimus",
    values: ["price": .Int(10), "ram": .Int(300), "screen": .Int(5), "os": .String("android")],
    name: "LG Optimus G"
)

// define problem
let problem = Problem(
    columns: [price, ram, screen, os],
    options: [galaxy, iphone, optimus],
    subject: "Phone"
)

// define failure function
let failure = { (error: NSError) in print(error) }

// identify optimal options
tradeoffAnalytics.getDilemma(problem, failure: failure) { dilemma in
    print(dilemma.solutions)
}
```

The following links provide more information about the IBM Watson Tradeoff Analytics service:

* [IBM Watson Tradeoff Analytics - Service Page](http://www.ibm.com/watson/developercloud/tradeoff-analytics.html)
* [IBM Watson Tradeoff Analytics - Documentation](http://www.ibm.com/watson/developercloud/doc/tradeoff-analytics/)
* [IBM Watson Tradeoff Analytics - Demo](https://tradeoff-analytics-demo.mybluemix.net/)

## Visual Recognition

The IBM Watson Visual Recognition service uses deep learning algorithms to analyze images (.jpg or .png) for scenes, objects, faces, text, and other content, and return keywords that provide information about that content. The service comes with a set of built-in classes so that you can analyze images with high accuracy right out of the box. You can also train custom classifiers to create specialized classes.

The following example demonstrates how to use the Visual Recognition service:

The following example demonstrates how to use the Visual Recognition service to detect faces in an image:

```swift
import VisualRecognitionV3

let apiKey = "your-apikey-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)

let url = "your-image-url"
let failure = { (error: NSError) in print(error) }
visualRecognition.classify(url, failure: failure) { classifiedImages in
    print(classifiedImages)
}
```

The following links provide more information about the IBM Watson Visual Recognition service:

* [IBM Watson Visual Recognition - Service Page](http://www.ibm.com/watson/developercloud/visual-recognition.html)
* [IBM Watson Visual Recognition - Documentation](http://www.ibm.com/watson/developercloud/doc/visual-recognition/)
* [IBM Watson Visual Recognition - Demo](http://visual-recognition-demo.mybluemix.net/)
