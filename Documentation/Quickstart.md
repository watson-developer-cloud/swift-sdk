# Quick Start Guide

This guide contains step-by-step instructions to create an iOS application with the Watson Developer Cloud iOS SDK. The application we build will synthesize English text into spoken audio using the Watson Text to Speech service.

## Create Application

1. Open Xcode and create a new project with the "Single View Application" template.

    ![New Project](Quickstart-Images/01-NewProject.png?raw=true)

2. Set the product name to "Watson Speaks" and language to "Swift."
    
    ![Project Settings](Quickstart-Images/02-ProjectSettings.png?raw=true)

## Download and Build the iOS SDK Frameworks

We will use the [Carthage](https://github.com/Carthage/Carthage) dependency manager to download and build the iOS SDK. You will need to [install Carthage](https://github.com/Carthage/Carthage#installing-carthage) if it is not already installed on your system.

1. Create a file in your project directory called `Cartfile`.

    ![Create Cartfile](Quickstart-Images/03-CreateCartfile.png?raw=true)

2. Add the following line to your `Cartfile`. This specifies the iOS SDK as a dependency. In a production app, you may also want to specify a [version requirement](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#version-requirement).

    ```
    github "watson-developer-cloud/ios-sdk"
    ```

    ![Add Dependency](Quickstart-Images/04-AddDependency.png?raw=true)

3. Open the Terminal and navigate to your project directory. Then use Carthage to download and build the iOS SDK:

    ```
    $ carthage update --platform iOS
    ```

    ![Carthage Update](Quickstart-Images/05-CarthageUpdate.png?raw=true)

Carthage clones the iOS SDK repository and builds a framework for each Watson service in the `Carthage/Build/iOS` directory. It also builds a framework called `RestKit` that is used internally for networking and JSON parsing.

### Add iOS SDK Frameworks to Application

To use the iOS SDK frameworks, we need to link them with our application.

1. In Xcode, navigate to your application target's "General" settings tab. Then scroll down to the "Linked Frameworks and Libraries" section and click the `+` icon.

    ![General Settings](Quickstart-Images/06-GeneralSettings.png?raw=true)

2. In the window that appears, choose "Add Other..." and navigate to the `Carthage/Build/iOS` directory. Select the `TextToSpeechV1` and `RestKit` frameworks to link them with your application.

    ![Link Frameworks](Quickstart-Images/07-LinkFrameworks.png?raw=true)

We also need to copy the frameworks into our application to make them accessible at runtime. We will use a Carthage script to copy the frameworks and avoid an [App Store submission bug](http://www.openradar.me/radar?id=6409498411401216).

1. In Xcode, navigate to your application target's "Build Phases" settings tab. Then click the `+` icon and add a "New Run Script Phase."

    ![New Run Script Phase](Quickstart-Images/09-NewRunScriptPhase.png?raw=true)

2. Add the following command to the run script phase:

    ```
    /usr/local/bin/carthage copy-frameworks
    ```

    ![AddCarthageScript](Quickstart-Images/10-AddCarthageScript.png?raw=true)

4. Add the frameworks you'd like to use (and the `RestKit` framework) to the "Input Files" list:

    ```
    $(SRCROOT)/Carthage/Build/iOS/TextToSpeechV1.framework
    $(SRCROOT)/Carthage/Build/iOS/RestKit.framework
    ```

    ![Add Input Files](Quickstart-Images/11-AddInputFiles.png?raw=true)

## Add Exception for App Transport Security

To securely connect to IBM Watson services, the application's `Info.plist` file must be modified with an App Transport Security exception for the `watsonplatform.net` domain.

1. In Xcode, right-click on the `Info.plist` file and choose `Open As -> Source Code`.

    ![Open As Source Code](Quickstart-Images/12-OpenAsSourceCode.png?raw=true)

2. Copy-and-paste the following source code into the `Info.plist` file.

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

    ![App Transport Security Exception](Quickstart-Images/13-AppTransportSecurity.png?raw=true)

## Synthesize with Text to Speech

We will modify our project's `ViewController` to synthesize English text with the Text to Speech service.

1. In Xcode, open the `ViewController.swift` file.

2. Add import statements for `TextToSpeechV1` and `AVFoundation`:

    ```swift
    import TextToSpeechV1
    import AVFoundation
    ```

    ![Import Frameworks](Quickstart-Images/14-ImportFrameworks.png?raw=true)

3. Add a `var audioPlayer: AVAudioPlayer!` property to the `ViewController` class. This ensures that the audio player does not fall out of scope and end playback when the `viewDidLoad()` function returns.

4. Add the following code to your `viewDidLoad` method. Be sure to update the username and password with the credentials for your Watson Text to Speech instance.

    ```swift
    let username = "your-text-to-speech-username"
    let password = "your-text-to-speech-password"
    let textToSpeech = TextToSpeech(username: username, password: password)
    
    let text = "All the problems of the world could be settled easily if men were only willing to think."
    let failure = { (error: Error) in print(error) }
    textToSpeech.synthesize(text, failure: failure) { data in
        self.audioPlayer = try! AVAudioPlayer(data: data)
        self.audioPlayer.play()
    }
    ```

    ![Synthesize Text](Quickstart-Images/15-SynthesizeText.png?raw=true)

5. Run your application in the simulator to hear the synthesized text!
