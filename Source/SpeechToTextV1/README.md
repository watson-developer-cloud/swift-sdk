# Speech to Text

* [IBM Watson Speech to Text - API Reference](https://cloud.ibm.com/apidocs/speech-to-text?code=swift)
* [IBM Watson Speech to Text - Documentation](https://cloud.ibm.com/docs/speech-to-text/index.html)
* [IBM Watson Speech to Text - Service Page](https://www.ibm.com/cloud/watson-speech-to-text)

The IBM Watson Speech to Text service enables you to add speech transcription capabilities to your application. It uses machine intelligence to combine information about grammar and language structure to generate an accurate transcription. Transcriptions are supported for various audio formats and languages.

**IMPORTANT:** Please be sure to include both `SpeechToTextV1.framework` and `Starscream.framework` in your application. Starscream is a recursive dependency that adds support for WebSockets sessions.

The following example shows how to transcribe an audio file using the standard API endpoint.

```swift
import SpeechToTextV1

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let speechToText = SpeechToText(authenticator: authenticator)
speechToText.serviceURL = "{url}"

let url = Bundle.main.url(forResource: "audio-file2", withExtension: "flac")
var audio = try! Data(contentsOf: url!)

speechToText.recognize(
  audio: audio,
  keywords: ["colorado", "tornado", "tornadoes"],
  keywordsThreshold: 0.5,
  wordAlternativesThreshold: 0.90,
  contentType: "audio/flac")
{
  response, error in

  guard let results = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }

  print(results)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/speech-to-text?code=swift)


## Recognizing audio using websockets

The Swift SDK extends the `Starcream` library to offer websocket support for recognizing audio.

You can transcribe audio using web sockets by calling the `recognizeUsingWebSockets` method on the `SpeechToText` class, as shown in this example.

```swift
import SpeechToTextV1

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let speechToText = SpeechToText(authenticator: authenticator)
speechToText.serviceURL = "{url}"

let url = Bundle.main.url(forResource: "audio-file2", withExtension: "flac")
var audio = try! Data(contentsOf: url!

let settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")

var callback = RecognizeCallback()

// register error handler
callback.onError = { error in
    // handle error in some way
}

// register result handler
callback.onResults = { results in
    // process results in some way
}

speechToText.recognizeUsingWebSocket(audio: fileData, settings: settings, callback: callback)
```

In the above example, the `RecognitionSettings` struct is used to define the settings for the recognition request. Additional the `RecognizeCallback` struct allows you to register event handlers for web socket events.

## Recognizing audio from microphone

If you'd like to record audio from a device microphone and trascribe it using Speech to Text, you can use the SDK provided `recognizeMicrophone` method, as shown in this example.

```swift
import SpeechToTextV1

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let speechToText = SpeechToText(authenticator: authenticator)
speechToText.serviceURL = "{url}"

var accumulator = SpeechRecognitionResultsAccumulator()

// this function can be called from a button press or similar action
// based on user input
func startStreaming() {
    var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
    settings.interimResults = true
    speechToText.recognizeMicrophone(settings: settings) { response, error in
    	if let error = error {
    		print(error)
	    }
	    guard let results = response?.result else {
	        print("Failed to recognize the audio")
	        return
	    }
        accumulator.add(results: results)
        print(accumulator.bestTranscript)
    }
}

// this function can be called when the user releases a button or a similar action
func stopStreaming() {
    speechToText.stopRecognizeMicrophone()
}
```

The above example uses the `recognizeMicrophone` method within a function, which can be called from a button click or user input. How you call it is up to you, but the above provides a typical example of how you would record while responding to a UI action.

## Advanced Usage

### Microphone Audio and Compression in detail

The Speech to Text framework makes it easy to perform speech recognition with microphone audio. The framework internally manages the microphone, starting and stopping it with various method calls (`recognizeMicrophone` and `stopRecognizeMicrophone`, or `startMicrophone` and `stopMicrophone`).

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

### Recognition Results Accumulator in detail

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

### Session Management and Advanced Features

Advanced users may want more customizability than provided by the `SpeechToText` class. The `SpeechToTextSession` class exposes more control over the WebSockets connection and also includes several advanced features for accessing the microphone. The `SpeechToTextSession` class also allows users more control over the AVAudioSession shared instance. Before using `SpeechToTextSession`, it's helpful to be familiar with the [Speech to Text WebSocket interface](https://cloud.ibm.com/docs/services/speech-to-text/websockets.html).

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

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let speechToTextSession = SpeechToTextSession(authenticator: authenticator)

var accumulator = SpeechRecognitionResultsAccumulator()

do {
    let session = AVAudioSession.sharedInstance()
    try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers])
    try session.setActive(true)
} catch {
    print(error)
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