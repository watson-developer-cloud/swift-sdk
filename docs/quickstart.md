# Quick Start Guide

This guide contains step-by-step instructions to create an iOS application with the Watson Developer Cloud Swift SDK. The application we build will synthesize English text into spoken audio using the Watson Text to Speech service.

## Create Application

1. Open Xcode and create a new project with the "Single View Application" template.

    ![New Project](quickstart-resources/01-NewProject.png?raw=true)

2. Set the product name to "Watson Speaks" and language to "Swift."
    
    ![Project Settings](quickstart-resources/02-ProjectSettings.png?raw=true)

## Download and Build the Swift SDK Frameworks

We will use the [Carthage](https://github.com/Carthage/Carthage) dependency manager to download and build the Swift SDK. You will need to [install Carthage](https://github.com/Carthage/Carthage#installing-carthage) if it is not already installed on your system.

1. Create a file in your project directory called `Cartfile`.

    ![Create Cartfile](quickstart-resources/03-CreateCartfile.png?raw=true)

2. Add the following line to your `Cartfile`. This specifies the Swift SDK as a dependency. In a production app, you may also want to specify a [version requirement](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#version-requirement).

    ```
    github "watson-developer-cloud/swift-sdk"
    ```

    ![Add Dependency](quickstart-resources/04-AddDependency.png?raw=true)

3. Open the Terminal and navigate to your project directory. Then use Carthage to download and build the Swift SDK:

    ```
    $ carthage update --platform iOS
    ```

    ![Carthage Update](quickstart-resources/05-CarthageUpdate.png?raw=true)

Carthage clones the Swift SDK repository and builds a framework for each Watson service in the `Carthage/Build/iOS` directory. It also builds a framework called `RestKit` that is used internally for networking and JSON parsing.

### Add Swift SDK Frameworks to Application

To use the Swift SDK frameworks, we need to link them with our application.

1. In Xcode, navigate to your application target's "General" settings tab. Then scroll down to the "Linked Frameworks and Libraries" section and click the `+` icon.

    ![General Settings](quickstart-resources/06-GeneralSettings.png?raw=true)

2. In the window that appears, choose "Add Other..." and navigate to the `Carthage/Build/iOS` directory. Select the `TextToSpeechV1` and `RestKit` frameworks to link them with your application.

    ![Link Frameworks](quickstart-resources/07-LinkFrameworks.png?raw=true)

We also need to copy the frameworks into our application to make them accessible at runtime. We will use a Carthage script to copy the frameworks and avoid an [App Store submission bug](http://www.openradar.me/radar?id=6409498411401216).

1. In Xcode, navigate to your application target's "Build Phases" settings tab. Then click the `+` icon and add a "New Run Script Phase."

    ![New Run Script Phase](quickstart-resources/09-NewRunScriptPhase.png?raw=true)

2. Add the following command to the run script phase:

    ```
    /usr/local/bin/carthage copy-frameworks
    ```

    ![AddCarthageScript](quickstart-resources/10-AddCarthageScript.png?raw=true)

4. Add the frameworks you'd like to use (and the `RestKit` framework) to the "Input Files" list:

    ```
    $(SRCROOT)/Carthage/Build/iOS/TextToSpeechV1.framework
    $(SRCROOT)/Carthage/Build/iOS/RestKit.framework
    ```

    ![Add Input Files](quickstart-resources/11-AddInputFiles.png?raw=true)

## Synthesize with Text to Speech

We will modify our project's `ViewController` to synthesize English text with the Text to Speech service.

1. In Xcode, open the `ViewController.swift` file.

2. Add import statements for `TextToSpeechV1` and `AVFoundation`:

    ```swift
    import TextToSpeechV1
    import AVFoundation
    ```

    ![Import Frameworks](quickstart-resources/14-ImportFrameworks.png?raw=true)

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

    ![Synthesize Text](quickstart-resources/15-SynthesizeText.png?raw=true)

5. Run your application in the simulator to hear the synthesized text!
