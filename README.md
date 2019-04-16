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
* [Compare & Comply](https://www.ibm.com/cloud/compare-and-comply)
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
- Swift 4.2+
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
    pod 'IBMWatsonAssistantV1', '~> 2.0.2'
    pod 'IBMWatsonAssistantV2', '~> 2.0.2'
    pod 'IBMWatsonCompareComplyV1', '~> 2.0.2'
    pod 'IBMWatsonDiscoveryV1', '~> 2.0.2'
    pod 'IBMWatsonLanguageTranslatorV3', '~> 2.0.2'
    pod 'IBMWatsonNaturalLanguageClassifierV1', '~> 2.0.2'
    pod 'IBMWatsonNaturalLanguageUnderstandingV1', '~> 2.0.2'
    pod 'IBMWatsonPersonalityInsightsV3', '~> 2.0.2'
    pod 'IBMWatsonSpeechToTextV1', '~> 2.0.2'
    pod 'IBMWatsonTextToSpeechV1', '~> 2.0.2'
    pod 'IBMWatsonToneAnalyzerV3', '~> 2.0.2'
    pod 'IBMWatsonVisualRecognitionV3', '~> 2.0.2'
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
github "watson-developer-cloud/swift-sdk" ~> 2.0.2
```

Then run the following command to build the dependencies and frameworks:

```bash
$ carthage update --platform iOS
```

Follow the remaining Carthage installation instructions [here](https://github.com/Carthage/Carthage#getting-started). Note that the above command will download and build all of the services in the IBM Watson Swift SDK. Make sure to drag-and-drop the built frameworks (only for the services your app requires) into your Xcode project and import them in the source files that require them. The following frameworks need to be added to your app:
1. `RestKit.framework`
1. Whichever services your app will be using (`AssistantV1.framework`, `DiscoveryV1.framework`, etc.)
1. (**Speech to Text only**) `Starscream.framework`

If your app fails to build because it is built with a different version of Swift than the downloaded SDK, then re-run the `carthage update` command with the `--no-use-binaries` flag added.


### Swift Package Manager

Add the following to your `Package.swift` file to identify the IBM Watson Swift SDK as a dependency. The package manager will clone the Swift SDK when you build your project with `swift build`.

```swift
dependencies: [
    .package(url: "https://github.com/watson-developer-cloud/swift-sdk", from: "2.0.2")
]
```


## Authentication

The Identity and Access Management (IAM) service of the IBM Cloud is the primary method of authentication to IBM Cloud services.
Some service instances may use an alternate form of authentication, such as basic authentication (username and password).

### Getting credentials
To find out which authentication to use, view the service credentials. You find the service credentials for authentication the same way for all Watson services:

1. Go to the IBM Cloud [Dashboard](https://cloud.ibm.com/) page.
1. Either click an existing Watson service instance in your [resource list](https://cloud.ibm.com/resources) or click [**Create resource > AI**](https://cloud.ibm.com/catalog?category=ai) and create a service instance.
1. Click on the **Manage** item in the left nav bar of your service instance.

On this page, you will see your credentials to use in the SDK to access your service instance.

### Supplying credentials

The SDK provides separate init methods for each form of authentication that may be used by instances of the service.

- For service instances that use **[IAM](#iam)** authentication, the SDK provides two init methods -- one that accepts an apikey and another
that accepts an access token created from an apikey. If you use the init method that supplies the apikey, the SDK will obtain an
access token and refresh it when needed. If you initialize the SDK with the method that supplies an access token, you will need
to periodically refresh the token as they expire after a short time. Learn more about [IAM](link).

- For service instances that use basic authentication (username and password), use the init method that specifies the username
and password.

#### Credentials in the environment or a local credentials file

The SDK can extract service credentails from the environment, e.g. the VCAP_SERVICES environment variable, or a local credentials file.

To use credentials stored in a local file, go to the **Manage** tab of your service instance on IBM Cloud, and click on the button to download the credentials. The file will be called `ibm-credentials.env`. Add this file to a location that is accessible from your project. For iOS apps, make sure to add it to the application target.

```swift
let discovery = Discovery(version: "your-version")
```

If your project is using multiple Watson services, you can merge the contents of the `ibm-credentials.env` files into a single file. Lines in the file can be added, deleted, or reordered, but the content of each line **must not** be changed.

#### Copy-Pasting Credentials

Copy the credentials from IBM Cloud and store them within your project. Then pass those values to the service initializer that accepts the type of credentials you have.

##### IAM

Some services use token-based Identity and Access Management (IAM) authentication. IAM authentication uses a service API key to get an access token that is passed with the call. Access tokens are valid for approximately one hour and must be regenerated.

You supply either an IAM service **API key** or an **access token**:

- Use the API key to have the SDK manage the lifecycle of the access token. The SDK requests an access token, ensures that the access token is valid, and refreshes it if necessary.
- Use the access token if you want to manage the lifecycle yourself. For details, see [Authenticating with IAM tokens](https://cloud.ibm.com/docs/services/watson/getting-started-iam.html). If you want to switch to API key, override your stored IAM credentials with an IAM API key.

###### Supplying the IAM API key
```swift
let discovery = Discovery(version: "your-version", apiKey: "your-apikey")
```

If you are supplying an API key for IBM Cloud Private (ICP), use basic authentication instead, with `"apikey"` for the `username` and the api key (prefixed with `icp-`) for the `password`. See the [Username and Password](#username-and-password) section.

###### Supplying the accessToken
```swift
let discovery = Discovery(version: "your-version", accessToken: "your-accessToken")
```
###### Updating the accessToken
```swift
discovery.accessToken("new-accessToken")
```


##### Username and Password

```swift
let discovery = Discovery(version: "your-version", username: "your-username", password: "your-password")
```



## Custom Service URLs

You can set a custom service URL by modifying the `serviceURL` property. A custom service URL may be required when running an  instance in a particular region or connecting through a proxy.

For example, here is how to connect to a Tone Analyzer instance that is hosted in Germany:

```swift
let toneAnalyzer = ToneAnalyzer(
    version: "yyyy-mm-dd",
    username: "your-username",
    password: "your-password"
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
