Watson iOS SDK
===================

This SDK makes it easy to use IBM's [Watson API](https://watson-api-explorer.mybluemix.net/) in your iOS projects.

[![Build Status](https://magnum.travis-ci.com/IBM-MIL/Watson-iOS-SDK.svg?token=YPHGLjpSd2i3xBsMhsyL&branch=master)](https://magnum.travis-ci.com/IBM-MIL/Watson-iOS-SDK)

[![codecov.io](http://codecov.io/github/IBM-MIL/Watson-iOS-SDK/coverage.svg?branch=develop)](https://codecov.io/github/IBM-MIL/Watson-iOS-SDK?branch=develop)

https://codecov.io/github/IBM-MIL/Watson-iOS-SDK

Implemented services:

* Speech to Text
* Language Translation
* Text to Speech


Developer Setup
---------------
**Stub text, insert text here when ready.**

* Ensure you have the latest version of [XCode](https://developer.apple.com/xcode/) installed.
* We encourage you to use [Cocoa Pods](http://cocoapods.org/) to import the SDK into your project. Cocoa Pods is a simple, but powerful dependency management tool. If you do not already use Cocoa Pods, it's very easy to [get started](http://guides.cocoapods.org/using/getting-started.html).


Quickstart
----------
**Stub text, insert text here when ready.**

Step 1: Add to your Podfile
```
pod 'box-ios-sdk'
```
Step 2: Install
```
pod install
```
Step 3: Import
```objectivec
#import <BoxContentSDK/BOXContentSDK.h>
```
Step 4: Set the Box Client ID and Client Secret that you obtain from [creating your app](doc/Setup.md). 
```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // The UIApplicationDelegate is a good place to do this.
  [BOXContentClient setClientID:@"your-client-id" clientSecret:@"your-client-secret"];
}
```
Step 5: Authenticate a User
```objectivec
// This will present the necessary UI for a user to authenticate into Box
[[BOXContentClient defaultClient] authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
  if (error == nil) {
    NSLog(@"Logged in user: %@", user.login);
  }
} cancelBlock:nil];
```


Sample App
----------
**Stub text, insert text here when ready.**

A sample app can be found in the [BoxContentSDKSampleApp](../../tree/master/BoxContentSDKSampleApp) folder. The sample app demonstrates how to authenticate a user, and manage the user's files and folders.


Tests
-----
**Stub text, insert text here when ready.**

Tests can be found in the 'BoxContentSDKTests' target. [Use XCode to execute the tests](https://developer.apple.com/library/ios/recipes/xcode_help-test_navigator/RunningTests/RunningTests.html#//apple_ref/doc/uid/TP40013329-CH4-SW1). Travis CI will also execute tests for pull requests and pushes to the repository.


Documentation
-------------
**Stub text, insert text here when ready.**

You can find guides and tutorials in the `doc` directory.

* [App Setup](doc/Setup.md)
* [Authentication](doc/Authentication.md)
* [Developer's Edition (App Users)](doc/AppUsers.md)
* [Files](doc/Files.md)
* [Folders](doc/Folders.md)
* [Metadata](doc/metadata.md)
* [Comments](doc/Comments.md)
* [Collaborations](doc/Collaborations.md)
* [Events](doc/Events.md)
* [Search](doc/Search.md)
* [Users](doc/Users.md)


Contributing
------------
**Stub text, insert text here when ready.**

See [CONTRIBUTING](CONTRIBUTING.md) on how to help out.


Copyright and License
---------------------
Insert text here.
