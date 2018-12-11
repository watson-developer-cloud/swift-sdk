# Watson Developer Cloud Swift SDK

[![Build Status](https://travis-ci.org/watson-developer-cloud/swift-sdk.svg?branch=master)](https://travis-ci.org/watson-developer-cloud/swift-sdk)
![](https://img.shields.io/badge/platform-iOS,%20Linux-blue.svg?style=flat)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Documentation](https://img.shields.io/badge/Documentation-API-blue.svg)](http://watson-developer-cloud.github.io/swift-sdk)
[![CLA assistant](https://cla-assistant.io/readme/badge/watson-developer-cloud/swift-sdk)](https://cla-assistant.io/watson-developer-cloud/swift-sdk)

## Overview

The Watson Developer Cloud Swift SDK makes it easy for mobile developers to build Watson-powered applications. With the Swift SDK you can leverage the power of Watson's advanced artificial intelligence, machine learning, and deep learning techniques to understand unstructured data and engage with mobile users in new ways.

There are many resources to help you build your first cognitive application with the Swift SDK:

- Follow the [QuickStart Guide](https://watson-developer-cloud.github.io/swift-sdk/docs/quickstart)
- Review a [Sample Application](#sample-applications)
- Browse the [Documentation](https://watson-developer-cloud.github.io/swift-sdk/)

## Contents

### General

* [Before you begin](#before-you-begin)
* [Requirements](#requirements)
* [Installation](#installation)
* [Authentication](#authentication)
* [Custom Service URLs](#custom-service-urls)
* [Custom Headers](#custom-headers)
* [Sample Applications](#sample-applications)
* [Synchronous Execution](#synchronous-execution)
* [Objective-C Compatibility](#objective-c-compatibility)
* [Linux Compatibility](#linux-compatibility)
* [Contributing](#contributing)
* [License](#license)

### Services

This SDK provides classes and methods to access the following Watson services.

* [Assistant](https://www.ibm.com/cloud/watson-assistant/)
* [Discovery](https://www.ibm.com/watson/services/discovery)
* [Language Translator V3](https://www.ibm.com/watson/services/language-translator)
* [Natural Language Classifier](https://www.ibm.com/watson/services/natural-language-classifier)
* [Natural Language Understanding](https://www.ibm.com/watson/services/natural-language-understanding)
* [Personality Insights](https://www.ibm.com/watson/services/personality-insights)
* [Speech to Text](https://www.ibm.com/watson/services/speech-to-text)
* [Text to Speech](https://www.ibm.com/watson/services/text-to-speech)
* [Tone Analyzer](https://www.ibm.com/watson/services/tone-analyzer)
* [Visual Recognition](https://www.ibm.com/watson/services/visual-recognition)

## Before you begin
* You need an [IBM Cloud][ibm-cloud-onboarding] account.

## Requirements

- Xcode 9.3+
- Swift 4.1+
- iOS 10.0+



## Installation

The IBM Watson Swift SDK can be installed with [Cocoapods](http://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage), or [Swift Package Manager](https://swift.org/package-manager/).

### Cocoapods

You can install Cocoapods with [RubyGems](https://rubygems.org/):

```bash
$ sudo gem install cocoapods
```

If your project does not yet have a Podfile, use the `pod init` command in the root directory of your project. To install the Swift SDK using Cocoapods, add the services you will be using to your Podfile as demonstrated below (substituting `MyApp` with the name of your app). The example below shows all of the currently available services; your Podfile should only include the services that your app will use.

```ruby
use_frameworks!

target 'MyApp' do
    pod 'IBMWatsonAssistantV1', '~> 1.1.0'
    pod 'IBMWatsonAssistantV2', '~> 1.1.0'
    pod 'IBMWatsonDiscoveryV1', '~> 1.1.0'
    pod 'IBMWatsonLanguageTranslatorV3', '~> 1.1.0'
    pod 'IBMWatsonNaturalLanguageClassifierV1', '~> 1.1.0'
    pod 'IBMWatsonNaturalLanguageUnderstandingV1', '~> 1.1.0'
    pod 'IBMWatsonPersonalityInsightsV3', '~> 1.1.0'
    pod 'IBMWatsonSpeechToTextV1', '~> 1.1.0'
    pod 'IBMWatsonTextToSpeechV1', '~> 1.1.0'
    pod 'IBMWatsonToneAnalyzerV3', '~> 1.1.0'
    pod 'IBMWatsonVisualRecognitionV3', '~> 1.1.0'
end
```

Run the `pod install` command, and open the generated `.xcworkspace` file. To update to newer releases, use `pod update`.

When importing the frameworks in source files, exclude the `IBMWatson` prefix and the version suffix. For example, after installing `IBMWatsonAssistantV1`, import it in your source files as `import Assistant`.

For more information on using Cocoapods, refer to the [Cocoapods Guides](https://guides.cocoapods.org/using/index.html).


### Carthage

You can install Carthage with [Homebrew](http://brew.sh/):

```bash
$ brew update
$ brew install carthage
```

If your project does not have a Cartfile yet, use the `touch Cartfile` command in the root directory of your project. To install the IBM Watson Swift SDK using Carthage, add the following to your Cartfile. 

```
github "watson-developer-cloud/swift-sdk" ~> 1.1.0
```

Then run the following command to build the dependencies and frameworks:

```bash
$ carthage update --platform iOS
```

Follow the remaining Carthage installation instructions [here](https://github.com/Carthage/Carthage#getting-started). Note that the above command will download and build all of the services in the IBM Watson Swift SDK. Make sure to drag-and-drop the built frameworks (only for the services your app requires) into your Xcode project and import them in the source files that require them. The following frameworks need to be added to your app:
1. `RestKit.framework`
1. Whichever services your app will be using (`AssistantV1.framework`, `DiscoveryV1.framework`, etc.)
1. (**Speech to Text only**) `Starscream.framework`


### Swift Package Manager

Add the following to your `Package.swift` file to identify the IBM Watson Swift SDK as a dependency. The package manager will clone the Swift SDK when you build your project with `swift build`.

```swift
dependencies: [
    .package(url: "https://github.com/watson-developer-cloud/swift-sdk", from: "1.1.0")
]
```


## Authentication

Watson services are migrating to token-based Identity and Access Management (IAM) authentication.

- With some service instances, you authenticate to the API by using **[IAM](#iam)**.
- In other instances, you authenticate by providing the **[username and password](#username-and-password)** for the service instance.
- Visual Recognition uses a form of [API key](#api-key) only with instances created before May 23, 2018. Newer instances of Visual Recognition use [IAM](#iam).

### Getting credentials
To find out which authentication to use, view the service credentials. You find the service credentials for authentication the same way for all Watson services:

1. Go to the IBM Cloud [Dashboard](https://cloud.ibm.com/dashboard/apps?category=ai) page.
1. Either click an existing Watson service instance or click [**Create resource > AI**](https://cloud.ibm.com/catalog/?category=ai) and create a service instance.
1. Click **Show** to view your service credentials.
1. Copy the `url` and either `apikey` or `username` and `password`.

### IAM

Some services use token-based Identity and Access Management (IAM) authentication. IAM authentication uses a service API key to get an access token that is passed with the call. Access tokens are valid for approximately one hour and must be regenerated.

You supply either an IAM service **API key** or an **access token**:

- Use the API key to have the SDK manage the lifecycle of the access token. The SDK requests an access token, ensures that the access token is valid, and refreshes it if necessary.
- Use the access token if you want to manage the lifecycle yourself. For details, see [Authenticating with IAM tokens](https://cloud.ibm.com/docs/services/watson/getting-started-iam.html). If you want to switch to API key, override your stored IAM credentials with an IAM API key.

#### Supplying the IAM API key
```swift
let discovery = Discovery(version: "your-version", apiKey: "your-apikey")
```

If you are supplying an API key for IBM Cloud Private (ICP), use basic authentication instead, with `"apikey"` for the `username` and the api key (prefixed with `icp-`) for the `password`. See the [Username and Password](#username-and-password) section.

#### Supplying the accessToken
```swift
let discovery = Discovery(version: "your-version", accessToken: "your-accessToken")
```
#### Updating the accessToken
```swift
discovery.accessToken("new-accessToken")
```

### Username and Password

```swift
let discovery = Discovery(username: "your-username", password: "your-password", version: "your-version")
```


## Custom Service URLs

You can set a custom service URL by modifying the `serviceURL` property. A custom service URL may be required when running an  instance in a particular region or connecting through a proxy.

For example, here is how to connect to a Tone Analyzer instance that is hosted in Germany:

```swift
let toneAnalyzer = ToneAnalyzer(
    username: "your-username",
    password: "your-password",
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

By default, the SDK executes all networking operations asynchronously. If your application requires synchronous execution, you can use a `DispatchGroup`. For example:

```swift
let dispatchGroup = DispatchGroup()
dispatchGroup.enter()
assistant.message(workspaceID: workspaceID) { response, error in
	if let error = error {
        print(error)
    }
    if let message = response?.result else {
        print(message.output.text)
    }
    dispatchGroup.leave()
}
dispatchGroup.wait(timeout: .distantFuture)
```

## Objective-C Compatibility

Please see [this tutorial](https://watson-developer-cloud.github.io/swift-sdk/docs/objective-c) for more information about consuming the Watson Developer Cloud Swift SDK in an Objective-C application.

## Linux Compatibility

To use the Watson SDK in your Linux project, please follow the [Swift Package Manager instructions.](#swift-package-manager). Note that Speech to Text and Text to Speech are not supported because they rely on frameworks that are unavailable on Linux.

## Contributing

We would love any and all help! If you would like to contribute, please read our [CONTRIBUTING](https://github.com/watson-developer-cloud/swift-sdk/blob/master/.github/CONTRIBUTING.md) documentation with information on getting started.

## License

This library is licensed under Apache 2.0. Full license text is
available in [LICENSE](https://github.com/watson-developer-cloud/swift-sdk/blob/master/LICENSE).

This SDK is intended for use with an Apple iOS product and intended to be used in conjunction with officially licensed Apple development tools.

[ibm-cloud-onboarding]: http://console.bluemix.net/registration?target=/developer/watson&cm_sp=WatsonPlatform-WatsonServices-_-OnPageNavLink-IBMWatson_SDKs-_-Swift
