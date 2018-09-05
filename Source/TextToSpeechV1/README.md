# Text to Speech

The IBM Watson Text to Speech service synthesizes natural-sounding speech from input text in a variety of languages and voices that speak with appropriate cadence and intonation.

The following example demonstrates how to use the Text to Speech service:

```swift
import TextToSpeechV1
import AVFoundation

let username = "your-username-here"
let password = "your-password-here"
let textToSpeech = TextToSpeech(username: username, password: password)

// The AVAudioPlayer object will stop playing if it falls out-of-scope.
// Therefore, to prevent it from falling out-of-scope we declare it as
// a property outside the completion handler where it will be played.
var audioPlayer = AVAudioPlayer()

let text = "your-text-here"
let accept = "audio/wav"
let failure = { (error: Error) in print(error) }
textToSpeech.synthesize(text: text, accept: accept, failure: failure) { data in
    audioPlayer = try! AVAudioPlayer(data: data)
    audioPlayer.prepareToPlay()
    audioPlayer.play()
}
```

The Text to Speech service supports a number of [voices](https://console.bluemix.net/docs/services/text-to-speech/http.html#voices) for different genders, languages, and dialects. The following example demonstrates how to use the Text to Speech service with a particular voice:

```swift
import TextToSpeechV1

let username = "your-username-here"
let password = "your-password-here"
let textToSpeech = TextToSpeech(username: username, password: password)

// The AVAudioPlayer object will stop playing if it falls out-of-scope.
// Therefore, to prevent it from falling out-of-scope we declare it as
// a property outside the completion handler where it will be played.
var audioPlayer = AVAudioPlayer()

let text = "your-text-here"
let accept = "audio/wav"
let voice = "en-US_LisaVoice"
let failure = { (error: Error) in print(error) }
textToSpeech.synthesize(text: text, accept: accept, voice: voice, failure: failure) { data in
    audioPlayer = try! AVAudioPlayer(data: data)
    audioPlayer.prepareToPlay()
    audioPlayer.play()
}
```

The following links provide more information about the IBM Text To Speech service:

* [IBM Watson Text To Speech - Service Page](https://www.ibm.com/watson/services/text-to-speech/)
* [IBM Watson Text To Speech - Documentation](https://console.bluemix.net/docs/services/text-to-speech/index.html)
* [IBM Watson Text To Speech - Demo](https://text-to-speech-demo.ng.bluemix.net/)
