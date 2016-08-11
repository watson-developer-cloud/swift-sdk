Change Log
==========

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
