Change Log
==========

## Version 0.35.0
_2018-09-25_

This release adds the new AssistantV2 service.

## Version 0.34.0
_2018-09-14_

This release regenerates all services with documentation updates, adds support for IBM Cloud Private authentication, and adds a couple of new properties to Speech to Text and Assistant/Conversation.

This release includes the following new features:

- All services: Adds support for authentication with IBM Cloud Private (ICP) API keys. Use the `init(username:password:)` initializer, passing `apikey` for the `username` parameter and the API key for the `password`.
- Speech to Text: Adds the language models `de-DE_BroadbandModel`, `pt-BR_BroadbandModel`, and `pt-BR_NarrowbandModel`
- Assistant/Conversation: Add the `actions` property to `MessageResponse` and `OutputData`

## Version 0.33.1

Internal bug fix regarding RestKit.framework. This should have no impact on users.

## Version 0.33.0
_2018-08-31_

### First release that supports Cocoapods!

This release adds support for installing each service in the Swift SDK via Cocoapods. It also adds new options to the Speech to Text `recognize` API, and includes documentation improvements.

- Support for Cocoapods!
- Speech to Text: Adds the `acousticCustomizationID` and `headers` parameters to the `recognize()` method
- Speech to Text: Adds the `customizationWeight` property to `RecognitionSettings`
- Documentation: Split README into multiple READMEs: one main README plus one README for each service
- Documentation: Improved [Jazzy docs](http://watson-developer-cloud.github.io/swift-sdk/)

## Version 0.32.0
_2018-08-16_

This release regenerates all services with documentation updates, and adds some new methods to Discovery.

This release includes the following new features:

- Discovery: Add ability to create new `Events` to create log entries associated with specific queries
- Discovery: Add new methods to obtain metrics and metadata on past queries
- Discovery: Changes the type of the `size` parameter in the `createEnvironment` method from `Int` to `String`.

## Version 0.31.0
_2018-07-31_

This release regenerates all services with documentation updates and minor generator improvements.

This release includes the following new features and bug fixes:

- Assistant: Add support for entity mentions and disambiguation
- Renames STT Websocket method to `recognizeUsingWebSocket`.  The prior name is deprecated but retained for backward compatibility.
- Fix Xcode 10 build error

## Version 0.30.0
_2018-07-16_

This release regenerates all services with documentation updates and minor generator improvements.

This release includes the following new features and bug fixes:

- Discovery: Add support for credentials and configuration source options
- Add support for websocket features for services using IAM authentication
- Handle malformed URLs when constructing URL requests
- Remove version param from IAM init methods for LTv2, NLC, STT, TTS

## Version 0.29.0
_2018-06-29_

This release regenerates all services with generator updates for error handling and multi-consumes operations.

The release also adds a deprecation notice for the Language Translator v2 service.  Users are encouraged to migrate
to the new Language Translator v3 service.

This release should be fully compatible with the previous SDK release.

## Version 0.28.1
_2018-06-21_

This release regenerates just the NLC service to add support for IAM authentication.

## Version 0.28.0
_2018-06-12_

This release regenerates all services. It includes updates to the documentation and some minor new service features.

This release includes the following new features and bug fixes:

- Adds support for the new Language Translator V3 service and deprecates Language Translator V2
- Fix for issue 833

## Version 0.27.0
_2018-05-28_

This release regenerates all services. It includes updates to the documentation and some minor new service features.

This release includes the following new features and bug fixes:

- Adds support for IAM authentication, using either an IAM API Key or an access_token obtained using the service API Key

## Version 0.26.0
_2018-05-17_

This release regenerates all services. It includes updates to the documentation and some minor new service features.

This release includes the following new features and bug fixes:

- Adds a `headers`  parameter to all service methods that can be used to pass request headers to be sent with the request.
- Adds a `deleteUserData` method in some services to allow deletion of data associated with a specified `customer_id`.

## Version 0.25.0
_2018-04-26_

This release regenerates all services except for Visual Recognition. It includes considerable updates to the function documentation and model serialization/deserialization, although they should not be breaking changes for users.

This release also includes the following new features and bug fixes:

- Discovery: Adds support for document segmentation
- Natural Language Classifier: Adds support for `classifyCollection`
- Speech to Text: Adds acoustic model customization
- Speech to Text: Adds enums for `BaseModelName`
- Tone Analyzer: Fixes a bug with the `tones` list for the `tone` function
- Tone Analyzer: Adds `contentLanguage` parameter to `toneChat`
- Tone Analyzer: Adds plain-text and HTML variants of the `tone` function
- Tone Analyzer: Removes unused `content-type` parameter from the JSON variant of the `tone` function

## Version 0.24.1
_2018-04-21_

This release fixes a bug with SwiftLint and Xcode 9.3 by reducing the severity of the `superfluous_disable_command` rule to a `warning` instead of an `error`.

## Version 0.24.0
_2018-04-09_

This release includes major updates to support the latest version of the Discovery service. Note that the Discovery Service's API has been changed in order to improve uniformity between the Watson SDKs.

## Version 0.23.4
_2018-04-09_

This release fixes a bug with the `updateClassifier` method in Visual Recognition.

## Version 0.23.3
_2018-04-02_

This release improves support for Swift 4.1 and Xcode 9.3.

## Version 0.23.2
_2018-03-28_

This release fixes a few bugs for Linux compatibility:
- Only `import CoreML` in supported environments
- Include Assistant tests in `LinuxMain.swift`

It also updates the readme for API changes introduced in v0.22.0.

## Version 0.23.1
_2018-03-22_

This release fixes a bug with `created` and `updated` dates when using the `2018-02-16` version of Assistant or Conversation.

## Version 0.23.0
_2018-03-20_

This update adds Apple Core ML support for Visual Recognition. With Core ML you can download a trained classifier model and use it for offline image classification.

## Version 0.22.0
_2018-03-16_

This update adds the Assistant service.

In addition, the following services have been updated to support their latest release. Note that some APIs have changed in order to improve uniformity between the Watson SDKs.

- Conversation
- Language Translator
- Natural Language Classifier
- Natural Language Understanding
- Personality Insights
- Text to Speech
- Tone Analyzer
- Visual Recognition

The following deprecated services have also been removed from the SDK:

- AlchemyDataNewsV1
- AlchemyLanguageV1
- AlchemyVisionV1
- DialogV1
- DocumentConversionV1
- PersonalityInsightsV2
- RelationshipExtractionV1Beta
- RetrieveAndRankV1
- TradeoffAnalyticsV1

## Version 0.21.0
_2018-02-01_

- Change uses of `NSLocalizedFailureReasonErrorKey` to `NSLocalizedDescriptionKey` for Linux compatibility
- Only lint the `Source/Service` folder for framework build targets (fixes a bug with carthage --no-use-binaries)
- Fix style errors reported by `swiftlint` (fixes a bug with carthage --no-use-binaries)
- Improve test infrastructure for simulator and Linux

## Version 0.20.0
_2018-01-17_

This release extracts Starscream to be an _external_ dependency. Starscream adds support for WebSockets sessions and is required for use with the Speech to Text service. Because it is an _external_ dependency, developers using the SDK must now link and embed it in their projects. For more information, see [Readme: Speech to Text](https://github.com/watson-developer-cloud/swift-sdk#speech-to-text).

This release also includes the following additional changes:
- Deprecate Document Conversion
- Add conditional compilation by platform to improve future compatibility with Linux
- Set client WebSockets timeout to match the Speech to Text service (30s)
- Improve code style using SwiftLint

## Version 0.19.0
_2017-10-24_

This release includes the following changes:
- Update Conversation to support 2017-05-26 release with Codable models
- Update Natural Language Understanding to support 2017-02-27 release with Codable models
- Update Visual Recognition to deprecate similarity search operations
- Update Speech to Text to fix a bug with interim speaker labels
- Remove RestKit target (files are now included directly in each service's target)
- Update Package.swift for swift-tools-version:4.0
- Update Starscream dependency
- Update libopus dependency to v1.1.3
- Add extensions to support [String: Any] metadata with Codable models
- Add extensions to support additional properties with Codable models

## Version 0.18.0
_2017-10-01_

This release updates the SDK to use Swift 4.

## Version 0.17.0
_2017-09-14_

This release includes the following changes:

- Update Conversation to support 2017-05-26 release
- Update Speech to Text to support 2017-07-14 release
- Fix a bug to enable building with Xcode 9
- Other minor bug fixes and documentation updates

Please note that the `continuous` recognition setting was removed in the 2017-05-22 release of the Watson Speech to Text service. For advice on stopping the microphone, please see [this section](https://github.com/watson-developer-cloud/swift-sdk#microphone-audio-and-compression) of the readme.

## Version 0.15.1
_2017-05-1_

This release includes support for the following Conversation endpoints:
- Examples
- Counterexamples
- Workspaces
- Intents

## Version 0.15.0
_2017-04-5_

This release provides support for Xcode 8.3 and Swift 3.1.

## Version 0.14.2
_2017-03-8_

Updating small Discovery service bug that prevented reading credentials.

## Version 0.14.1
_2017-03-2_

This update includes:

- Updates for Natural Language Understanding service.
- Bug fixes for memory leak in text to speech. 

## Version 0.14.0
_2017-02-10_

This update includes:

- Support for Natural Language Understanding service.
- Fixes for error handling when parsing credential errors.

## Version 0.13.2
_2017-01-25_

This update fixes build errors for Linux compatibility by:

- Removing CVarArg
- Editing the glossary reading error.

## Version 0.13.1
_2017-01-19_

This update fixes Carthage Build and update to Xcode 8.2, Swift 3.0.2


## Version 0.13.0

_2017-01-18_

This update adds the following features and support:

- Customize Speech to Text.
- Add and edit metadata to photos within Visual Recognition.
- Basic Linux support for Conversation, Language Translator, Natural Language Classifier, Personality Insights V3, Tone Analyzer, and Tradeoff Analytics.

Please note this release includes renaming the iOS SDK to Swift SDK.

## Version 0.12.0

_2016-12-22_

This release adds support for the Discovery service.

## Version 0.11.0

_2016-12-06_

This update adds support for the Visual Recognition service's similarity search. It also updates sample applications for Swift 3.0 and adds several bug fixes:

- Visual Recognition: Enable uploading and classifying .PNG images.
- Speech to Text: Allow audio playback when AVAudioSession is activated.

## Version 0.10.0

_2016-11-23_

This update add support for Personality Insights V3 and several minor bug fixes:

- RestKit: Add a guard statement to avoid Any? to Any coercion.
- Speech to Text: Avoid sending data when payload is empty.
- Visual Recognition: Make age max and min properties optional.
- Visual Recognition: Updated error handling to recognize more service errors.

## Version 0.9.1

_2016-11-11_

This update adds support for the Speech to Text service's smart formatting parameter in Swift 3. It also fixes some broken links in the documentation.

## Version 0.8.2

_2016-11-11_

This update adds support for the Speech to Text service's smart formatting parameter in Swift 2.3.

## Version 0.7.3

_2016-11-11_

This update adds support for the Speech to Text service's smart formatting parameter in Swift 2.2.

## Version 0.9.0

_2016-11-07_

This release migrates the SDK to Swift 3.0 and removes external dependencies.

## Version 0.8.1

_2016-10-12_

This release updates the Swift 2.3 version of the iOS SDK with several bug fixes and minor changes.

- All Services: Default HTTP headers can now be set for each service.

- All Services: The service URL parameter was moved from each `init` to a class property. To set a custom service URL parameter, set the class property instead of passing it as a parameter to the initializer. (For example: `textToSpeech.serviceURL = "..."`.)

- Credentials: Testing credentials were moved to a .swift file for convenience.

- Language Translator: Update the default service URL for the recent release of the Language Translator service. To use an existing Language Translation service, specify a custom service URL.

- Natural Language Classifier: Updates the trained classifier id used for testing.

- Speech to Text: Add support for setting customization_id parameter.

- Speech to Text: Added support for additional audio formats (`AudioMediaType.MuLaw` and `AudioMediaType.Basic`)

- Speech to Text: Added support for the `supported_features` parameter of language models, which identifies whether certain additional service features are supported with any given model.

- Speech to Text: Fix a bug where the microphone would continue recording when disconnected by the service (which also prevented the service from operating correctly when reconnecting).

- Text to Speech: Validate the status code in the response to `synthesize()`. This helps to produce more meaningful error messages when using incorrect credentials with the service.

- Visual Recognition: Any errors writing the JSON parameters file are now passed back to the user.

## Version 0.8.0

_2016-09-14_

This update adds support for Xcode 8 and Swift 2.3+.

## Version 0.7.2

_2016-10-12_

This release updates the Swift 2.2 version of the iOS SDK with several bug fixes and minor changes.

- All Services: Default HTTP headers can now be set for each service.
- Speech to Text: Add support for setting customization_id parameter.
- Visual Recognition: Any errors writing the JSON parameters file are now passed back to the user.

## Version 0.7.1

_2016-09-30_

The release updates the Swift 2.2 version of the iOS SDK with several bug fixes and minor changes.

- All Services: The service URL parameter was moved from each `init` to a class property. To set a custom service URL parameter, set the class property instead of passing it as a parameter to the initializer. (For example: `textToSpeech.serviceURL = "..."`.)

- Cartfile: The `Cartfile` was updated to explicitly specify Swift 2.2 compatible versions of the SDK's dependencies.

- Credentials: Testing credentials were moved to a .swift file for convenience.

- Language Translator: Update the default service URL for the recent release of the Language Translator service. To use an existing Language Translation service, specify a custom service URL.

- Natural Language Classifier: Updates the trained classifier id used for testing.

- Speech to Text: Added support for additional audio formats (`AudioMediaType.MuLaw` and `AudioMediaType.Basic`)

- Speech to Text: Added support for the `supported_features` parameter of language models, which identifies whether certain additional service features are supported with any given model.

- Speech to Text: Fix a bug where the microphone would continue recording when disconnected by the service (which also prevented the service from operating correctly when reconnecting).

- Text to Speech: Validate the status code in the response to `synthesize()`. This helps to produce more meaningful error messages when using incorrect credentials with the service.

## Version 0.7.0

_2016-09-11_

This update adds a new implementation for Speech to Text. The implementation includes a better, redesigned API. It also includes two separate classes, SpeechToText and SpeechToTextSession for simple and advanced usage, respectively. In particular, SpeechToTextSession exposes more control over the WebSockets session and microphone, including access to raw data and the decibel power level.

## Version 0.6.0

_2016-08-11_

This update adds the Retrieve and Rank service. It also adds re-training functionality to Visual Recognition and includes several minor documentation updates.

## Version 0.5.0

_2016-07-26_

This update adds the ConversationV1 service, along with the following minor updates:

- All Services: Add support for iOS 8+
- All Services: Update tests to improve consistency
- Travis: Update CI to build and test with both iOS 8 and iOS 9
- Alchemy Language: Change `forUrl` parameter to `forURL`
- Alchemy Vision: Deprecated in favor of Visual Recognition
- Relationship Extraction: Deprecated in favor of Alchemy Language
- Text To Speech: Add test for empty string
- Tone Analyzer: Update to the general availability URL

Note that the Alchemy Vision and Relationship Extraction services remain in the SDK. You can continue to use these services in your applications, but they will result in a deprecation build warning.

## Version 0.4.2

_2016-07-02_

This update fixes issue #363 by modifying the RelationshipExtractionV1Beta scheme to avoid building/profiling/archiving/analyzing the RelationshipExtractionV1BetaTests target.

## Version 0.4.1

_2016-06-30_

This is a minor update to add documentation.

## Version 0.4.0

_2016-06-27_

This is a major update for the Watson Developer Cloud iOS SDK, with 5 main additions:

- AlchemyData News service
- Conversation (Experimental) service
- Document Conversion service
- Relationship Extraction service
- Text to Speech customization endpoints
- Tradeoff Analytics service

This release also includes a number of minor changes and bug fixes:

- All Services: Add `serviceURL` as an argument to initializer.
- All Services: Add custom HTTP user agent header.
- Alchemy Language: Transition to RestKit architecture.
- Alchemy Vision: Use `NSData` instead of `NSURL` for image parameters.
- Alchemy Vision: Fix bug with celebrity identity.
- Alchemy Vision: Fix bug with HTML endpoints.
- Alchemy Vision: Improve error handling.
- Alchemy Vision: Improve tests.
- Dialog: Add missing documentation.
- Language Translation: Add missing documentation.
- Language Translation: Rename to Language Translator.
- Natural Language Classifier: Add missing documentation.
- Speech to Text: Add missing documentation.
- Text to Speech: Change `AudioFormat.OGG` case to `AudioFormat.Opus`
- Text to Speech: Add missing documentation.
- Tone Analyzer: Improve tests.
- Readme: Fix bugs.
- Quickstart Guide: Fix bugs.
- Swift Package Manager: Add `Package.swift` file.
- Carthage: Remove ObjectMapper dependency.
- Carthage: Update `Cartfile.resolved`

## Version 0.3.0

_2016-05-21_

The iOS-sdk version 0.3.0 has many major changes with this new release.  The team worked diligently at removing many of the third party dependencies and fully embracing AlamoFire by implementing the rest-kit code.  

**Major updates**

* Added IBM Watson Tone Analyzer
* Added IBM Watson Visual Recognition 
* Updated all of the code to use the new Rest-kit and removed NetworkUtils and WatsonGateway.  We still have one service to convert, Alchemy Language, but we anticipate that change coming in the next minor release.
* Removed many dependencies and reducing the total number to three.  Alamofire, Freddy, and Starscream.
* You will notice an update to the targets available and now the developer can pick and choose the services to include.

The process of migrating a service to Rest-kit required a large re-implementation of the service. As part of the reimplementation, we additionally gain:

* More consistent coding patterns between services.
* Better documentation.
* Better tests.
* Reorganized project structure to support Swift Package Manager.

In addition, the Rest-kit branch has a number of architectural changes that should make the SDK easier to maintain and easier to consume.  

* Uses Alamofire directly instead of NetworkUtils or WatsonGateway.
* Uses Freddy instead of ObjectMapper, allowing us to better express the models.
* Uses separate failure and success closures to avoid unwrapping optionals and enable consistent error handling.  We debated as a team as to the correct approach and concluded this was the best approach for the granularity.  One benefit is the user does not have to unwrap a response.  It also allows for a more unified error return.
