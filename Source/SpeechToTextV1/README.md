# Speech to Text

The IBM Watson Speech to Text service enables you to add speech transcription capabilities to your application. It uses machine intelligence to combine information about grammar and language structure to generate an accurate transcription. Transcriptions are supported for various audio formats and languages.

The `SpeechToText` class is the SDK's primary interface for performing speech recognition requests. It supports the transcription of audio files, audio data, and streaming microphone data. Advanced users, however, may instead wish to use the `SpeechToTextSession` class that exposes more control over the WebSockets session.

Please be sure to include both `SpeechToTextV1.framework` and `Starscream.framework` in your application. Starscream is a recursive dependency that adds support for WebSockets sessions.

Beginning with iOS 10+, any application that accesses the microphone must include the `NSMicrophoneUsageDescription` key in the app's `Info.plist` file. Otherwise, the app will crash. Find more information about this [here](https://forums.developer.apple.com/thread/61521).

### Recognition Request Settings

The `RecognitionSettings` class is used to define the audio format and behavior of a recognition request. These settings are transmitted to the service when [initating a request](https://console.bluemix.net/docs/services/speech-to-text/websockets.html#WSstart).

The following example demonstrates how to define a recognition request that transcribes WAV audio data with interim results:

```swift
var settings = RecognitionSettings(contentType: "audio/wav")
settings.interimResults = true
```

See the [class documentation](http://watson-developer-cloud.github.io/swift-sdk/services/SpeechToTextV1/Structs/RecognitionSettings.html) or [service documentation](https://console.bluemix.net/docs/services/speech-to-text/index.html) for more information about the available settings.

### Microphone Audio and Compression

The Speech to Text framework makes it easy to perform speech recognition with microphone audio. The framework internally manages the microphone, starting and stopping it with various function calls (such as `recognizeMicrophone(settings:model:customizationID:learningOptOut:compress:failure:success)` and `stopRecognizeMicrophone()` or `startMicrophone(compress:)` and `stopMicrophone()`).

There are two different ways that your app can determine when to stop the microphone:

- User Interaction: Your app could rely on user input to stop the microphone. For example, you could use a button to start/stop transcribing, or you could require users to press-and-hold a button to start/stop transcribing.

- Final Result: Each transcription result has a `final` property that is `true` when the audio stream is complete or a timeout has occurred. By watching for the `final` property, your app can stop the microphone after determining when the user has finished speaking.

To reduce latency and bandwidth, the microphone audio is compressed to OggOpus format by default. To disable compression, set the `compress` parameter to `false`.

It's important to specify the correct audio format for recognition requests that use the microphone:

```swift
// compressed microphone audio uses the opus format
let settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")

// uncompressed microphone audio uses a 16-bit mono PCM format at 16 kHz
let settings = RecognitionSettings(contentType: "audio/l16;rate=16000;channels=1")
```

### Recognition Results Accumulator

The Speech to Text service may not always return the entire transcription in a single response. Instead, the transcription may be streamed over multiple responses, each with a chunk of the overall results. This is especially common for long audio files, since the entire transcription may contain a significant amount of text.

To help combine multiple responses, the Swift SDK provides a `SpeechRecognitionResultsAccumulator` object. The accumulator tracks results as they are added and maintains several useful instance variables:
    - `results`: A list of all accumulated recognition results.
    - `speakerLabels`: A list of all accumulated speaker labels.
    - `bestTranscript`: A concatenation of transcripts with the greatest confidence.

To use the accumulator, initialize an instance of the object then add results as you receive them:

```swift
var accumulator = SpeechRecognitionResultsAccumulator()
accumulator.add(results: results)
print(accumulator.bestTranscript)
```

### Transcribe Recorded Audio

The following example demonstrates how to use the Speech to Text service to transcribe a WAV audio file.

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToText = SpeechToText(username: username, password: password)

var accumulator = SpeechRecognitionResultsAccumulator()

let audio = Bundle.main.url(forResource: "filename", withExtension: "wav")!
var settings = RecognitionSettings(contentType: "audio/wav")
settings.interimResults = true
let failure = { (error: Error) in print(error) }
speechToText.recognize(audio, settings: settings, failure: failure) {
    results in
    accumulator.add(results: results)
    print(accumulator.bestTranscript)
}
```

### Transcribe Microphone Audio

Audio can be streamed from the microphone to the Speech to Text service for real-time transcriptions. The following example demonstrates how to use the Speech to Text service to transcribe microphone audio:

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToText = SpeechToText(username: username, password: password)

var accumulator = SpeechRecognitionResultsAccumulator()

func startStreaming() {
    var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
    settings.interimResults = true
    let failure = { (error: Error) in print(error) }
    speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
        accumulator.add(results: results)
        print(accumulator.bestTranscript)
    }
}

func stopStreaming() {
    speechToText.stopRecognizeMicrophone()
}
```

### Session Management and Advanced Features

Advanced users may want more customizability than provided by the `SpeechToText` class. The `SpeechToTextSession` class exposes more control over the WebSockets connection and also includes several advanced features for accessing the microphone. The `SpeechToTextSession` class also allows users more control over the AVAudioSession shared instance. Before using `SpeechToTextSession`, it's helpful to be familiar with the [Speech to Text WebSocket interface](https://console.bluemix.net/docs/services/speech-to-text/websockets.html).

The following steps describe how to execute a recognition request with `SpeechToTextSession`:

1. Connect: Invoke `connect()` to connect to the service.
2. Start Recognition Request: Invoke `startRequest(settings:)` to start a recognition request.
3. Send Audio: Invoke `recognize(audio:)` or `startMicrophone(compress:)`/`stopMicrophone()` to send audio to the service.
4. Stop Recognition Request: Invoke `stopRequest()` to end the recognition request. If the recognition request is already stopped, then sending a stop message will have no effect.
5. Disconnect: Invoke `disconnect()` to wait for any remaining results to be received and then disconnect from the service.

All text and data messages sent by `SpeechToTextSession` are queued, with the exception of `connect()` which immediately connects to the server. The queue ensures that the messages are sent in-order and also buffers messages while waiting for a connection to be established. This behavior is generally transparent.

A `SpeechToTextSession` also provides several (optional) callbacks. The callbacks can be used to learn about the state of the session or access microphone data.

- `onConnect`: Invoked when the session connects to the Speech to Text service.
- `onMicrophoneData`: Invoked with microphone audio when a recording audio queue buffer has been filled. If microphone audio is being compressed, then the audio data is in OggOpus format. If uncompressed, then the audio data is in 16-bit PCM format at 16 kHz.
- `onPowerData`: Invoked every 0.025s when recording with the average dB power of the microphone.
- `onResults`: Invoked when transcription results are received for a recognition request.
- `onError`: Invoked when an error or warning occurs.
- `onDisconnect`: Invoked when the session disconnects from the Speech to Text service.

Note that the `AVAudioSession.sharedInstance()` must be configured to allow microphone access when using `SpeechToTextSession`. This allows users to set a particular configuration for the `AVAudioSession`. An example configuration is shown in the code below.

The following example demonstrates how to use `SpeechToTextSession` to transcribe microphone audio:

```swift
import SpeechToTextV1

let username = "your-username-here"
let password = "your-password-here"
let speechToTextSession = SpeechToTextSession(username: username, password: password)

var accumulator = SpeechRecognitionResultsAccumulator()

do {
    let session = AVAudioSession.sharedInstance()
    try session.setActive(true)
    try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.mixWithOthers, .defaultToSpeaker])
} catch {
    print(error.localizedDescription)
}

func startStreaming() {
    // define callbacks
    speechToTextSession.onConnect = { print("connected") }
    speechToTextSession.onDisconnect = { print("disconnected") }
    speechToTextSession.onError = { error in print(error) }
    speechToTextSession.onPowerData = { decibels in print(decibels) }
    speechToTextSession.onMicrophoneData = { data in print("received data") }
    speechToTextSession.onResults = { results in
        accumulator.add(results: results)
        print(accumulator.bestTranscript)
    }

    // define recognition request settings
    var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
    settings.interimResults = true

    // start streaming microphone audio for transcription
    speechToTextSession.connect()
    speechToTextSession.startRequest(settings: settings)
    speechToTextSession.startMicrophone()
}

func stopStreaming() {
    speechToTextSession.stopMicrophone()
    speechToTextSession.stopRequest()
    speechToTextSession.disconnect()
}
```

### Customization

There are a number of ways that Speech to Text can be customized to suit your particular application. For example, you can define custom words or upload audio to train an acoustic model. For more information, refer to the [service documentation](https://console.bluemix.net/docs/services/speech-to-text/index.html) or [API documentation](http://watson-developer-cloud.github.io/swift-sdk/swift-api/services/SpeechToTextV1/Classes/SpeechToText.html).

### Additional Information

The following links provide more information about the IBM Speech to Text service:

* [IBM Watson Speech to Text - Service Page](https://www.ibm.com/watson/services/speech-to-text/)
* [IBM Watson Speech to Text - Documentation](https://console.bluemix.net/docs/services/speech-to-text/index.html)
* [IBM Watson Speech to Text - Demo](https://speech-to-text-demo.ng.bluemix.net/)
