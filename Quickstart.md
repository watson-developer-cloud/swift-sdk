#Quick Start Guide

This is a quick walkthrough to demonstrate how to create a iOS app that uses Watson's Text To Speech service to speak German.

###Prerequisite 

Before beginning to create the iOS client, make sure you set up your BlueMix application and create a Text To Speech service. First, sign up for a Bluemix account. Next, create a new Bluemix application, it can either be Node JS or Liberty application, it does not matter in this example since we will not be deploying any server-side code. Next, setup an instance of the Watson Text to Speech service for that application. When a service gets bound to a Bluemix application, new credentials are automatically generated for making calls to the service. These credentials will be used as part of this getting started guide, and can be found once the service is started by clicking on the “Show Credentials” link on the service. For more information about creating Bluemix applications and attaching Bluemix and Watson services read [Bluemix getting started](https://developer.ibm.com/bluemix/#gettingstarted).

In addition, this quick guide uses Carthage to fetch necessary depedencies that the Watson iOS SDK requires. You can install  [Carthage](https://github.com/Carthage/Carthage) by following **"Installing Carthage"** section. If you use Homebrew you can simply run "brew install carthage".



###Create a Text to Speach App

1) Create a **"Single View App"** in XCode and name it "WatsonSpeaks".

<img src="./images/SingleViewapp.png" width="500">

2) Fill in the fields for Project Name, Organization Name, Organization Indentifier, and Bundle Identifier.  

<img src="./images/WatsonSpeak.png" width="500">

3) Create a file called "Cartfile" in the root directory of your project and put the following inside the file:

```
        # cartfile contents
        github "SwiftyJSON/SwiftyJSON" == 2.3.1
        github "Alamofire/Alamofire" == 3.1.2
        github "DaveWoodCom/XCGLogger" == 3.1.1
        github "Hearst-DD/ObjectMapper" == 1.0.1
        github "rhodgkins/SwiftHTTPStatusCodes" == 2.0.1
        github "tristanhimmelman/AlamofireObjectMapper" == 2.1.0
        github "Quick/Nimble" == 3.0.0
        github "daltoniam/Starscream" == 1.0.2
        github "https://github.com/IBM-MIL/Watson-iOS-SDK"
```

<img src="./images/cartfile.png" width="400">

4) Run "carthage update --platform iOS" from the command line at the root of the project. If you receive a compile failure for the framework AlamofireObjectMapper, run "carthage update" again.

<img src="./images/runCarthage.png" width="500">

5) Create new Group in your Xcode project and call it "Frameworks".

<img src="./images/NewGroup.png" width="300">

6) Select all the .framework (Alamofire, AlamofireObjectMapper, HTTPStatusCodes, ObjectMapper, Starscream, XCGLogger) files in the carthage/build/ios/ directory except for **Nimble**. Drag-and-drop those files from Finder into the new "Frameworks" group inside of your project in XCode. When the dialog appears, **make sure** you deselect the option to copy items. This will create a reference to those Framework files without copying them. 

<img src="./images/frameworksInGroup.png" width="300">

7) In XCode, select your project "WatsonSpeaks", then select your build target. In the "Build Phases" tab, add a new **Copy File Phase**.

<img src="./images/BuildPhases.png" width="600">

8) Add all of the frameworks you added to XCode to the Copy Files Phase.

<img src="./images/AddedCopyFiles.png" width="600">

8) Open your ViewController class and add **import WatsonSDK** under the import of UIKit.

9) Add the code below to the ***viewDidLoad*** method in the ViewController class:

```swift
    
    var player: AVAudioPlayer?    

    // Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let tts = TextToSpeech()
        tts.setUsernameAndPassword("YOUR TTS USERNAME", password: "YOUR TTS PASSWORD")
        tts.synthesize("All the problems of the world could be settled easily if men were only willing to think.") { 

            data, error in

            if let audio = data {

                do {
                    self.player = try AVAudioPlayer(data: audio)
                    self.player!.play()
                } catch {
                    print("Couldn't create player.")
                }

            } else {
                print(error)
            }
            
        }

     }
```

<img src="./images/viewDidLoad.png" width="500">

10) Use the credentials that Bluemix created and set them for username and password in the setUserNameAndPassword function.

11) Add the following to your info.plist. In order to make network calls to Watson, we need to whitelist the URL to the stream.watsonplatform.net server.

```xml
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>stream.watsonplatform.net</key>
			<dict>
				<key>NSTemporaryExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
			</dict>
		</dict>
	</dict>

```

<img src="./images/plistPropertyList.png" width="600">

<img src="./images/plistSource.png" width="600">


12) Run application in a Simulator, and you should hear speech coming from the speaker.

13) Enjoy!

You can review the different voices and languages [here](https://github.com/IBM-MIL/Watson-iOS-SDK#text-to-speech).

You can download all the source code for the Watson iOS SDK [here](https://github.com/IBM-MIL/Watson-iOS-SDK).

