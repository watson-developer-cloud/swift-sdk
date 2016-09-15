Here are the steps I followed:

Create Objective-C application.

<img width="1410" alt="screen shot 2016-09-10 at 11 51 19 pm" src="https://cloud.githubusercontent.com/assets/1957636/18415277/06699246-77b2-11e6-880e-9b533bed5b7f.png">

Create `Cartfile` and run `carthage update --platform iOS`

<img width="1146" alt="screen shot 2016-09-10 at 11 54 36 pm" src="https://cloud.githubusercontent.com/assets/1957636/18415279/1fff458e-77b2-11e6-99c2-755b2b62b2ef.png">

Add the frameworks you'd like to use and their dependencies to the project. Most of the frameworks depend upon Alamofire, Freddy, and RestKit. SpeechToText also depends upon Starscream.

<img width="260" alt="screen shot 2016-09-11 at 12 21 16 am" src="https://cloud.githubusercontent.com/assets/1957636/18415380/b3500e88-77b5-11e6-8054-8e7dca31be3e.png">

Add a "Copy Frameworks" build phase with the frameworks (and dependencies) you'd like to use. I'll use Text to Speech as an example.

<img width="1406" alt="screen shot 2016-09-11 at 12 11 49 am" src="https://cloud.githubusercontent.com/assets/1957636/18415353/605425f8-77b4-11e6-8221-d932cc7247cc.png">

<img width="705" alt="screen shot 2016-09-11 at 12 12 17 am" src="https://cloud.githubusercontent.com/assets/1957636/18415354/6ec2fea2-77b4-11e6-9d43-b13a9315a63e.png">

<img width="692" alt="screen shot 2016-09-11 at 12 13 04 am" src="https://cloud.githubusercontent.com/assets/1957636/18415356/882803c4-77b4-11e6-912c-0a4d9745340c.png">

Add an App Transport Security exception to `Info.plist`.

```
<key>NSAppTransportSecurity</key>
    <dict>
        <key>NSExceptionDomains</key>
        <dict>
            <key>watsonplatform.net</key>
            <dict>
                <key>NSTemporaryExceptionRequiresForwardSecrecy</key>
                <false/>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
                <true/>
                <key>NSTemporaryExceptionMinimumTLSVersion</key>
                <string>TLSv1.0</string>
            </dict>
        </dict>
    </dict>
```

<img width="456" alt="screen shot 2016-09-11 at 12 22 54 am" src="https://cloud.githubusercontent.com/assets/1957636/18415393/1b2c54c6-77b6-11e6-9821-c0a1ea633aa4.png">

<img width="892" alt="screen shot 2016-09-11 at 12 23 11 am" src="https://cloud.githubusercontent.com/assets/1957636/18415396/1df60da0-77b6-11e6-95cd-971aab361fb5.png">

Create a `WatsonBridge.swift` file. Allow Xcode to build an Objective-C bridging header when prompted.

<img width="742" alt="screen shot 2016-09-11 at 12 05 26 am" src="https://cloud.githubusercontent.com/assets/1957636/18415325/7a4355ac-77b3-11e6-9e3b-a4365f906eea.png">

In `WatsonBridge.swift`, import the Watson Developer Cloud iOS SDK framework(s) that you'd like to use. I'll use `TextToSpeechV1` as an example.

<img width="697" alt="screen shot 2016-09-11 at 12 13 51 am" src="https://cloud.githubusercontent.com/assets/1957636/18415358/a5693d04-77b4-11e6-859e-ff067388bd19.png">

Create a class in `WatsonBridge.swift` that inherits from `NSObject` (this makes it accessible from Objective-C). Write any desired methods.

<img width="707" alt="screen shot 2016-09-11 at 12 17 13 am" src="https://cloud.githubusercontent.com/assets/1957636/18415368/2231e4a8-77b5-11e6-873c-7524f05a4c5e.png">

In your Objective-C file, import the generated Swift header. Since my app is called, `ObjectiveCTest`, I `#import "ObjectiveCTest-swift.h"`. Write Objective-C code that calls the classes/functions defined in `WatsonBridge.swift`.

<img width="540" alt="screen shot 2016-09-11 at 12 27 43 am" src="https://cloud.githubusercontent.com/assets/1957636/18415411/ebe5762e-77b6-11e6-9017-f0a50fd61ff2.png">
