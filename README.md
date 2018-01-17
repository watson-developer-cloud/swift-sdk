# Watson Developer Cloud Swift SDK

[![Build Status](https://travis-ci.org/watson-developer-cloud/swift-sdk.svg?branch=master)](https://travis-ci.org/watson-developer-cloud/swift-sdk)
![](https://img.shields.io/badge/platform-iOS,%20Linux-blue.svg?style=flat)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Documentation](https://img.shields.io/badge/Documentation-API-blue.svg)](http://watson-developer-cloud.github.io/swift-sdk)
[![CLA assistant](https://cla-assistant.io/readme/badge/watson-developer-cloud/ios-sdk)](https://cla-assistant.io/watson-developer-cloud/swift-sdk)

## Overview

The Watson Developer Cloud Swift SDK makes it easy for mobile developers to build Watson-powered applications. With the Swift SDK you can leverage the power of Watson's advanced artificial intelligence, machine learning, and deep learning techniques to understand unstructured data and engage with mobile users in new ways.

There are many resources to help you build your first cognitive application with the Swift SDK:

- Read the [Readme](README.md)
- Follow the [QuickStart Guide](docs/quickstart.md)
- Review a [Sample Application](#sample-applications)
- Browse the [Documentation](http://watson-developer-cloud.github.io/swift-sdk/)

## Contents

### General

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

* [AlchemyData News](#alchemydata-news)
* [AlchemyLanguage](#alchemylanguage)
* [Conversation](#conversation)
* [Discovery](#discovery)
* [Language Translator](#language-translator)
* [Natural Language Classifier](#natural-language-classifier)
* [Natural Language Understanding](#natural-language-understanding)
* [Personality Insights](#personality-insights)
* [Retrieve and Rank](#retrieve-and-rank)
* [Speech to Text](#speech-to-text)
* [Text to Speech](#text-to-speech)
* [Tone Analyzer](#tone-analyzer)
* [Tradeoff Analytics](#tradeoff-analytics)
* [Visual Recognition](#visual-recognition)

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

To include the Watson SDK to your projects, add the following to your `Package.swift` file:

```swift
dependencies: [
    .Package(url: "https://github.com/watson-developer-cloud/swift-sdk",
             majorVersion: 0)
]
```
To build the project, run `swift build` from the command line.

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

You will need to provide these service credentials in your mobile application. For example:

```swift
let textToSpeech = TextToSpeech(username: "your-username-here", password: "your-password-here")
```

Note that service credentials are different from your IBM Cloud username and password.

See [Getting started with Watson and IBM Cloud](https://console.bluemix.net/docs/services/watson/index.html) for details.

## Custom Service URLs

In some instances, users will need to use their own custom URL to access the Watson services. Thus, to make it easier to update, we have exposed the service URL as a public property of each class.

You can set a custom service URL like so:

```swift
let dialog = Dialog(username: "your-username-here", password: "your-password-here")
dialog.serviceURL = "your-custom-service-url"
```

## Custom Headers
There are different headers that can be sent to the Watson services. For example, Watson services log requests and their results for the purpose of improving the services, but you can include the `X-Watson-Learning-Opt-Out` header to opt out of this.

We have exposed a `defaultHeaders` public property in each class to allow users to easily customize their headers:

```swift
let naturalLanguageClassifier = NaturalLanguageClassifier(username: username, password: password)
naturalLanguageClassifier.defaultHeaders = ["X-Watson-Learning-Opt-Out": "true"]
```

## Sample Applications

* [Simple Chat (Swift)](https://github.com/watson-developer-cloud/simple-chat-swift)
* [Simple Chat (Objective-C)](https://github.com/watson-developer-cloud/simple-chat-objective-c)
* [Speech to Text](https://github.com/watson-developer-cloud/speech-to-text-swift)
* [Text to Speech](https://github.com/watson-developer-cloud/text-to-speech-swift)
* [Cognitive Concierge](https://github.com/IBM-MIL/CognitiveConcierge)

## Synchronous Execution

By default, the SDK executes all networking operations asynchonously. If your application requires synchronous execution, you can use a `DispatchGroup`. For example:

```swift
let dispatchGroup = DispatchGroup()
dispatchGroup.enter()
conversation.message(workspaceID: workspaceID) { response in
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

We would love any and all help! If you would like to contribute, please read our [CONTRIBUTING](https://github.com/watson-developer-cloud/ios-sdk/blob/master/.github/CONTRIBUTING.md) documentation with information on getting started.

## License

This library is licensed under Apache 2.0. Full license text is
available in [LICENSE](https://github.com/watson-developer-cloud/ios-sdk/blob/master/LICENSE).

This SDK is intended for use with an Apple iOS product and intended to be used in conjunction with officially licensed Apple development tools.

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
let failure = { (error: Error) in print(error) }

alchemyDataNews.getNews(from: start, to: end, query: query, failure: failure) { news in
    print(news)
}
```

Refine your query by referring to the [Count and TimeSlice Queries](http://docs.alchemyapi.com/docs/counts) and [API Fields](http://docs.alchemyapi.com/docs/full-list-of-supported-news-api-fields) documentation.

The following links provide more information about the IBM AlchemyData News service:

* [IBM AlchemyData News - Service Page](https://www.ibm.com/watson/developercloud/alchemy-data-news.html)
* [IBM AlchemyData News - Documentation](https://console.bluemix.net/docs/services/alchemydata-news/index.html)

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

let url = "https://github.com/watson-developer-cloud/swift-sdk"
let failure = { (error: Error) in print(error) }
alchemyLanguage.getTextSentiment(fromContentAtURL: url, failure: failure) { sentiment in
    print(sentiment)
}
```

The following links provide more information about the IBM AlchemyLanguage service:

* [IBM AlchemyLanguage - Service Page](http://www.ibm.com/watson/developercloud/alchemy-language.html)
* [IBM AlchemyLanguage - Documentation](https://console.bluemix.net/docs/services/alchemy-language/index.html)

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
let failure = { (error: Error) in print(error) }
var context: Context? // save context to continue conversation
conversation.message(workspaceID: workspaceID, failure: failure) {
    response in
    print(response.output.text)
    context = response.context
}
```

The following example shows how to continue an existing conversation with the Conversation service:

```swift
let input = InputData(text: "Turn on the radio.")
let request = MessageRequest(input: input, context: context)
let failure = { (error: Error) in print(error) }
conversation.message(workspaceID: workspaceID, request: request, failure: failure) {
    response in
    print(response.output.text)
    context = response.context
}
```

#### Context Variables

The Conversation service allows users to define custom context variables in their application's payload. For example, a Conversation workspace that guides users through a pizza order might include a context variable for pizza size: `"pizza_size": "large"`.

Context variables are get/set using the `var additionalProperties: [String: JSON]` property of a `Context` model. The following example shows how to get and set a user-defined `pizza_size` variable:

```swift
// get the `pizza_size` context variable
conversation.message(workspaceID: workspaceID, request: request, failure: failure) {
    response in
    if case let .string(size) = response.context.additionalProperties["pizza_size"]! {
        print(size)
    }
}

// set the `pizza_size` context variable
conversation.message(workspaceID: workspaceID, request: request, failure: failure) {
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

The following links provide more information about the IBM Conversation service:

* [IBM Watson Conversation - Service Page](https://www.ibm.com/watson/services/conversation/)
* [IBM Watson Conversation - Documentation](https://console.bluemix.net/docs/services/conversation/index.html)

## Discovery

The IBM Discovery Service allows for rapid automated ingestion and feature enrichment of unstructured data. Enrichments of documents ingested include concepts, relationship extraction and sentiment analysis through Natural Language Processing. With the IBM Discovery service you can take advantage of IBM Watson algorithms to take your unstructured data, enrich it, and query it to return the information you need from it.

The following example shows how to instantiate a Discovery object:

```swift
import DiscoveryV1

let username = "your-username-here"
let password = "your-password-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let discovery = Discovery(username: username, password: password, version: version)
}
```
The following example demonstrates how to create a Discovery environment and collection with the default configuration, and add documents to the collection.

```swift
let failure = { (error: Error) in print(error) }

// Create and store the environment ID for you to access later:
var environmentID: String?
let environmentName = "your-environment-name-here"

discovery.createEnvironment(
    withName: environmentName,
    withSize: .zero,
    withDescription: testDescription,
    failure: failure)
{
	environment in
    self.environmentID = environment.environmentID
}

// Wait for the environment to be ready before creating a collection:
bool environmentReady = false
while (!environmentReady) {
	discovery.getEnvironment(withName: environmentName, failure: failure)
	{
		environment in
		if environment.status == "active" {
		 self.environmentReady = true
		}
	}
}

// Create a collection and store the collection ID for you to access later:
var collectionID: String?

let collectionName = "your-collection-name-here"
discovery.createCollection(
    withEnvironmentID: environmentID!,
    withName: collectionName,
    withDescription: collectionDescription,
    withConfigurationID: configurationID,
    failure: failure)
{
	collection in
    self.collectionID = collection.collectionID
}

// Wait for the collection to be "available" before adding a document:
bool collectionReady = false
while (!collectionReady) {
	discovery.listCollectionDetails(
	withEnvironmentID: environmentID!,
	withCollectionID: collectionID!,
	failure: failWithError)
{
    collection in
    if collection.status == CollectionStatus.active {
        self.collectionReady = true
    }
}

// Add a document to the collection with the saved environment and collection ID:
guard let file = Bundle(for: type(of: self)).url(forResource: "your-Document-Name", withExtension: "document-type") else {
    XCTFail("Unable to locate your-Document-Name.document-type")
    return
}
discovery.addDocumentToCollection(
    withEnvironmentID: environmentID!,
    withCollectionID: collectionID!,
    file: file,
    failure: failWithError)
{
    document in
    NSLog(document)
}

```
The following example demonstrates how to perform a query on the Discovery instance using the `KennedySpeech.html` we have within our `DiscoveryV1Tests` folder:

```swift
/// String to search for within the documents.
let query = "United Nations"

/// Find the max sentiment score for entities within the enriched text.
let aggregation = "max(enriched_text.entities.sentiment.score)"

/// Specify which portion of the document hierarchy to return.
let returnHierarchies = "enriched_text.entities.sentiment,enriched_text.entities.text"

discovery.queryDocumentsInCollection(
    withEnvironmentID: environmentID!,
    withCollectionID: collectionID!,
    withQuery: query,
    withAggregation: aggregation,
    return: returnHierarchies,
    failure: failWithError)
{
    queryResponse in
    if let results = queryResponse.results {
        for result in results {
            if let entities = result.entities {
                for entity in entities {
						NSLog(entity)
                }
            }
        }
    }
}
```

The following links provide more information about the IBM Discovery service:

* [IBM Discovery - Service Page](https://www.ibm.com/watson/services/discovery/)
* [IBM Discovery - Documentation](https://console.bluemix.net/docs/services/discovery/index.html)
* [IBM Discovery - API Reference](https://www.ibm.com/watson/developercloud/discovery/api/v1/)
* [IBM Discovery - API Explorer](https://watson-api-explorer.mybluemix.net/apis/discovery-v1)
* [IBM Discovery - Query Building](https://console.bluemix.net/docs/services/discovery/query-reference.html#query-building)

## Language Translator

The IBM Watson Language Translator service lets you select a domain, customize it, then identify or select the language of text, and then translate the text from one supported language to another.

Note that the Language Translator service was formerly known as Language Translation. It is recommended to [migrate](https://console.bluemix.net/docs/services/language-translator/migrating.html) to Language Translator, however, existing Language Translation service instances are currently supported by the `LanguageTranslatorV2` framework. To use a legacy Language Translation service, set the `serviceURL` property before executing the first API call to the service.

The following example demonstrates how to use the Language Translator service:

```swift
import LanguageTranslatorV2

let username = "your-username-here"
let password = "your-password-here"
let languageTranslator = LanguageTranslator(username: username, password: password)

// set the serviceURL property to use the legacy Language Translation service
// languageTranslator.serviceURL = "https://gateway.watsonplatform.net/language-translation/api"

let failure = { (error: Error) in print(error) }
languageTranslator.translate("Hello", from: "en", to: "es", failure: failure) {
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
naturalLanguageClassifier.classify(text, withClassifierID: classifierID, failure: failure) {
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

let textToAnalyze = "In 2009, Elliot Turner launched AlchemyAPI to process the written word, with all of its quirks and nuances, and got immediate traction."

let features = Features(concepts: ConceptsOptions(limit: 5))
let parameters = Parameters(features: features, text: textToAnalyze)

let failure = { (error: Error) in print(error) }
naturalLanguageUnderstanding.analyzeContent(withParameters: parameters, failure: failure) {
    results in
    print (results)
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

let text = "your-input-text"
let failure = { (error: Error) in print(error) }
personalityInsights.getProfile(fromText: text, failure: failure) { profile in
    print(profile)
}
```

The following links provide more information about the Personality Insights service:

* [IBM Watson Personality Insights - Service Page](https://www.ibm.com/watson/services/personality-insights/)
* [IBM Watson Personality Insights - Documentation](https://console.bluemix.net/docs/services/personality-insights/index.html)
* [IBM Watson Personality Insights - Demo](https://personality-insights-demo.ng.bluemix.net/)

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
let failure = { (error: Error) in print(error) }

// Create and store the Solr Cluster so you can access it later.
var cluster: SolrCluster!
let clusterName = "your-cluster-name-here"
retrieveAndRank.createSolrCluster(withName: clusterName, failure: failure) {
    solrCluster in
    cluster = solrCluster
}

// Load the configuration file.
guard let configFile = Bundle.main.url(forResource: "your-config-filename", withExtension: "zip") else {
    print("Failed to locate configuration file.")
    return
}

// Create the configuration. Make sure the Solr Cluster status is READY first.
let configurationName = "your-config-name-here"
retrieveAndRank.uploadSolrConfiguration(
    withName: configurationName,
    toSolrClusterID: cluster.solrClusterID,
    zipFile: configFile,
    failure: failure
)

// Create and store your Solr collection name.
let collectionName = "your-collection-name-here"
retrieveAndRank.createSolrCollection(
    withName: collectionName,
    forSolrClusterID: cluster.solrClusterID,
    withConfigurationName: configurationName,
    failure: failure
)

// Load the documents you want to add to your collection.
guard let collectionFile = Bundle.main.url(forResource: "your-collection-filename", withExtension: "json") else {
    print("Failed to locate collection file.")
    return
}

// Upload the documents to your collection.
retrieveAndRank.updateSolrCollection(
    withName: collectionName,
    inSolrClusterID: cluster.solrClusterID,
    contentFile: collectionFile,
    contentType: "application/json",
    failure: failure
)
```

The following example demonstrates how to use the Retrieve and Rank service to retrieve answers without ranking them.

```swift
retrieveAndRank.search(
    withCollectionName: collectionName,
    fromSolrClusterID: cluster.solrClusterID,
    query: "your-query-here",
    returnFields: "your-return-fields-here",
    failure: failure)
{
    response in
    print(response)
}
```

The following example demonstrates how to create and train a Ranker.

``` swift
// Load the ranker training data file.
guard let rankerTrainingFile = Bundle.main.url(forResource: "your-ranker-training-data-filename", withExtension: "json") else {
    print("Failed to locate collection file.")
    return
}

// Create and store the ranker.
var ranker: RankerDetails!
retrieveAndRank.createRanker(
    withName: "your-ranker-name-here",
    fromFile: rankerTrainingFile,
    failure: failure)
{
    rankerDetails in
    ranker = rankerDetails
}
```

The following example demonstrates how to use the service to retrieve and rank the results.

```swift
retrieveAndRank.searchAndRank(
    withCollectionName: collectionName,
    fromSolrClusterID: cluster.solrClusterID,
    rankerID: ranker.rankerID,
    query: "your-query-here",
    returnFields: "your-return-fields-here",
    failure: failure)
{
    response in
    print(response)
}
```

The following links provide more information about the Retrieve and Rank service:

* [IBM Watson Retrieve and Rank - Service Page](https://www.ibm.com/watson/services/retrieve-and-rank/)
* [IBM Watson Retrieve and Rank - Documentation](https://console.bluemix.net/docs/services/retrieve-and-rank/index.html)
* [IBM Watson Retrieve and Rank - Demo](http://retrieve-and-rank-demo.ng.bluemix.net/)

## Speech to Text

The IBM Watson Speech to Text service enables you to add speech transcription capabilities to your application. It uses machine intelligence to combine information about grammar and language structure to generate an accurate transcription. Transcriptions are supported for various audio formats and languages.

The `SpeechToText` class is the SDK's primary interface for performing speech recognition requests. It supports the transcription of audio files, audio data, and streaming microphone data. Advanced users, however, may instead wish to use the `SpeechToTextSession` class that exposes more control over the WebSockets session.

Please be sure to include both `SpeechToTextV1.framework` and `Starscream.framework` in your application. Starscream is a recursive dependency that adds support for WebSockets sessions.

#### Recognition Request Settings

The `RecognitionSettings` class is used to define the audio format and behavior of a recognition request. These settings are transmitted to the service when [initating a request](https://console.bluemix.net/docs/services/speech-to-text/websockets.html#WSstart).

The following example demonstrates how to define a recognition request that transcribes WAV audio data with interim results:

```swift
var settings = RecognitionSettings(contentType: .wav)
settings.interimResults = true
```

See the [class documentation](http://watson-developer-cloud.github.io/ios-sdk/services/SpeechToTextV1/Structs/RecognitionSettings.html) or [service documentation](https://console.bluemix.net/docs/services/speech-to-text/index.html) for more information about the available settings.

#### Microphone Audio and Compression

The Speech to Text framework makes it easy to perform speech recognition with microphone audio. The framework internally manages the microphone, starting and stopping it with various function calls (such as `recognizeMicrophone(settings:model:customizationID:learningOptOut:compress:failure:success)` and `stopRecognizeMicrophone()` or `startMicrophone(compress:)` and `stopMicrophone()`).

There are two different ways that your app can determine when to stop the microphone:

- User Interaction: Your app could rely on user input to stop the microphone. For example, you could use a button to start/stop transcribing, or you could require users to press-and-hold a button to start/stop transcribing.

- Final Result: Each transcription result has a `final` property that is `true` when the audio stream is complete or a timeout has occurred. By watching for the `final` property, your app can stop the microphone after determining when the user has finished speaking.

To reduce latency and bandwidth, the microphone audio is compressed to OggOpus format by default. To disable compression, set the `compress` parameter to `false`.

It's important to specify the correct audio format for recognition requests that use the microphone:

```swift
// compressed microphone audio uses the OggOpus format
let settings = RecognitionSettings(contentType: .oggOpus)

// uncompressed microphone audio uses a 16-bit mono PCM format at 16 kHz
let settings = RecognitionSettings(contentType: .l16(rate: 16000, channels: 1))
```

#### Transcribe Recorded Audio

The following example demonstrates how to use the Speech to Text service to transcribe a WAV audio file.

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToText = SpeechToText(username: username, password: password)

let audio = Bundle.main.url(forResource: "filename", withExtension: "wav")!
var settings = RecognitionSettings(contentType: .wav)
settings.interimResults = true
let failure = { (error: Error) in print(error) }
speechToText.recognize(audio, settings: settings, failure: failure) {
    results in
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
    var settings = RecognitionSettings(contentType: .oggOpus)
    settings.interimResults = true
    let failure = { (error: Error) in print(error) }
    speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
        print(results.bestTranscript)
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

The following example demonstrates how to use `SpeechToTextSession` to transcribe microphone audio:

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToTextSession = SpeechToTextSession(username: username, password: password)

do {
    let session = AVAudioSession.sharedInstance()
    try session.setActive(true)
    try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.mixWithOthers, .defaultToSpeaker])
} catch {
    // handle errors
}

func startStreaming() {
    // define callbacks
    speechToTextSession.onConnect = { print("connected") }
    speechToTextSession.onDisconnect = { print("disconnected") }
    speechToTextSession.onError = { error in print(error) }
    speechToTextSession.onPowerData = { decibels in print(decibels) }
    speechToTextSession.onMicrophoneData = { data in print("received data") }
    speechToTextSession.onResults = { results in print(results.bestTranscript) }

    // define recognition request settings
    var settings = RecognitionSettings(contentType: .oggOpus)
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
Customize the language model interface to include and tailor domain-specific data and terminology. Improve the accuracy of speech recognition for domains within health care, law, medicine, information technology, and so on.

The following example demonstrates an example of how to customize the language model:

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToText = SpeechToText(username: username, password: password)

guard let corpusFile = loadFile(name: "healthcare-short", withExtension: "txt") else {
    NSLog("Failed to load file needed to create the corpus.")
    return
}

let newCorpusName = "swift-sdk-unit-test-corpus"

speechToText.addCorpus(
    withName: newCorpusName,
    fromFile: corpusFile,
    customizationID: trainedCustomizationID,
    failure: failWithError) {
}

// Get the custom corpus to build the trained customization
speechToText.getCorpus(
    withName: corpusName,
    customizationID: trainedCustomizationID,
    failure: failWithError) { corpus in

    print(corpus.name)
    // Check that the corpus is finished processing
    print("finished processing: \(corpus.status == .analyzed)")
    print(corpus.totalWords)
    print(corpus.outOfVocabularyWords)
    // Check the corpus has no error
    print("errors: \(corpus.error == nil)")
}
```

There is also an option to add words to a trained customization:

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToText = SpeechToText(username: username, password: password)
let error = NSError(domain: "testing", code: 0)

var trainedCustomizationName = "your-customization-name-here"
var customizationStatus = CustomizationStatus?


// Look up the customization to add the words to
speechToText.getCustomizations(failure: failure) { customizations in
    for customization in customizations {
        if customization.name == self.trainedCustomizationName {
            self.trainedCustomizationID = customization.customizationID
            customizationStatus = customization.status
        }
    }
}

guard let customizationStatus = customizationStatus else {
	throw error
}

// Check the customization status
switch customizationStatus {
case .available, .ready:
    break // do nothing, because the customization is trained
case .pending: // train -> then fail (wait for training)
    print("Training the `trained customization` used for tests.")
    self.trainCustomizationWithCorpus()
    print("The customization has been trained and is ready for use.")
case .training: // fail (wait for training)
    let message = "Please wait a few minutes for the trained customization to finish " +
    "training. You can try running the tests again afterwards."
    print(message)
    throw error
case .failed: // training failed => delete & retry
    let message = "Creating a trained ranker has failed. Check the errors " +
    "within the corpus and customization and retry."
    print(message)
    throw error
}

// Add custom words to the corpus
if customizationStatus == .available {
	let customWord1 = NewWord(word: "HHonors", soundsLike: ["hilton honors", "h honors"], displayAs: "HHonors")
	let customWord2 = NewWord(word: "IEEE", soundsLike: ["i triple e"])

	speechToText.addWords(
		customizationID: trainedCustomizationID,
		words: [customWord1, customWord2],
		failure: failWithError) {
		print("added words to corpus")
	}
}
```

#### Important notes
* Since v0.11.0, if you use `SpeechToTextSession`, you'll need to manage the setup for the `AVAudioSession` shared instance. Without the code below, you won't receive data from the Speech To Text service properly. This isn't necessary if you use the `SpeechToText` class.
```swift
do {
    let session = AVAudioSession.sharedInstance()
    try session.setActive(true)
    try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.mixWithOthers, .defaultToSpeaker])
} catch {
    // handle errors
}
```

* As of iOS 10, if you access the device's microphone, you'll be required to include the `NSMicrophoneUsageDescription` key in your `Info.plist` file, or the app will exit. Find more information about this [here](https://forums.developer.apple.com/thread/61521).

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
var audioPlayer = AVAudioPlayer() // see note below

let text = "your-text-here"
let failure = { (error: Error) in print(error) }
textToSpeech.synthesize(text, failure: failure) { data in
    audioPlayer = try! AVAudioPlayer(data: data)
    audioPlayer.prepareToPlay()
    audioPlayer.play()
}

// A note about AVAudioPlayer: The AVAudioPlayer object will stop playing
// if it falls out-of-scope. Therefore, it's important to declare it as a
// property or otherwise keep it in-scope beyond the completion handler.
```

The Text to Speech service supports a number of [voices](https://console.bluemix.net/docs/services/text-to-speech/http.html#voices) for different genders, languages, and dialects. The following example demonstrates how to use the Text to Speech service with a particular voice:

```swift
import TextToSpeechV1

let username = "your-username-here"
let password = "your-password-here"
let textToSpeech = TextToSpeech(username: username, password: password)
var audioPlayer = AVAudioPlayer() // see note below

let text = "your-text-here"
let failure = { (error: Error) in print(error) }
textToSpeech.synthesize(text, voice: SynthesisVoice.gb_Kate.rawValue, failure: failure) { data in
    audioPlayer = try! AVAudioPlayer(data: data)
    audioPlayer.prepareToPlay()
    audioPlayer.play()
}

// A note about AVAudioPlayer: The AVAudioPlayer object will stop playing
// if it falls out-of-scope. Therefore, it's important to declare it as a
// property or otherwise keep it in-scope beyond the completion handler.
```

#### Important notes
* Prior to v0.15.2, users could already request Opus as the return type. Opus files are much smaller than WAV files, so this would save bandwidth. However, Opus isn't playable by the iOS platform.
* In v0.15.2, we have added functionality to decode Opus files and convert them to WAV files.
* Currently, this is being done automatically when Opus files are requested. In a future release, we will allow users more control over when the decoding process occurs.

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

let text = "your-input-text"
let failure = { (error: Error) in print(error) }
toneAnalyzer.getTone(ofText: text, failure: failure) { tones in
    print(tones)
}
```

The following links provide more information about the IBM Watson Tone Analyzer service:

* [IBM Watson Tone Analyzer - Service Page](https://www.ibm.com/watson/services/tone-analyzer/)
* [IBM Watson Tone Analyzer - Documentation](https://console.bluemix.net/docs/services/tone-analyzer/index.html)
* [IBM Watson Tone Analyzer - Demo](https://tone-analyzer-demo.ng.bluemix.net/)

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
    type: .numeric,
    goal: .minimize,
    isObjective: true
)
let ram = Column(
    key: "ram",
    type: .numeric,
    goal: .maximize,
    isObjective: true
)
let screen = Column(
    key: "screen",
    type: .numeric,
    goal: .maximize,
    isObjective: true
)
let os = Column(
    key: "os",
    type: .categorical,
    isObjective: true,
    range: Range.categoricalRange(categories: ["android", "windows-phone", "blackberry", "ios"]),
    preference: ["android", "ios"]
)

// define options
let galaxy = Option(
    key: "galaxy",
    values: ["price": .int(50), "ram": .int(45), "screen": .int(5), "os": .string("android")],
    name: "Galaxy S4"
)
let iphone = Option(
    key: "iphone",
    values: ["price": .int(99), "ram": .int(40), "screen": .int(4), "os": .string("ios")],
    name: "iPhone 5"
)
let optimus = Option(
    key: "optimus",
    values: ["price": .int(10), "ram": .int(300), "screen": .int(5), "os": .string("android")],
    name: "LG Optimus G"
)

// define problem
let problem = Problem(
    columns: [price, ram, screen, os],
    options: [galaxy, iphone, optimus],
    subject: "Phone"
)

// define failure function
let failure = { (error: Error) in print(error) }

// identify optimal options
tradeoffAnalytics.getDilemma(for: problem, failure: failure) { dilemma in
    print(dilemma.resolution)
}
```

The following links provide more information about the IBM Watson Tradeoff Analytics service:

* [IBM Watson Tradeoff Analytics - Service Page](http://www.ibm.com/watson/developercloud/tradeoff-analytics.html)
* [IBM Watson Tradeoff Analytics - Documentation](https://console.bluemix.net/docs/services/tradeoff-analytics/index.html)
* [IBM Watson Tradeoff Analytics - Demo](https://tradeoff-analytics-demo.ng.bluemix.net/)

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
let failure = { (error: Error) in print(error) }
visualRecognition.classify(image: url, failure: failure) { classifiedImages in
    print(classifiedImages)
}
```

The following links provide more information about the IBM Watson Visual Recognition service:

* [IBM Watson Visual Recognition - Service Page](https://www.ibm.com/watson/services/visual-recognition/)
* [IBM Watson Visual Recognition - Documentation](https://console.bluemix.net/docs/services/visual-recognition/index.html)
* [IBM Watson Visual Recognition - Demo](https://visual-recognition-demo.ng.bluemix.net/)
