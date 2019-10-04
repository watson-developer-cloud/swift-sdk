
## 3.0.0 (Preview) (https://github.com/watson-developer-cloud/swift-sdk/compare/2.3.0...3.0.0) (2019-10-04)

### Breaking Changes

* Authentication: new authentication scheme for all Watson services implemented 

#### AssistantV1

`Assistant.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?`
* `listExamples()` no longer accepts the `includeCount` parameter
* `listCounterexamples()` no longer accepts the `includeCount` parameter
* `listEntities()` no longer accepts the `includeCount` parameter
* `listValues()` no longer accepts the `includeCount` parameter
* `listSynonyms()` no longer accepts the `includeCount` parameter
* `updateValue()` parameter `newValueType` renamed to `newType`
* `createDialogNode()` parameter `nodeType` renamed to `type`
* `updateDialogNode()` parameter `newNodeType` renamed to `newType`

#### AssistantV1 Models

`CreateValue.swift`
* `ValueType` enum renamed to `TypeEnum`
* `valueType` string named to `type`

`DialogNode.swift`
* `NodeType` enum renamed to `TypeEnum`
* `nodeType` string renamed to `type`

`DialogNodeAction.swift`
* `ActionType` enum renamed to `TypeEnum`
* `actionType` string renamed to `type`

`DialogNodeOutputGeneric.swift`
* `searchSkill` case added to `ResponseType` enum
* `QueryType` enum added
* `query` string added
* `queryType` string added
* `filter` string added
* `discoveryVersion` string added

`DialogSuggestion.swift`
* `output` type changed from `[String: JSON]?` to `DialogSuggestionOutput?`

`DialogSuggestionOutput.swift`
* New model added

`DialogSuggestionResponseGeneric.swift`
* New model added

`LogMessage.swift`
* `additionalProperties` removed

`RuntimeEntity.swift`
* `additionalProperties` removed

`RuntimeIntent.swift`
* `additionalProperties` removed

`DialogRuntimeResponseGeneric.swift`
* File and model renamed to `RuntimeResponseGeneric`

`UpdateDialogNode.swift`
* `NodeType` enum renamed to `TypeEnum`
* `nodeType` string renamed to `type`

`UpdateValue.swift`
* `ValueType` enum renamed to `TypeEnum`
* `valueType` string renamed to `type`

`Value.swift`
* `ValueType` enum renamed to `TypeEnum`
* `valueType` string renamed to `type`

#### AssistantV2

`Assistant.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?` 

#### AssistantV2 Models

`DialogNodeAction.swift`
* `ActionType` enum renamed to `TypeEnum`
* `actionType` string renamed to `type`

`MessageOutput.swift`
* `generic` type changed from `[DialogRuntimeResponseGeneric]?` to `[RuntimeResponseGeneric]?`

`MessageRequestContext.swift`
* Model removed

`MessageResponseContext.swift`
* Model removed

`DialogRuntimeResponseGeneric.swift`
* Model and file renamed to `RuntimeResponseGeneric`

#### CompareComplyV1

`CompareComply.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?` 

#### CompareComplyV1 Models

`ColumnHeaderTextsNormalized.swift`
* Model removed

`RowHeaderTexts.swift`
* Model removed

`RowHeaderTextsNormalized.swift`
* Model removed

#### DiscoveryV1

`Discovery.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?`
* `testConfigurationInEnvironment()` method removed
* `query()` renamed parameter `returnFields` to `return`
* `query()` renamed parameter `loggingOptOut` to `xWatsonLoggingOptOut`
* `query()` removed parameter `collectionIDs`
* `query()` added `spellingSuggestions` parameter
* `queryNotices()` renamed parameter `returnFields` to `return`
* `federatedQuery()` renamed parameter `returnFields` to `return`
* `getAutocompletion()` method added (CloudPakForData only)
* `queryRelations()` method removed

#### DiscoveryV1 Models

`CollQueryLarge.swift`
* Model added

`Completions.swift`
* Model added (CloudPakForData only)

`DocumentSnapshot.swift`
* Model removed

`Enrichment.swift`
* `enrichmentName` string renamed to `enrichment`

`FedQueryLarge.swift`
* Model added

`Field.swift`
* `FieldType` enum renamed to `TypeEnum`
* `fieldName` string renamed to `field`

`QueryEntities.swift`
* Model removed

`QueryEntitiesContext.swift`
* Model removed

`QueryEntitiesEntity.swift`
* Model removed

`QueryEntitiesResponse.swift`
* Model removed

`QueryEvidence.swift`
* Model removed

`QueryFilterType.swift`
* Model removed

`QueryLarge.swift`
* `returnFields` string renamed to `return`

`QueryRelations.swift`
* Model removed

`QueryRelationsEntity.swift`
* Model removed

`QueryRelationsFilter.swift`
* Model removed

`QueryRelationsRelationship.swift`
* Model removed

`QueryResponse.swift`
* `suggestedQuery` string added

`TestDocument.swift`
* Model removed

#### LanguageTranslatorV3

`LanguageTranslator.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?`
* `listModels()` parameter `defaultModels` renamed to `default`

#### LanguageTranslatorV3 Models

`Translation.swift`
* `translationOutput` string renamed to `translation`

#### NaturalLanguageClassifierV1

`NaturalLanguageClassifier.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?`
* `createClassifier()` parameter `metadata` renamed to `trainingMetadata`

#### NaturalLanguageClassifierV1 Models

`AnalysisResultsSentiment.swift`
* Model removed

`DocumentEmotionResultsEmotion.swift`
* Model removed

`EntitiesResultEmotion.swift`
* Model removed

`EntitiesResultSentiment.swift`
* Model removed

`KeywordsResultEmotion.swift`
* Model removed

`KeywordsResultSentiment.swift`
* Model removed

`MetadataResult.swift`
* Model removed

`ParametersFeatures.swift`
* Model removed

`SemanticRolesAction.swift`
* Model removed

`SemanticRolesSubject.swift`
* Model removed

`SntaxOptions.swift`
* `init()` method added

`TargetedEmotionResultsEmotion.swift`
* Model removed

#### NaturalLanguageUnderstandingV1

`NaturalLanguageUnderstanding.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?`

#### PersonalityInsightsV3

`PersonalityInsights.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?`

#### SpeechToTextV1

`SpeechToText.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?`
* `recognize()` parameter `contentType` added
* `createJob()` parameter `contentType` added
* `addAudio()` parameter `contentType` added

`SpeechToTextSession.swift` (WebSockets)
* `init` now accepts an `Authenticator` instead of raw credentials
* removed all `init` methods that accepted credentials

`SpeechToTextSocket.swift` (WebSockets)
* `init` now accepts an `Authenticator` instead of raw credentials

#### SpeechToTextV1 Models

`AudioListingContainer.swift`
* Model removed

`AudioListingDetails.swift`
* Model removed

`AudioResourceDetails.swift`
* Model removed

`CreateAcousticModel.swift`
* New model IDs added

`CreateLanguageModel.swift`
* New model IDs added

`SpeakerLabelsResult.swift`
* `finalResults` bool renamed to `final`

`SpeechRecognitionResult.swift`
* `finalResults` bool renamed to `final`

#### TextToSpeechV1

`TextToSpeech.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?`
* `synthesize()` parameter `accept` added

#### TextToSpeechV1 Models

`VoiceCustomization.swift`
* Model removed

#### ToneAnalyzerV3

`ToneAnalyzer.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?`


#### VisualRecognitionV3

`VisualRecognition.swift`
* `init` now accepts an `Authenticator` instead of raw credentials
* Linux environment `init` is now a throwable `init` instead of an `init?`
* `detectFaces()` removed

`VisualRecognition+CoreML.swift`
* `init` now accepts an `Authenticator` instead of raw credentials

`VisualRecognition+UIImage.swift`
* `detectFaces()` removed

#### VisualRecognitionV3 Models

`Class.swift`
* `className` string renamed to `class`

`ClassResult.swift`
* `className` String renamed to `class`

`FaceGender.swift`
* Model removed

`DetectedFaces.swift`
* Model removed

#### VisualRecognitionV4

VisualRecognitionV4 added :tada:

`

### Breaking Changes

* Authentication: new authentication scheme for all Watson services implemented
* All services: breaking changes to model property names for service responses

## 2.3.0 (https://github.com/watson-developer-cloud/swift-sdk/compare/2.2.0...2.3.0) (2019-08-23)

### Features

* CompareComplyV1: Add new contract entities

### Bug Fixes

* CompareComplyV1: Fix inconsistencies with Swift models and the API response

## 2.2.0 (https://github.com/watson-developer-cloud/swift-sdk/compare/2.1.1...2.2.0) (2019-07-31)

### Features

* AssistantV1: add models for Assistant Search Skill

## 2.1.1 (https://github.com/watson-developer-cloud/swift-sdk/compare/2.1.0...2.1.1) (2019-06-28)

### Bug Fixes

* SpeechToTextV1: Add configureSession parameter to RecognizeMicrophone. (87f5aed (https://github.com/watson-developer-cloud/swift-sdk/commit/87f5aed))

# 2.1.0 (https://github.com/watson-developer-cloud/swift-sdk/compare/2.0.3...2.1.0) (2019-06-08)

### Features

* Add support for insecure connections (975bb68 (https://github.com/watson-developer-cloud/swift-sdk/commit/975bb68))
* Assistant V1 updated DialogNodeOutputOptionsElementValue PR
* LTv3 Document Translator API
* NLU categories explanations
* STT processing metrics and audio metrics features

### Bug Fixes

* Remove support for insecure connections for Linux (76f15f2 (https://github.com/watson-developer-cloud/swift-sdk/commit/76f15f2))

## 2.0.3 (https://github.com/watson-developer-cloud/swift-sdk/compare/2.0.3...2.0.3) (2019-04-15)

### Bug Fixes

* **All:**
  * Use bootstrap instead of update in carthage
  * Use full url in semantic release
  * Refactor bluemix to cloud.ibm
  * Add Featured Projects section to README

## 2.0.2 (https://github.com/watson-developer-cloud/swift-sdk/compare/2.0.1...2.0.2) (2019-04-15)

### Bug Fixes

* core: Look for iam_apikey in credential file with IAM auth (689d748 (https://github.com/watson-developer-cloud/swift-sdk/commit/689d748))
* Fix swiftlint errors (9b12dba (https://github.com/watson-developer-cloud/swift-sdk/commit/9b12dba))

# [2.0.1](https://github.com/watson-developer-cloud/swift-sdk/compare/2.0.0...2.0.1) (2019-04-07)


### Bug Fixes
* **VisualRecognitionV3:**
  * Add .zip to filenames passed to create/update classifier
  * Fix multiple calls to completionHandler from classifyWithLocalModel.


# [2.0.0](https://github.com/watson-developer-cloud/swift-sdk/compare/1.4.0...2.0.0) (2019-03-28)


### Features

* **All:**
  * Version moved to first parameter of init methods for basic authentication
  * Credentials file support in the intializer dropped for iOS. Only supported in Linux
  * Error response handling reworked for consistency across services and languages
  * Ordering of parameters in some methods has changed due to migration of the API docs and generator to OpenAPI 3.0
  * File-type parameters are now defined as `Data` rather than `URL`
* **AssistantV1:**
  * Some model classes have been merged / simplified
  * The `InputData` class has been renamed to `MessageInput`
* **SpeechToTextV1:**
  * The `recognizeWithWebsockets` method has been revised to accept a `RecognizeCallback` object with `onResults` and `onError` callback properties


# [1.4.0](https://github.com/watson-developer-cloud/swift-sdk/compare/1.3.1...1.4.0) (2019-02-12)


### Bug Fixes

* **AssistantV1:** Remove erroneous `additionalProperties` from MessageResponse ([60f1616](https://github.com/watson-developer-cloud/swift-sdk/commit/60f1616))
* **CompareComplyV1:** BodyCells had incorrect types for some of its properties ([13c66af](https://github.com/watson-developer-cloud/swift-sdk/commit/13c66af))


### Features

* **All:** New initializer that loads credentials from file ([39ddae3](https://github.com/watson-developer-cloud/swift-sdk/commit/39ddae3))
* **AssistantV1:** Add `additionalProperties` property to InputData ([1e14888](https://github.com/watson-developer-cloud/swift-sdk/commit/1e14888))
* **CompareComplyV1:** Add `address` as a possible Attribute ([b34a782](https://github.com/watson-developer-cloud/swift-sdk/commit/b34a782))
* **CompareComplyV1:** Add `attributes` property to BodyCells ([3302504](https://github.com/watson-developer-cloud/swift-sdk/commit/3302504))
* **CompareComplyV1:** Add `importance` to Parties ([96eb790](https://github.com/watson-developer-cloud/swift-sdk/commit/96eb790))
* **CompareComplyV1:** Add confidence level for the identification of the contract amount ([35a773a](https://github.com/watson-developer-cloud/swift-sdk/commit/35a773a))
* **DiscoveryV1:** Add method to get the stopword list status ([4a6b615](https://github.com/watson-developer-cloud/swift-sdk/commit/4a6b615))
* **DiscoveryV1:** Add the `pending` status for Documents ([f342c68](https://github.com/watson-developer-cloud/swift-sdk/commit/f342c68))
* **SpeechToTextV1:** Add new parameter `force` to upgradeAcousticModel() method ([eecf18b](https://github.com/watson-developer-cloud/swift-sdk/commit/eecf18b))

## [1.3.1](https://github.com/watson-developer-cloud/swift-sdk/compare/1.3.0...1.3.1) (2019-01-18)


### Bug Fixes

* **SpeechToTextV1:** Fix grammarName and redaction parameters in recognize websocket methods ([64b116c](https://github.com/watson-developer-cloud/swift-sdk/commit/64b116c))

# [1.3.0](https://github.com/watson-developer-cloud/swift-sdk/compare/1.2.0...1.3.0) (2019-01-18)


### Bug Fixes

* **SpeechToTextV1:** Change contentType parameter to optional in certain methods ([e033cff](https://github.com/watson-developer-cloud/swift-sdk/commit/e033cff))


### Features

* **DiscoveryV1:** Add support for custom stopword lists ([915ce68](https://github.com/watson-developer-cloud/swift-sdk/commit/915ce68))
* **DiscoveryV1:** Add support for gateways ([39393fa](https://github.com/watson-developer-cloud/swift-sdk/commit/39393fa))
* **DiscoveryV1:** Add web crawlers to the list of possible sources ([5a4a62e](https://github.com/watson-developer-cloud/swift-sdk/commit/5a4a62e))
* **SpeechToTextV1:** Add new options to acoustic models and language models ([3345b46](https://github.com/watson-developer-cloud/swift-sdk/commit/3345b46))
* **SpeechToTextV1:** Add the ability to specify grammars in recognition requests ([7edcdf4](https://github.com/watson-developer-cloud/swift-sdk/commit/7edcdf4))
* **VisualRecognitionV3:** Add acceptLanguage parameter to detectFaces() ([a260a9c](https://github.com/watson-developer-cloud/swift-sdk/commit/a260a9c))
* **VisualRecognitionV3:** Add genderLabel property to FaceGender model ([a00f3c6](https://github.com/watson-developer-cloud/swift-sdk/commit/a00f3c6))

# [1.2.0](https://github.com/watson-developer-cloud/swift-sdk/compare/1.1.1...1.2.0) (2019-01-11)


### Bug Fixes

* **CompareComplyV1:** Change Location properties to optional ([2e66ac5](https://github.com/watson-developer-cloud/swift-sdk/commit/2e66ac5))
* **CompareComplyV1:** Fix incorrect parameter types ([4cfa292](https://github.com/watson-developer-cloud/swift-sdk/commit/4cfa292))
* **CompareComplyV1:** Give more appropriate types to model properties ([4b1af08](https://github.com/watson-developer-cloud/swift-sdk/commit/4b1af08))


### Features

* **CompareComplyV1:** Add properties to AlignedElements and Attribute ([0fbeb6d](https://github.com/watson-developer-cloud/swift-sdk/commit/0fbeb6d))
* **CompareComplyV1:** New framework for Compare & Comply service ([482444a](https://github.com/watson-developer-cloud/swift-sdk/commit/482444a))

# [1.1.1](https://github.com/watson-developer-cloud/swift-sdk/compare/1.1.0...1.1.1) (2019-01-10)


### Bug Fixes

* **AssistantV1:** Add missing "disabled" field to DialogNode ([e45de83](https://github.com/watson-developer-cloud/swift-sdk/commit/e45de83))
* **AssistantV2:** Add missing userDefined field to MessageOutput ([f65cafc](https://github.com/watson-developer-cloud/swift-sdk/commit/f65cafc))

# [1.1.0](https://github.com/watson-developer-cloud/swift-sdk/compare/1.0.0...1.1.0) (2018-12-11)


### Features

* **AssistantV1:** Add metadata field to Context model ([13a90c1](https://github.com/watson-developer-cloud/swift-sdk/commit/13a90c1))
* **AssistantV1:** Add option to sort results in getWorkspace() ([5cefc7b](https://github.com/watson-developer-cloud/swift-sdk/commit/5cefc7b))
* **DiscoveryV1:** Add new concepts property to NluEnrichmentFeatures model ([80258db](https://github.com/watson-developer-cloud/swift-sdk/commit/80258db))
* **DiscoveryV1:** Add retrievalDetails property to QueryResponse model ([631affc](https://github.com/watson-developer-cloud/swift-sdk/commit/631affc))
* **NaturalLanguageUnderstandingV1:** Add 4 new properties to the Model model ([53fe057](https://github.com/watson-developer-cloud/swift-sdk/commit/53fe057))
* **NaturalLanguageUnderstandingV1:** Add new count property to KeywordsResult model ([ab9a339](https://github.com/watson-developer-cloud/swift-sdk/commit/ab9a339))
* **NaturalLanguageUnderstandingV1:** Add new limit property to CategoriesOptions model ([5bf6637](https://github.com/watson-developer-cloud/swift-sdk/commit/5bf6637))

# [1.0.0](https://github.com/watson-developer-cloud/swift-sdk/compare/0.38.1...1.0.0) (2018-12-06)


### All Services
- `failure` and `success` callbacks are replaced with a single `completionHandler` of type `(WatsonResponse<T>?, WatsonError?) -> Void`
- New `WatsonResponse` type in the completion handlers that contains the response HTTP status, headers, and data
- New `WatsonError` type in the completion handlers that contains more useful and detailed information about the error that occurred
- Change the type of date-time properties from `String` to `Date`
- Remove all deprecated types, methods, and properties
- All parameters now get passed directly to methods rather than packaging them up in the `properties` parameter
- All models are now `Codable`, instead of only being `Encodable` or `Decodable`, so they can be converted both to and from JSON
- All models are now `Equatable`


### ConversationV1
- REMOVED - use AssistantV1 instead


### LanguageTranslatorV2
- REMOVED - use LanguageTranslatorV3 instead


### NaturalLanguageUnderstandingV1
- Remove `additionalProperties` property from `CategoriesOptions` and `MetadataOptions`


### SpeechToTextV1
- The `tokenURL` and `websocketsURL` properties are no longer public. Setting the `serviceURL` will automatically update the other two URLs appropriately.
- Add missing parameters `baseModelVersion`, `languageCustomizationID`, and `customerID` to the following methods:
    - `recognize()` (using an audio file)
    - `recognizeUsingWebsocket()`
    - `recognizeMicrophone()`
    - `SpeechToTextSession()` initializers


### VisualRecognitionV3
- Remove `PositiveExample` model. All parameters that used that model are now of type `[String: URL]`
- Change the following properties from optional to nonoptional
    - `ClassResult.score`
    - `DetectedFaces.imagesProcessed`
    - `FaceAge.score`
    - `FaceGender.score`


## [0.38.1](https://github.com/watson-developer-cloud/swift-sdk/compare/0.38.0...0.38.1) (2018-11-13)


### Bug Fixes

* **SpeechToTextV1:** Update recognizeMicrophone() to work with any authentication method ([5701ba6](https://github.com/watson-developer-cloud/swift-sdk/commit/5701ba6))

# [0.38.0](https://github.com/watson-developer-cloud/swift-sdk/compare/0.37.0...0.38.0) (2018-11-12)


### Bug Fixes

* **VisualRecognitionV3:** temporary workaround for new A12 based devices ([62edd09](https://github.com/watson-developer-cloud/swift-sdk/commit/62edd09))
* **VisualRecognitionV3:** temporary workaround to support A12 devices for Core ML inference ([fa212ec](https://github.com/watson-developer-cloud/swift-sdk/commit/fa212ec))


### Features

* **All:** Add support for Swift 4.2 ([4bbf42b](https://github.com/watson-developer-cloud/swift-sdk/commit/4bbf42b))

# [0.37.0](https://github.com/watson-developer-cloud/swift-sdk/compare/0.36.0...0.37.0) (2018-11-02)


### Features

* **AssistantV1, AssistantV2:** Add cloudFunction and webAction to DialogNodeAction.ActionType ([16d3fc9](https://github.com/watson-developer-cloud/swift-sdk/commit/16d3fc9))
* **DiscoveryV1:** Tokenization dictionaries for collections ([d274371](https://github.com/watson-developer-cloud/swift-sdk/commit/d274371))
* **SpeechToTextV1:** Add languageCustomizationID parameter to createJob() and recognize() ([0137964](https://github.com/watson-developer-cloud/swift-sdk/commit/0137964))

# [0.36.0](https://github.com/watson-developer-cloud/swift-sdk/compare/0.35.0...0.36.0) (2018-10-19)


### Bug Fixes

* **Visual Recognition:** Fix deserialization error in getCoreMlModel ([9392b23](https://github.com/watson-developer-cloud/swift-sdk/commit/9392b23))
* Conversion of file data to multipart form data ([1d46baf](https://github.com/watson-developer-cloud/swift-sdk/commit/1d46baf))


### Features

* **Discovery:** Add "LT" option to environment sizes ([f92fcde](https://github.com/watson-developer-cloud/swift-sdk/commit/f92fcde))
* **Discovery:** Add `size` parameter to updateEnvironment method ([725e1d5](https://github.com/watson-developer-cloud/swift-sdk/commit/725e1d5))
* **Discovery:** Add bias and loggingOptOut parameters to query methods ([8782fc6](https://github.com/watson-developer-cloud/swift-sdk/commit/8782fc6))
* **Discovery:** Add requestedSize and searchStatus properties to Environment model ([14cdb02](https://github.com/watson-developer-cloud/swift-sdk/commit/14cdb02))
* **ToneAnalyzer:** Add `ToneID` options to `ToneChatScore` ([ac75c92](https://github.com/watson-developer-cloud/swift-sdk/commit/ac75c92))


### Reverts

* **AssistantV1:** Revert erroneous addition of `actions` property to `OutputData` ([28efe1e](https://github.com/watson-developer-cloud/swift-sdk/commit/28efe1e))
* **Linux:** Remove 30 minute wait from Linux tests ([1b4d734](https://github.com/watson-developer-cloud/swift-sdk/commit/1b4d734))

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
