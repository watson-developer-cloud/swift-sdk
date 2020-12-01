# Watson Developer Cloud Swift SDK

[![Build Status](https://travis-ci.org/watson-developer-cloud/swift-sdk.svg?branch=master)](https://travis-ci.org/watson-developer-cloud/swift-sdk)
![](https://img.shields.io/badge/platform-iOS,%20Linux-blue.svg?style=flat)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Documentation](https://img.shields.io/badge/Documentation-API-blue.svg)](http://watson-developer-cloud.github.io/swift-sdk)
[![CLA assistant](https://cla-assistant.io/readme/badge/watson-developer-cloud/swift-sdk)](https://cla-assistant.io/watson-developer-cloud/swift-sdk)
[![wdc-community.slack.com](https://wdc-slack-inviter.mybluemix.net/badge.svg)](http://wdc-slack-inviter.mybluemix.net/)


## Overview

The Watson Developer Cloud Swift SDK makes it easy for mobile developers to build Watson-powered applications. With the Swift SDK you can leverage the power of Watson's advanced artificial intelligence, machine learning, and deep learning techniques to understand unstructured data and engage with mobile users in new ways.

There are many resources to help you build your first cognitive application with the Swift SDK:

- Review a [Featured Project](#featured-projects)
- Browse the [Documentation](https://watson-developer-cloud.github.io/swift-sdk/)

## Contents

### General

* [Before you begin](#before-you-begin)
* [Requirements](#requirements)
* [Installation](#installation)
* [Known Issues](#known-issues)
* [Authentication](#authentication)
* [Custom Service URLs](#custom-service-urls)
* [Obtaining Transaction IDs](#obtaining-transaction-ids)
* [Custom Headers](#custom-headers)
* [Featured Projects](#featured-projects)
* [Synchronous Execution](#synchronous-execution)
* [Handling PNG and CgBI Files in XCode](#How-to-bypass-CgBI-Encoding-for-Resource-Files)
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

## ANNOUNCEMENTS!
### Personality Insights deprecation
IBM Watson™ Personality Insights is discontinued. For a period of one year from 1 December 2020, you will still be able to use Watson Personality Insights. However, as of 1 December 2021, the offering will no longer be available.

As an alternative, we encourage you to consider migrating to IBM Watson™ [Natural Language Understanding](https://cloud.ibm.com/docs/natural-language-understanding), a service on IBM Cloud® that uses deep learning to extract data and insights from text such as keywords, categories, sentiment, emotion, and syntax to provide insights for your business or industry. For more information, see About Natural Language Understanding.

### Visual Recognition deprecation
IBM Watson™ Visual Recognition is discontinued. Existing instances are supported until 1 December 2021, but as of 7 January 2021, you can't create instances. Any instance that is provisioned on 1 December 2021 will be deleted.

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
    pod 'IBMWatsonAssistantV1', '~> 3.6.0'
    pod 'IBMWatsonAssistantV2', '~> 3.6.0'
    pod 'IBMWatsonCompareComplyV1', '~> 3.6.0'
    pod 'IBMWatsonDiscoveryV1', '~> 3.6.0'
    pod 'IBMWatsonLanguageTranslatorV3', '~> 3.6.0'
    pod 'IBMWatsonNaturalLanguageClassifierV1', '~> 3.6.0'
    pod 'IBMWatsonNaturalLanguageUnderstandingV1', '~> 3.6.0'
    pod 'IBMWatsonPersonalityInsightsV3', '~> 3.6.0'
    pod 'IBMWatsonSpeechToTextV1', '~> 3.6.0'
    pod 'IBMWatsonTextToSpeechV1', '~> 3.6.0'
    pod 'IBMWatsonToneAnalyzerV3', '~> 3.6.0'
    pod 'IBMWatsonVisualRecognitionV3', '~> 3.6.0'
end
```

Run the `pod install` command, and open the generated `.xcworkspace` file. To update to newer releases, use `pod update`.

When importing the frameworks in source files, exclude the `IBMWatson` prefix and the version suffix. For example, after installing `IBMWatsonAssistantV1`, import it in your source files as `import Assistant`.

For more information on using Cocoapods, refer to the [Cocoapods Guides](https://guides.cocoapods.org/using/index.html).


### Carthage

**NOTE**: Current issues with Carthage and XCode 12 prevents installation of necessary dependencies. See [Known Issues](https://github.com/watson-developer-cloud/swift-sdk#known-issues)

You can install Carthage with [Homebrew](http://brew.sh/):

```bash
$ brew update
$ brew install carthage
```

If your project does not have a Cartfile yet, use the `touch Cartfile` command in the root directory of your project. To install the IBM Watson Swift SDK using Carthage, add the following to your Cartfile.

```
github "watson-developer-cloud/swift-sdk" ~> 3.6.0
```

Then run the following command to build the dependencies and frameworks:

```bash
$ carthage bootstrap --platform iOS
```

Follow the remaining Carthage installation instructions [here](https://github.com/Carthage/Carthage#getting-started). Note that the above command will download and build all of the services in the IBM Watson Swift SDK. Make sure to drag-and-drop the built frameworks (only for the services your app requires) into your Xcode project and import them in the source files that require them. The following frameworks need to be added to your app:
1. `IBMSwiftSDKCore.framework`
1. Whichever services your app will be using (`AssistantV1.framework`, `DiscoveryV1.framework`, etc.)
1. (**Speech to Text only**) `Starscream.framework`

If your app fails to build because it is built with a different version of Swift than the downloaded SDK, then re-run the `carthage update` command with the `--no-use-binaries` flag added.


### Swift Package Manager

Add the following to your `Package.swift` file to identify the IBM Watson Swift SDK as a dependency. The package manager will clone the Swift SDK when you build your project with `swift build`.

```swift
dependencies: [
    .package(url: "https://github.com/watson-developer-cloud/swift-sdk", from: "3.6.0")
]
```

## Known Issues

There is a known issue with Carthage and XCode 12 that prevents installation of the required dependency Starscream. There is already an [issue thread](https://github.com/Carthage/Carthage/issues/3019) up on the Carthage repository with a [workaround script](https://github.com/getsentry/sentry-cocoa/pull/780) that can be run to address the issue.  Until there is a version released that truly addresses this issue, it is recommended to either use one of the other two package managers or use the workaround script. 

## Authentication

In order to use an IBM Watson service in a Swift application, you will need to authenticate. The following describes the typical path you need to take to do so.

### Step 1: Getting credentials
Credentials to use an IBM Watson service are obtained via IBM Cloud. You will need an active account and a service instance for the service that you wish to use prior to authenticating in your Swift app.

You can access the service credentials for your instance by taking the following steps:

1. Go to the IBM Cloud [Dashboard](https://cloud.ibm.com/) page.
1. Either click an existing Watson service instance in your [resource list](https://cloud.ibm.com/resources) or click [**Create resource > AI**](https://cloud.ibm.com/catalog?category=ai) and create a service instance.
1. Click on the **Manage** item in the left nav bar of your service instance.

On this page, you will see your credentials to use in the SDK to access your service instance.

### Step 2: Authenticating in Code

The Watson Swift SDK manages authentication using an `Authenticator` class. There are multiple types of Authenticators depending on your preferred method.

#### WatsonIAMAuthenticator (most common)

The `WatsonIAMAuthenticator` allows you to authenticate with using an IAM API key. This is the most common form of authentication within IBM Cloud. The `WatsonIAMAuthenticator` requires an `apikey` string in its initialization method.

Example:

```swift
let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let assistant = Assistant(version: "{version}", authenticator: authenticator)

...
```

#### WatsonBearerTokenAuthenticator

You may want to provide a bearer token to authenticate with a service. On IBM Cloud this would be done using the IAM service to generate a token based on your service credentials. On Cloud Pak for Data this would be available within an individual service instance.

To authenticate in a Swift app using an access token, you can use the `WatsonBearerTokenAuthenticator`, and provide the token.

Example:

```swift
let authenticator = WatsonBearerTokenAuthenticator(bearerToken: "{token}")
let assistant = Assistant(version: "{version}", authenticator: authenticator)

...
```

#### WatsonCloudPakForDataAuthenticator

If you are using IBM Cloud Pak for Data (CP4D) instead of the public IBM Cloud, you can use the `WatsonCloudPakForDataAuthenticator` to authenticate with your CP4D cluster. As opposed to `WatsonBearerTokenAuthenticator` which accepts a bearer token, the `WatsonCloudPakForDataAuthenticator` accepts the username and password for the CP4D cluster itself.

Example:

```swift
let authenticator = WatsonCloudPakForDataAuthenticator(username: "{username}", password: "{password}", url: "https://{cpd_cluster_host}{:port}")
let assistant = Assistant(version: "{version}", authenticator: authenticator)

...
```

#### Detecting authentication from environment variables

The SDK can extract service credentails from the environment, e.g. the VCAP_SERVICES environment variable, or a local credentials file.

To use credentials stored in a local file, go to the Manage tab of your service instance on IBM Cloud, and click on the button to download the credentials. The file will be called `ibm-credentials.env`. Add this file to a location that is accessible from your project. For iOS apps, make sure to add it to the application target.

```swift
let assistant = Assistant(version: "your-version") // by calling the init method without an authenticator, the SDK will search for environment variables

...
```

If your project is using multiple Watson services, you can merge the contents of the `ibm-credentials.env` files into a single file. Lines in the file can be added, deleted, or reordered, but the content of each line must not be changed.

#### Further info on authentication methods

To see further details and additional, but less common, forms of authentication, see the [IBM Swift SDK Core code for Authenticator.](https://github.com/IBM/swift-sdk-core/tree/master/Sources/IBMSwiftSDKCore/Authentication)

## Custom Service URLs

You can set a custom service URL by modifying the `serviceURL` property. A custom service URL may be required when running an  instance in a particular region or connecting through a proxy.

For example, here is how to connect to a Watson Assistant instance that is hosted in Germany:

```swift
let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let assistant = Assistant(version: "{version}", authenticator: authenticator)

assistant.serviceURL = "https://api.eu-de.assistant.watson.cloud.ibm.com"
```

## Disable SSL certificate verification

For Watson Cloud Pak for Data (CP4D), you may need to disable SSL hostname verification if you are using self-signed certificates. Each service class has a `disableSSLVerification` method which allows you to do so.

``` swift
let authenticator = WatsonCloudPakForDataAuthenticator(username: "{username}", password: "{password}", url: "https://{cpd_cluster_host}{:port}")
let assistant = Assistant(version: "{version}", authenticator: authenticator)

assistant.disableSSLVerification()
```

Note: `disableSSLVerification()` is currently not supported on Linux.

## Obtaining Transaction IDs

When debugging an issue with IBM support, you may be asked to provide a `transaction ID` to help IBM identify an API call that needs to be debugged.

Every SDK call returns a response with a transaction ID in the `X-Global-Transaction-Id` header. Together the service instance region, this ID helps support teams troubleshoot issues from relevant logs.

You can access the header following the pattern below:

```swift
import AssistantV1

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let assistant = Assistant(version: "2020-04-01", authenticator: authenticator)
assistant.serviceURL = "{url}"

let workspaceID = getWorkspaceID()
let input = MessageInput(text: "Hello")

// let's say this request isn't working and you need the transaction ID
assistant.message(workspaceID: "{workspace_id}", input: input) {
  response, error in

  print(response?.headers["X-Global-Transaction-Id"]!)

  ...
}
```

However, the transaction ID isn't available when the API doesn't return a response for some reason. In that case, you can set your own transaction ID in the request. For example, replace `<my-unique-transaction-id>` in the following example with a unique transaction ID.

```swift
let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let assistant = Assistant(version: "2020-04-01", authenticator: authenticator)
assistant.serviceURL = "{url}"

let workspaceID = getWorkspaceID()
let input = MessageInput(text: "Hello")

assistant.message(workspaceID: "{workspace_id}", input: input, headers: ["X-Global-Transaction-Id": "<my-unique-transaction-id>"]) {
  response, error in

  print(response?.headers["X-Global-Transaction-Id"]!)

  ...
}
```

## Custom Headers
There are different headers that can be sent to the Watson services. For example, Watson services log requests and their results for the purpose of improving the services, but you can include the `X-Watson-Learning-Opt-Out` header to opt out of this.

We have exposed a `defaultHeaders` public property in each class to allow users to easily customize their headers:

```swift
let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let assistant = Assistant(version: "{version}", authenticator: authenticator)

assistant.defaultHeaders = ["X-Watson-Learning-Opt-Out": "true"]
```

Each service method also accepts an optional `headers` parameter which is a dictionary of request headers to be sent with the request.

## Questions

If you have issues with the APIs or have a question about the Watson services, see [Stack Overflow](https://stackoverflow.com/questions/tagged/ibm-watson+swift).

## Featured Projects

We love to highlight cool open-source projects that use this SDK! If you'd like to get your project added to the list, feel free to make an issue linking us to it.

* [Simple Chat (Swift)](https://github.com/watson-developer-cloud/simple-chat-swift)
* [Visual Recognition with Core ML](https://github.com/watson-developer-cloud/visual-recognition-coreml)
* [Visual Recognition and Discovery with Core ML](https://github.com/watson-developer-cloud/visual-recognition-with-discovery-coreml)
* [Speech to Text](https://github.com/watson-developer-cloud/speech-to-text-swift)
* [Text to Speech](https://github.com/watson-developer-cloud/text-to-speech-swift)

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
## Handling PNG and CgBI Files in XCode

When working with iOS projects, you may need to add PNG images to your XCode resource bundle. By default, XCode converts PNG files to Apple's [CgBI file format](http://iphonedevwiki.net/index.php/CgBI_file_format) as an optimization step.

Watson services that accept PNG images as input files (Visual Recognition, Compare and Comply) are not able to process CgBI files. In some cases passing PNGs that have been encoded as CgBI will result in HTTP errors, and in other cases (Visual Recognition) will result in a `200 Success` with no results.

### How to bypass CgBI Encoding for Resource Files

In order to bypass CgBI encoding and keep the PNG files in a format that will operate well with Watson services, select the PNG file in XCode, and modify the `Type` attribute to `Data` in the File Inspector.

Ex:  
![File inspector example](https://raw.githubusercontent.com/watson-developer-cloud/swift-sdk/master/docs/images/png-file-inspector.png)

### Future plans for handling CgBI

In the future, we will explore our options to handle conversion between CgBI and PNG within the Swift SDK, but this is currently not available.

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

[ibm-cloud-onboarding]: http://cloud.ibm.com/registration?target=/developer/watson&cm_sp=WatsonPlatform-WatsonServices-_-OnPageNavLink-IBMWatson_SDKs-_-Swift
