# Text to Speech

The IBM Watson Text to Speech service synthesizes natural-sounding speech from input text in a variety of languages and voices that speak with appropriate cadence and intonation.

The following example demonstrates how to use the Text to Speech service:

```swift
import TextToSpeechV1
import AVFoundation

let apiKey = "your-api-key"
let textToSpeech = TextToSpeech(apiKey: apiKey)

// The AVAudioPlayer object will stop playing if it falls out-of-scope.
// Therefore, to prevent it from falling out-of-scope we declare it as
// a property outside the completion handler where it will be played.
var audioPlayer = AVAudioPlayer()

let text = "your-text"
textToSpeech.synthesize(text: text, accept: "audio/wav") { response, error in
	if let error = error {
        print(error)
    }
    guard let data = response?.result else {
        print("Failed to synthesize the text")
        return
    }
    do {
        audioPlayer = try AVAudioPlayer(data: data)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    catch {
        print(error)
    }
}
```

The Text to Speech service supports a number of [voices](https://console.bluemix.net/docs/services/text-to-speech/http.html#voices) for different genders, languages, and dialects. The following example demonstrates how to use the Text to Speech service with a particular voice:

```swift
import TextToSpeechV1

let apiKey = "your-api-key"
let textToSpeech = TextToSpeech(apiKey: apiKey)

// The AVAudioPlayer object will stop playing if it falls out-of-scope.
// Therefore, to prevent it from falling out-of-scope we declare it as
// a property outside the completion handler where it will be played.
var audioPlayer = AVAudioPlayer()

let text = "your-text"
textToSpeech.synthesize(
	text: text,
	accept: "audio/wav",
	voice: "en-US_LisaVoice") { response, error in
	
	if let error = error {
        print(error)
    }
    guard let data = response?.result else {
        print("Failed to synthesize the text")
        return
    }
    do {
        audioPlayer = try AVAudioPlayer(data: data)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    catch {
        print(error)
    }
}
```

The following links provide more information about the IBM Text To Speech service:

* [IBM Watson Text To Speech - Service Page](https://www.ibm.com/watson/services/text-to-speech/)
* [IBM Watson Text To Speech - Documentation](https://console.bluemix.net/docs/services/text-to-speech/index.html)
* [IBM Watson Text To Speech - Demo](https://text-to-speech-demo.ng.bluemix.net/)
