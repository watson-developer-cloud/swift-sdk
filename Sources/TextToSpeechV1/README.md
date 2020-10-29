# Text to Speech

* [IBM Watson Text To Speech - API Reference](https://cloud.ibm.com/apidocs/text-to-speech?code=swift)
* [IBM Watson Text To Speech - Documentation](https://cloud.ibm.com/docs/text-to-speech/index.html)
* [IBM Watson Text To Speech - Service Page](https://www.ibm.com/cloud/watson-text-to-speech)

The IBM Watson Text to Speech service synthesizes natural-sounding speech from input text in a variety of languages and voices that speak with appropriate cadence and intonation.

The following example demonstrates how to use the Text to Speech service:

```swift
import TextToSpeechV1

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let textToSpeech = TextToSpeech(authenticator: authenticator)
textToSpeech.serviceURL = "{url}"

textToSpeech.synthesize(text: "Hello World", voice: "en-US_AllisonV3Voice", accept: "audio/wav") {
  response, error in

  guard let audio = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }

  let audioFile = URL(fileURLWithPath: NSTemporaryDirectory() + "hello_world.wav")
  do {
    try audio.write(to: audioFile)
    // Audio saved to file hello_world.wav.
  } catch {
    print("Error writing: \(error)")
  }
}
```
For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/text-to-speech?code=swift)