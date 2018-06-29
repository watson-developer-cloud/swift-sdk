# Watson Developer Cloud Swift SDK

[![Build Status](https://travis-ci.org/watson-developer-cloud/swift-sdk.svg?branch=master)](https://travis-ci.org/watson-developer-cloud/swift-sdk)
![](https://img.shields.io/badge/platform-iOS,%20Linux-blue.svg?style=flat)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Documentation](https://img.shields.io/badge/Documentation-API-blue.svg)](http://watson-developer-cloud.github.io/swift-sdk)
[![CLA assistant](https://cla-assistant.io/readme/badge/watson-developer-cloud/swift-sdk)](https://cla-assistant.io/watson-developer-cloud/swift-sdk)

## Overview

The Watson Developer Cloud Swift SDK makes it easy for mobile developers to build Watson-powered applications. With the Swift SDK you can leverage the power of Watson's advanced artificial intelligence, machine learning, and deep learning techniques to understand unstructured data and engage with mobile users in new ways.

There are many resources to help you build your first cognitive application with the Swift SDK:

- Read the [Readme](README.md)
- Follow the [QuickStart Guide](docs/quickstart.md)
- Review a [Sample Application](#sample-applications)
- Browse the [Documentation](http://watson-developer-cloud.github.io/swift-sdk/)

## Contents

### General

* [Before you begin](#before-you-begin)
* [Requirements](#requirements)
* [Installation](#installation)
* [Service Instances](#service-instances)
* [Custom Service URLs](#custom-service-urls)
* [Custom Headers](#custom-headers)
* [Sample Applications](#sample-applications)
* [Synchronous Execution](#synchronous-execution)
* [Objective-C Compatibility](#objective-c-compatibility)
* [Linux Compatibility](#linux-compatibility)
* [Contributing](#contributing)
* [License](#license)

### Services

* [Assistant](#assistant)
* [Discovery](#discovery)
* [Language Translator V2](#language-translator-v2)
* [Language Translator V3](#language-translator-v3)
* [Natural Language Classifier](#natural-language-classifier)
* [Natural Language Understanding](#natural-language-understanding)
* [Personality Insights](#personality-insights)
* [Speech to Text](#speech-to-text)
* [Text to Speech](#text-to-speech)
* [Tone Analyzer](#tone-analyzer)
* [Visual Recognition](#visual-recognition)

## Before you begin
* You need an [IBM Cloud][ibm-cloud-onboarding] account.
 
## Requirements

- iOS 8.0+
- Xcode 9.0+
- Swift 3.2+ or Swift 4.0+

## Installation

### Dependency Management

We recommend using [Carthage](https://github.com/Carthage/Carthage) to manage dependencies and build the Swift SDK for your application.

You can install Carthage with [Homebrew](http://brew.sh/):

```bash
$ brew update
$ brew install carthage
```

Then, navigate to the root directory of your project (where your .xcodeproj file is located) and create an empty `Cartfile` there:

```bash
$ touch Cartfile
```

To use the Watson Developer Cloud Swift SDK in your application, specify it in your `Cartfile`:

```
github "watson-developer-cloud/swift-sdk"
```

In a production app, you may also want to specify a [version requirement](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#version-requirement).

Then run the following command to build the dependencies and frameworks:

```bash
$ carthage update --platform iOS
```

Finally, drag-and-drop the built frameworks into your Xcode project and import them as desired. If you are using Speech to Text, be sure to include both `SpeechToTextV1.framework` and `Starscream.framework` in your application.

### Swift Package Manager

Add the following to your `Package.swift` file to identify the Swift SDK as a dependency. The package manager will clone the Swift SDK when you build your project with `swift build`.

```swift
dependencies: [
    .package(url: "https://github.com/watson-developer-cloud/swift-sdk", from: "0.29.0")
]
```

## Service Instances

[IBM Watson](https://www.ibm.com/watson/developer/) offers a variety of services for developing cognitive applications. The complete list of Watson services is available from the [products and services](https://www.ibm.com/watson/products-services/) page. Services are instantiated using the [IBM Cloud](https://www.ibm.com/cloud/) platform.

Follow these steps to create a service instance and obtain its credentials:

1. Log in to IBM Cloud at [https://bluemix.net](https://bluemix.net).
2. Create a service instance:
    1. From the Dashboard, select "Use Services or APIs".
    2. Select the service you want to use.
    3. Click "Create".
3. Copy your service credentials:
    1. Click "Service Credentials" on the left side of the page.
    2. Copy the service's `username` and `password` (or `api_key` for Visual Recognition).

```swift
let textToSpeech = TextToSpeech(username: "your-username-here", password: "your-password-here")
```

Note that service credentials are different from your IBM Cloud username and password.

See [Getting started with Watson and IBM Cloud](https://console.bluemix.net/docs/services/watson/index.html) for details.


## Authentication

There are three ways to authenticate with IBM Cloud through the SDK: using a `username` and `password`, using an `api_key`, and with IAM.

See above for the steps to obtain the credentials for your service.

In your code, you pass these values in the service constructor when instantiating your service. Here are some examples:

### Username and Password

```swift
let discovery = Discovery(username: "your-username-here", password: "your-password-here", version: "your-version-here")
```

### API Key

_Note: This type of authentication only works with Visual Recognition, and for instances created before May 23, 2018. Newer instances of Visual Recognition use IAM._

```swift
let visualRecognition = VisualRecognition(apiKey: "your-apiKey-here", version: "your-version-here")
```

### Using IAM

When authenticating with IAM, you have the option of supplying:
- the IAM API key and, optionally, the IAM service URL. The IAM service URL defaults to 'https://iam.bluemix.net/identity/token'.
- an access token for the service.

If you supply an IAM API key, the SDK will request and refresh access tokens on your behalf.
If you supply only the IAM access token, you are responsible for refreshing the access token as needed.

#### Supplying the IAM API key
```swift
let discovery = Discovery(version: "your-version-here", apiKey: "your-apikey-here")
```

#### Supplying the accessToken
```swift
let discovery = Discovery(version: "your-version-here", accessToken: "your-accessToken-here")
```
#### Updating the accessToken
```swift
discovery.accessToken("new-accessToken-here")
```

## Custom Service URLs

You can set a custom service URL by modifying the `serviceURL` property. A custom service URL may be required when running an  instance in a particular region or connecting through a proxy.

For example, here is how to connect to a Tone Analyzer instance that is hosted in Germany:

```swift
let toneAnalyzer = ToneAnalyzer(
    username: "your-username-here",
    password: "your-password-here",
    version: "yyyy-mm-dd"
)
toneAnalyzer.serviceURL = "https://gateway-fra.watsonplatform.net/tone-analyzer/api"
```

## Custom Headers
There are different headers that can be sent to the Watson services. For example, Watson services log requests and their results for the purpose of improving the services, but you can include the `X-Watson-Learning-Opt-Out` header to opt out of this.

We have exposed a `defaultHeaders` public property in each class to allow users to easily customize their headers:

```swift
let naturalLanguageClassifier = NaturalLanguageClassifier(username: username, password: password)
naturalLanguageClassifier.defaultHeaders = ["X-Watson-Learning-Opt-Out": "true"]
```

Each service method also accepts an optional `headers` parameter which is a dictionary of request headers to be sent with the request.

## Sample Applications

* [Simple Chat (Swift)](https://github.com/watson-developer-cloud/simple-chat-swift)
* [Simple Chat (Objective-C)](https://github.com/watson-developer-cloud/simple-chat-objective-c)
* [Visual Recognition with Core ML](https://github.com/watson-developer-cloud/visual-recognition-coreml)
* [Visual Recognition and Discovery with Core ML](https://github.com/watson-developer-cloud/visual-recognition-with-discovery-coreml)
* [Speech to Text](https://github.com/watson-developer-cloud/speech-to-text-swift)
* [Text to Speech](https://github.com/watson-developer-cloud/text-to-speech-swift)
* [Cognitive Concierge](https://github.com/IBM-MIL/CognitiveConcierge)

## Synchronous Execution

By default, the SDK executes all networking operations asynchonously. If your application requires synchronous execution, you can use a `DispatchGroup`. For example:

```swift
let dispatchGroup = DispatchGroup()
dispatchGroup.enter()
assistant.message(workspaceID: workspaceID) { response in
    print(response.output.text)
    dispatchGroup.leave()
}
dispatchGroup.wait(timeout: .distantFuture)
```

## Objective-C Compatibility

Please see [this tutorial](docs/objective-c.md) for more information about consuming the Watson Developer Cloud Swift SDK in an Objective-C application.

## Linux Compatibility

To use the Watson SDK in your Linux project, please follow the [Swift Package Manager instructions.](#swift-package-manager). Note that Speech to Text and Text to Speech are not supported because they rely on frameworks that are unavailable on Linux.

## Contributing

We would love any and all help! If you would like to contribute, please read our [CONTRIBUTING](https://github.com/watson-developer-cloud/swift-sdk/blob/master/.github/CONTRIBUTING.md) documentation with information on getting started.

## License

This library is licensed under Apache 2.0. Full license text is
available in [LICENSE](https://github.com/watson-developer-cloud/swift-sdk/blob/master/LICENSE).

This SDK is intended for use with an Apple iOS product and intended to be used in conjunction with officially licensed Apple development tools.

## Assistant

With the IBM Watson Assistant service you can create cognitive agents--virtual agents that combine machine learning, natural language understanding, and integrated dialog scripting tools to provide outstanding customer engagements.

The following example shows how to start a conversation with the Assistant service:

```swift
import AssistantV1

let username = "your-username-here"
let password = "your-password-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let assistant = Assistant(username: username, password: password, version: version)

let workspaceID = "your-workspace-id-here"
let failure = { (error: Error) in print(error) }
var context: Context? // save context to continue conversation
assistant.message(workspaceID: workspaceID, failure: failure) {
    response in
    print(response.output.text)
    context = response.context
}
```

The following example shows how to continue an existing conversation with the Assistant service:

```swift
let input = InputData(text: "Turn on the radio.")
let request = MessageRequest(input: input, context: context)
let failure = { (error: Error) in print(error) }
assistant.message(workspaceID: workspaceID, request: request, failure: failure) {
    response in
    print(response.output.text)
    context = response.context
}
```

#### Context Variables

The Assistant service allows users to define custom context variables in their application's payload. For example, a workspace that guides users through a pizza order might include a context variable for pizza size: `"pizza_size": "large"`.

Context variables are get/set using the `var additionalProperties: [String: JSON]` property of a `Context` model. The following example shows how to get and set a user-defined `pizza_size` variable:

```swift
// get the `pizza_size` context variable
assistant.message(workspaceID: workspaceID, request: request, failure: failure) {
    response in
    if case let .string(size) = response.context.additionalProperties["pizza_size"]! {
        print(size)
    }
}

// set the `pizza_size` context variable
assistant.message(workspaceID: workspaceID, request: request, failure: failure) {
    response in
    var context = response.context // `var` makes the context mutable
    context?.additionalProperties["pizza_size"] = .string("large")
}
```

For reference, the `JSON` type is defined as:

```swift
/// A JSON value (one of string, number, object, array, true, false, or null).
public enum JSON: Equatable, Codable {
    case null
    case boolean(Bool)
    case string(String)
    case int(Int)
    case double(Double)
    case array([JSON])
    case object([String: JSON])
}
```

The following links provide more information about the IBM Watson Assistant service:

* [IBM Watson Assistant - Service Page](https://www.ibm.com/watson/services/conversation/)
* [IBM Watson Assistant - Documentation](https://console.bluemix.net/docs/services/conversation/index.html)

## Discovery

IBM Watson Discovery makes it possible to rapidly build cognitive, cloud-based exploration applications that unlock actionable insights hidden in unstructured data — including your own proprietary data, as well as public and third-party data. With Discovery, it only takes a few steps to prepare your unstructured data, create a query that will pinpoint the information you need, and then integrate those insights into your new application or existing solution.

### Discovery News

IBM Watson Discovery News is included with Discovery. Watson Discovery News is an indexed dataset with news articles from the past 60 days — approximately 300,000 English articles daily. The dataset is pre-enriched with the following cognitive insights: Keyword Extraction, Entity Extraction, Semantic Role Extraction, Sentiment Analysis, Relation Extraction, and Category Classification.

The following example shows how to query the Watson Discovery News dataset:

```swift
import DiscoveryV1

let username = "your-username-here"
let password = "your-password-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let discovery = Discovery(username: username, password: password, version: version)

let failure = { (error: Error) in print(failure) }
discovery.query(
    environmentID: "system",
    collectionID: "news-en",
    query: "enriched_text.concepts.text:\"Cloud computing\"",
    failure: failure)
{
    queryResponse in
    print(queryResponse)
}
```

### Private Data Collections

The Swift SDK supports environment management, collection management, and document uploading. But you may find it easier to create private data collections using the [Discovery Tooling](https://console.bluemix.net/docs/services/discovery/getting-started-tool.html#getting-started-with-the-tooling) instead.

Once your content has been uploaded and enriched by the Discovery service, you can search the collection with queries. The following example demonstrates a complex query with a filter, query, and aggregation:

```swift
import DiscoveryV1

let username = "your-username-here"
let password = "your-password-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let discovery = Discovery(username: username, password: password, version: version)

let failure = { (error: Error) in print(failure) }
discovery.query(
    environmentID: "your-environment-id",
    collectionID: "your-collection-id",
    filter: "enriched_text.concepts.text:\"Technology\"",
    query: "enriched_text.concepts.text:\"Cloud computing\"",
    aggregation: "term(enriched_text.concepts.text,count:10)",
    failure: failure)
{
    queryResponse in
    print(queryResponse)
}
```

You can also upload new documents into your private collection:

```swift
import DiscoveryV1

let username = "your-username-here"
let password = "your-password-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let discovery = Discovery(username: username, password: password, version: version)

let failure = { (error: Error) in print(failure) }
let file = Bundle.main.url(forResource: "KennedySpeech", withExtension: "html")!
discovery.addDocument(
    environmentID: "your-environment-id",
    collectionID: "your-collection-id",
    file: file,
    fileContentType: "text/html",
    failure: failWithError)
{
    response in
    print(response)
}
```

The following links provide more information about the IBM Discovery service:

* [IBM Discovery - Service Page](https://www.ibm.com/watson/services/discovery/)
* [IBM Discovery - Documentation](https://console.bluemix.net/docs/services/discovery/index.html)
* [IBM Discovery - Demo](https://discovery-news-demo.ng.bluemix.net/)

## Language Translator V2

### Deprecation notice
Language Translator v3 is now available. The v2 Language Translator API will no longer be available after July 31, 2018.
To take advantage of the latest service enhancements, migrate to the v3 API.
View the [Migrating to Language Translator v3](https://console.bluemix.net/docs/services/language-translator/migrating.html) page for more information.


## Language Translator V3

The IBM Watson Language Translator service lets you select a domain, customize it, then identify or select the language of text, and then translate the text from one supported language to another.

The following example demonstrates how to use the Language Translator service:

```swift
import LanguageTranslatorV3

let username = "your-username-here"
let password = "your-password-here"
let version = "yyyy-mm-dd" // use today's date for the most recent version
let languageTranslator = LanguageTranslator(username: username, password: password, version: version)

let failure = { (error: Error) in print(error) }
let request = TranslateRequest(text: ["Hello"], source: "en", target: "es")
languageTranslator.translate(request: request, failure: failure) {
    translation in
    print(translation)
}
```

The following links provide more information about the IBM Watson Language Translator service:

* [IBM Watson Language Translator - Service Page](https://www.ibm.com/watson/services/language-translator/)
* [IBM Watson Language Translator - Documentation](https://console.bluemix.net/docs/services/language-translator/index.html)
* [IBM Watson Language Translator - Demo](https://language-translator-demo.ng.bluemix.net/)

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
let failure = { (error: Error) in print(error) }
naturalLanguageClassifier.classify(classifierID: classifierID, text: text, failure: failure) {
    classification in
    print(classification)
}
```

The following links provide more information about the Natural Language Classifier service:

* [IBM Watson Natural Language Classifier - Service Page](https://www.ibm.com/watson/services/natural-language-classifier/)
* [IBM Watson Natural Language Classifier - Documentation](https://console.bluemix.net/docs/services/natural-language-classifier/natural-language-classifier-overview.html)
* [IBM Watson Natural Language Classifier - Demo](https://natural-language-classifier-demo.ng.bluemix.net/)

## Natural Language Understanding

The IBM Natural Language Understanding service explores various features of text content. Provide text, raw HTML, or a public URL, and IBM Watson Natural Language Understanding will give you results for the features you request. The service cleans HTML content before analysis by default, so the results can ignore most advertisements and other unwanted content.

Natural Language Understanding has the following features:

- Concepts
- Entities
- Keywords
- Categories
- Sentiment
- Emotion
- Relations
- Semantic Roles

The following example demonstrates how to use the service:

```swift
import NaturalLanguageUnderstandingV1

let username = "your-username-here"
let password = "your-password-here"
let version = "yyyy-mm-dd" // use today's date for the most recent version
let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: username, password: password, version: version)

let features = Features(concepts: ConceptsOptions(limit: 5))
let parameters = Parameters(features: features, text: "your-text-here")
let failure = { (error: Error) in print(error) }
naturalLanguageUnderstanding.analyze(parameters: parameters, failure: failure) {
    results in
    print(results)
}
```

#### 500 errors
Note that **you are required to include at least one feature in your request.** You will receive a 500 error if you do not include any features in your request.

The following links provide more information about the Natural Language Understanding service:

* [IBM Watson Natural Language Understanding - Service Page](https://www.ibm.com/watson/services/natural-language-understanding/)
* [IBM Watson Natural Language Understanding - Documentation](https://console.bluemix.net/docs/services/natural-language-understanding/index.html)
* [IBM Watson Natural Language Understanding - Demo](https://natural-language-understanding-demo.ng.bluemix.net/)

## Personality Insights

The IBM Watson Personality Insights service enables applications to derive insights from social media, enterprise data, or other digital communications. The service uses linguistic analytics to infer personality and social characteristics, including Big Five, Needs, and Values, from text.

The following example demonstrates how to use the Personality Insights service:

```swift
import PersonalityInsightsV3

let username = "your-username-here"
let password = "your-password-here"
let version = "yyyy-mm-dd" // use today's date for the most recent version
let personalityInsights = PersonalityInsights(username: username, password: password, version: version)

let failure = { (error: Error) in print(error) }
personalityInsights.profile(text: "your-input-text", failure: failure) { profile in
    print(profile)
}
```

The following links provide more information about the Personality Insights service:

* [IBM Watson Personality Insights - Service Page](https://www.ibm.com/watson/services/personality-insights/)
* [IBM Watson Personality Insights - Documentation](https://console.bluemix.net/docs/services/personality-insights/index.html)
* [IBM Watson Personality Insights - Demo](https://personality-insights-demo.ng.bluemix.net/)

## Speech to Text

The IBM Watson Speech to Text service enables you to add speech transcription capabilities to your application. It uses machine intelligence to combine information about grammar and language structure to generate an accurate transcription. Transcriptions are supported for various audio formats and languages.

The `SpeechToText` class is the SDK's primary interface for performing speech recognition requests. It supports the transcription of audio files, audio data, and streaming microphone data. Advanced users, however, may instead wish to use the `SpeechToTextSession` class that exposes more control over the WebSockets session.

Please be sure to include both `SpeechToTextV1.framework` and `Starscream.framework` in your application. Starscream is a recursive dependency that adds support for WebSockets sessions.

Beginning with iOS 10+, any application that accesses the microphone must include the `NSMicrophoneUsageDescription` key in the app's `Info.plist` file. Otherwise, the app will crash. Find more information about this [here](https://forums.developer.apple.com/thread/61521).

#### Recognition Request Settings

The `RecognitionSettings` class is used to define the audio format and behavior of a recognition request. These settings are transmitted to the service when [initating a request](https://console.bluemix.net/docs/services/speech-to-text/websockets.html#WSstart).

The following example demonstrates how to define a recognition request that transcribes WAV audio data with interim results:

```swift
var settings = RecognitionSettings(contentType: "audio/wav")
settings.interimResults = true
```

See the [class documentation](http://watson-developer-cloud.github.io/swift-sdk/services/SpeechToTextV1/Structs/RecognitionSettings.html) or [service documentation](https://console.bluemix.net/docs/services/speech-to-text/index.html) for more information about the available settings.

#### Microphone Audio and Compression

The Speech to Text framework makes it easy to perform speech recognition with microphone audio. The framework internally manages the microphone, starting and stopping it with various function calls (such as `recognizeMicrophone(settings:model:customizationID:learningOptOut:compress:failure:success)` and `stopRecognizeMicrophone()` or `startMicrophone(compress:)` and `stopMicrophone()`).

There are two different ways that your app can determine when to stop the microphone:

- User Interaction: Your app could rely on user input to stop the microphone. For example, you could use a button to start/stop transcribing, or you could require users to press-and-hold a button to start/stop transcribing.

- Final Result: Each transcription result has a `final` property that is `true` when the audio stream is complete or a timeout has occurred. By watching for the `final` property, your app can stop the microphone after determining when the user has finished speaking.

To reduce latency and bandwidth, the microphone audio is compressed to OggOpus format by default. To disable compression, set the `compress` parameter to `false`.

It's important to specify the correct audio format for recognition requests that use the microphone:

```swift
// compressed microphone audio uses the opus format
let settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")

// uncompressed microphone audio uses a 16-bit mono PCM format at 16 kHz
let settings = RecognitionSettings(contentType: "audio/l16;rate=16000;channels=1")
```

#### Recognition Results Accumulator

The Speech to Text service may not always return the entire transcription in a single response. Instead, the transcription may be streamed over multiple responses, each with a chunk of the overall results. This is especially common for long audio files, since the entire transcription may contain a significant amount of text.

To help combine multiple responses, the Swift SDK provides a `SpeechRecognitionResultsAccumulator` object. The accumulator tracks results as they are added and maintains several useful instance variables:
    - `results`: A list of all accumulated recognition results.
    - `speakerLabels`: A list of all accumulated speaker labels.
    - `bestTranscript`: A concatenation of transcripts with the greatest confidence.

To use the accumulator, initialize an instance of the object then add results as you receive them:

```swift
var accumulator = SpeechRecognitionResultsAccumulator()
accumulator.add(results: results)
print(accumulator.bestTranscript)
```

#### Transcribe Recorded Audio

The following example demonstrates how to use the Speech to Text service to transcribe a WAV audio file.

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToText = SpeechToText(username: username, password: password)

var accumulator = SpeechRecognitionResultsAccumulator()

let audio = Bundle.main.url(forResource: "filename", withExtension: "wav")!
var settings = RecognitionSettings(contentType: "audio/wav")
settings.interimResults = true
let failure = { (error: Error) in print(error) }
speechToText.recognize(audio, settings: settings, failure: failure) {
    results in
    accumulator.add(results: results)
    print(accumulator.bestTranscript)
}
```

#### Transcribe Microphone Audio

Audio can be streamed from the microphone to the Speech to Text service for real-time transcriptions. The following example demonstrates how to use the Speech to Text service to transcribe microphone audio:

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToText = SpeechToText(username: username, password: password)

var accumulator = SpeechRecognitionResultsAccumulator()

func startStreaming() {
    var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
    settings.interimResults = true
    let failure = { (error: Error) in print(error) }
    speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
        accumulator.add(results: results)
        print(accumulator.bestTranscript)
    }
}

func stopStreaming() {
    speechToText.stopRecognizeMicrophone()
}
```

#### Session Management and Advanced Features

Advanced users may want more customizability than provided by the `SpeechToText` class. The `SpeechToTextSession` class exposes more control over the WebSockets connection and also includes several advanced features for accessing the microphone. The `SpeechToTextSession` class also allows users more control over the AVAudioSession shared instance. Before using `SpeechToTextSession`, it's helpful to be familiar with the [Speech to Text WebSocket interface](https://console.bluemix.net/docs/services/speech-to-text/websockets.html).

The following steps describe how to execute a recognition request with `SpeechToTextSession`:

1. Connect: Invoke `connect()` to connect to the service.
2. Start Recognition Request: Invoke `startRequest(settings:)` to start a recognition request.
3. Send Audio: Invoke `recognize(audio:)` or `startMicrophone(compress:)`/`stopMicrophone()` to send audio to the service.
4. Stop Recognition Request: Invoke `stopRequest()` to end the recognition request. If the recognition request is already stopped, then sending a stop message will have no effect.
5. Disconnect: Invoke `disconnect()` to wait for any remaining results to be received and then disconnect from the service.

All text and data messages sent by `SpeechToTextSession` are queued, with the exception of `connect()` which immediately connects to the server. The queue ensures that the messages are sent in-order and also buffers messages while waiting for a connection to be established. This behavior is generally transparent.

A `SpeechToTextSession` also provides several (optional) callbacks. The callbacks can be used to learn about the state of the session or access microphone data.

- `onConnect`: Invoked when the session connects to the Speech to Text service.
- `onMicrophoneData`: Invoked with microphone audio when a recording audio queue buffer has been filled. If microphone audio is being compressed, then the audio data is in OggOpus format. If uncompressed, then the audio data is in 16-bit PCM format at 16 kHz.
- `onPowerData`: Invoked every 0.025s when recording with the average dB power of the microphone.
- `onResults`: Invoked when transcription results are received for a recognition request.
- `onError`: Invoked when an error or warning occurs.
- `onDisconnect`: Invoked when the session disconnects from the Speech to Text service.

Note that the `AVAudioSession.sharedInstance()` must be configured to allow microphone access when using `SpeechToTextSession`. This allows users to set a particular configuration for the `AVAudioSession`. An example configuration is shown in the code below.

The following example demonstrates how to use `SpeechToTextSession` to transcribe microphone audio:

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToTextSession = SpeechToTextSession(username: username, password: password)

var accumulator = SpeechRecognitionResultsAccumulator()

do {
    let session = AVAudioSession.sharedInstance()
    try session.setActive(true)
    try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.mixWithOthers, .defaultToSpeaker])
} catch {
    print(error.localizedDescription)
}

func startStreaming() {
    // define callbacks
    speechToTextSession.onConnect = { print("connected") }
    speechToTextSession.onDisconnect = { print("disconnected") }
    speechToTextSession.onError = { error in print(error) }
    speechToTextSession.onPowerData = { decibels in print(decibels) }
    speechToTextSession.onMicrophoneData = { data in print("received data") }
    speechToTextSession.onResults = { results in
        accumulator.add(results: results)
        print(accumulator.bestTranscript)
    }

    // define recognition request settings
    var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
    settings.interimResults = true

    // start streaming microphone audio for transcription
    speechToTextSession.connect()
    speechToTextSession.startRequest(settings: settings)
    speechToTextSession.startMicrophone()
}

func stopStreaming() {
    speechToTextSession.stopMicrophone()
    speechToTextSession.stopRequest()
    speechToTextSession.disconnect()
}
```

#### Customization

There are a number of ways that Speech to Text can be customized to suit your particular application. For example, you can define custom words or upload audio to train an acoustic model. For more information, refer to the [service documentation](https://console.bluemix.net/docs/services/speech-to-text/index.html) or [API documentation](http://watson-developer-cloud.github.io/swift-sdk/swift-api/services/SpeechToTextV1/Classes/SpeechToText.html).

#### Additional Information

The following links provide more information about the IBM Speech to Text service:

* [IBM Watson Speech to Text - Service Page](https://www.ibm.com/watson/services/speech-to-text/)
* [IBM Watson Speech to Text - Documentation](https://console.bluemix.net/docs/services/speech-to-text/index.html)
* [IBM Watson Speech to Text - Demo](https://speech-to-text-demo.ng.bluemix.net/)

## Text to Speech

The IBM Watson Text to Speech service synthesizes natural-sounding speech from input text in a variety of languages and voices that speak with appropriate cadence and intonation.

The following example demonstrates how to use the Text to Speech service:

```swift
import TextToSpeechV1
import AVFoundation

let username = "your-username-here"
let password = "your-password-here"
let textToSpeech = TextToSpeech(username: username, password: password)

// The AVAudioPlayer object will stop playing if it falls out-of-scope.
// Therefore, to prevent it from falling out-of-scope we declare it as
// a property outside the completion handler where it will be played.
var audioPlayer = AVAudioPlayer()

let text = "your-text-here"
let accept = "audio/wav"
let failure = { (error: Error) in print(error) }
textToSpeech.synthesize(text: text, accept: accept, failure: failure) { data in
    audioPlayer = try! AVAudioPlayer(data: data)
    audioPlayer.prepareToPlay()
    audioPlayer.play()
}
```

The Text to Speech service supports a number of [voices](https://console.bluemix.net/docs/services/text-to-speech/http.html#voices) for different genders, languages, and dialects. The following example demonstrates how to use the Text to Speech service with a particular voice:

```swift
import TextToSpeechV1

let username = "your-username-here"
let password = "your-password-here"
let textToSpeech = TextToSpeech(username: username, password: password)

// The AVAudioPlayer object will stop playing if it falls out-of-scope.
// Therefore, to prevent it from falling out-of-scope we declare it as
// a property outside the completion handler where it will be played.
var audioPlayer = AVAudioPlayer()

let text = "your-text-here"
let accept = "audio/wav"
let voice = "en-US_LisaVoice"
let failure = { (error: Error) in print(error) }
textToSpeech.synthesize(text: text, accept: accept, voice: voice, failure: failure) { data in
    audioPlayer = try! AVAudioPlayer(data: data)
    audioPlayer.prepareToPlay()
    audioPlayer.play()
}
```

The following links provide more information about the IBM Text To Speech service:

* [IBM Watson Text To Speech - Service Page](https://www.ibm.com/watson/services/text-to-speech/)
* [IBM Watson Text To Speech - Documentation](https://console.bluemix.net/docs/services/text-to-speech/index.html)
* [IBM Watson Text To Speech - Demo](https://text-to-speech-demo.ng.bluemix.net/)

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

let toneInput = ToneInput(text: "your-input-text")
let failure = { (error: Error) in print(error) }
toneAnalyzer.tone(toneInput: toneInput, contentType: "plain/text", failure: failure) { tones in
    print(tones)
}
```

The following links provide more information about the IBM Watson Tone Analyzer service:

* [IBM Watson Tone Analyzer - Service Page](https://www.ibm.com/watson/services/tone-analyzer/)
* [IBM Watson Tone Analyzer - Documentation](https://console.bluemix.net/docs/services/tone-analyzer/index.html)
* [IBM Watson Tone Analyzer - Demo](https://tone-analyzer-demo.ng.bluemix.net/)

## Visual Recognition

The IBM Watson Visual Recognition service uses deep learning algorithms to analyze images (.jpg or .png) for scenes, objects, faces, text, and other content, and return keywords that provide information about that content. The service comes with a set of built-in classes so that you can analyze images with high accuracy right out of the box. You can also train custom classifiers to create specialized classes.

The following example demonstrates how to use the Visual Recognition service:

```swift
import VisualRecognitionV3

let apiKey = "your-apikey-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)

let url = "your-image-url"
let failure = { (error: Error) in print(error) }
visualRecognition.classify(image: url, failure: failure) { classifiedImages in
    print(classifiedImages)
}
```

Note: a different initializer is used for authentication with instances created before May 23, 2018:
```swift
let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
```

### Using Core ML

The Watson Swift SDK supports offline image classification using Apple Core ML. Classifiers must be trained or updated with the `coreMLEnabled` flag set to true. Once the classifier's `coreMLStatus` is `ready` then a Core ML model is available to download and use for offline classification. 

Once the Core ML model is in the device's file system, images can be classified offline, directly on the device.

```swift
let classifierID = "your-classifier-id"
let failure = { (error: Error) in print(error) }
let image = UIImage(named: "your-image-filename")
visualRecognition.classifyWithLocalModel(image: image, classifierIDs: [classifierID], failure: failure) {
    classifiedImages in print(classifiedImages)
}
```

The local Core ML model can be updated as needed.

```swift
let classifierID = "your-classifier-id"
let failure = { (error: Error) in print(error) }
visualRecognition.updateLocalModel(classifierID: classifierID, failure: failure) {
    print("model updated")
}
```

The following example demonstrates how to list the Core ML models that are stored in the filesystem and available for offline use:

```swift
let localModels = try! visualRecognition.listLocalModels()
print(localModels)
```

If you would prefer to bypass `classifyWithLocalModel` and construct your own Core ML classification request, then you can retrieve a Core ML model from the local filesystem with the following example.
```swift
let classifierID = "your-classifier-id"
let localModel = try! visualRecognition.getLocalModel(classifierID: classifierID)
print(localModel)
```

The following example demonstrates how to delete a local Core ML model from the filesystem. This saves space when the model is no longer needed.
```swift
let classifierID = "your-classifier-id"
visualRecognition.deleteLocalModel(classifierID: classifierID)
```

#### Bundling a model directly with your application
You may also choose to include a Core ML model with your application, enabling images to be classified offline without having to download a model first. To include a model, add it to your application bundle following the naming convention [classifier_id].mlmodel. This will enable the SDK to locate the model when using any function that accepts a classifierID argument.

The following links provide more information about the IBM Watson Visual Recognition service:

* [IBM Watson Visual Recognition - Service Page](https://www.ibm.com/watson/services/visual-recognition/)
* [IBM Watson Visual Recognition - Documentation](https://console.bluemix.net/docs/services/visual-recognition/index.html)
* [IBM Watson Visual Recognition - Demo](https://visual-recognition-demo.ng.bluemix.net/)

[ibm-cloud-onboarding]: http://console.bluemix.net/registration?target=/developer/watson&cm_sp=WatsonPlatform-WatsonServices-_-OnPageNavLink-IBMWatson_SDKs-_-Swift
