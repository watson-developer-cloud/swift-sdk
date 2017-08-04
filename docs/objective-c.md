# Watson Developer Cloud Swift SDK: Objective-C Compatability

The Watson Developer Cloud Swift SDK strives to write "Swifty" code that follows the community's conventions and best practices. Unfortunately, that means our framework does not automatically bridge to Objective-C. We recommend writing a custom bridge in Swift to consume the Swift SDK in an Objective-C application. The following tutorial describes how to build a Swift bridge to consume the Watson Developer Cloud Swift SDK in an Objective-C application.

## Create Application and Load Dependencies

Create an Objective-C application.

<img width="1410" alt="screen shot 2016-09-10 at 11 51 19 pm" src="https://cloud.githubusercontent.com/assets/1957636/18415277/06699246-77b2-11e6-880e-9b533bed5b7f.png">

We recommend using the Carthage dependency manager to build the SDK and keep it up-to-date. To use Carthage, create a file called `Cartfile` in the root directory of your project with the contents `github "watson-developer-cloud/swift-sdk"` and run `carthage update --platform iOS`.

```bash
$ echo "github \"watson-developer-cloud/swift-sdk\"" > Cartfile
$ carthage update --platform iOS
```

<img width="1146" alt="screen shot 2016-09-10 at 11 54 36 pm" src="https://cloud.githubusercontent.com/assets/1957636/18415279/1fff458e-77b2-11e6-99c2-755b2b62b2ef.png">

Add the frameworks you'd like to use to the project, including their dependencies. (All frameworks depend upon Alamofire, Freddy, and RestKit. SpeechToText additionally depends upon Starscream.)

<img width="260" alt="screen shot 2016-09-11 at 12 21 16 am" src="https://cloud.githubusercontent.com/assets/1957636/18415380/b3500e88-77b5-11e6-8054-8e7dca31be3e.png">

Add a "Copy Frameworks" build phase with the frameworks and dependencies you'd like to use. We'll use Text to Speech as an example for this tutorial.

<img width="1406" alt="screen shot 2016-09-11 at 12 11 49 am" src="https://cloud.githubusercontent.com/assets/1957636/18415353/605425f8-77b4-11e6-8221-d932cc7247cc.png">

<img width="705" alt="screen shot 2016-09-11 at 12 12 17 am" src="https://cloud.githubusercontent.com/assets/1957636/18415354/6ec2fea2-77b4-11e6-9d43-b13a9315a63e.png">

<img width="692" alt="screen shot 2016-09-11 at 12 13 04 am" src="https://cloud.githubusercontent.com/assets/1957636/18415356/882803c4-77b4-11e6-912c-0a4d9745340c.png">

## Bridge Objective-C to Swift

Create a `WatsonBridge.swift` file. When prompted, allow Xcode to build an Objective-C bridging header.

<img width="742" alt="screen shot 2016-09-11 at 12 05 26 am" src="https://cloud.githubusercontent.com/assets/1957636/18415325/7a4355ac-77b3-11e6-9e3b-a4365f906eea.png">

Import the Swift SDK framework(s) you'd like to use in `WatsonBridge.swift`.

<img width="697" alt="screen shot 2016-09-11 at 12 13 51 am" src="https://cloud.githubusercontent.com/assets/1957636/18415358/a5693d04-77b4-11e6-859e-ff067388bd19.png">

We're going to write a class in `WatsonBridge.swift` that can automatically bridge to Objective-C. This class will contain methods that invoke the SDK, process the results, and return any desired values to an Objective-C caller. This class can invoke the SDK because it is written in Swift.

Create a class in `WatsonBridge.swift` that inherits from `NSObject` (this makes it accessible from Objective-C callers) and write any desired methods.

<img width="707" alt="screen shot 2016-09-11 at 12 17 13 am" src="https://cloud.githubusercontent.com/assets/1957636/18415368/2231e4a8-77b5-11e6-873c-7524f05a4c5e.png">

Import the generated Swift header in your Objective-C file. Since this tutorial app is called `ObjectiveCTest`, we import `ObjectiveCTest-swift.h`. This header provides access to the classes and methods in `WatsonBridge.swift`. Now we can execute methods from `WatsonBridge.swift` in our Objective-C code.

<img width="540" alt="screen shot 2016-09-11 at 12 27 43 am" src="https://cloud.githubusercontent.com/assets/1957636/18415411/ebe5762e-77b6-11e6-9017-f0a50fd61ff2.png">
