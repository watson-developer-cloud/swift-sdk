# Tone Analyzer

* [IBM Watson Tone Analyzer - API Reference](https://cloud.ibm.com/apidocs/tone-analyzer?code=swift)
* [IBM Watson Tone Analyzer - Documentation](https://cloud.ibm.com/docs/tone-analyzer/index.html)
* [IBM Watson Tone Analyzer - Service Page](https://www.ibm.com/cloud/watson-tone-analyzer)

The IBM Watson Tone Analyzer service can be used to discover, understand, and revise the language tones in text. The service uses linguistic analysis to detect three types of tones from written text: emotions, social tendencies, and writing style.

Emotions identified include things like anger, fear, joy, sadness, and disgust. Identified social tendencies include things from the Big Five personality traits used by some psychologists. These include openness, conscientiousness, extraversion, agreeableness, and emotional range. Identified writing styles include confident, analytical, and tentative.

The following example demonstrates how to use the Tone Analyzer service:

```swift
import ToneAnalyzerV3

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let toneAnalyzer = ToneAnalyzer(version: "2017-09-21", authenticator: authenticator)
toneAnalyzer.serviceURL = "{url}"

let text = """
Team, I know that times are tough! Product \
sales have been disappointing for the past three \
quarters. We have a competitive product, but we \
need to do a better job of selling it!
"""

toneAnalyzer.tone(toneContent: .text(text)) {
  response, error in

  guard let toneAnalysis = response?.result else {
    print(error as Any)
    return
  }

  print(toneAnalysis)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/tone-analyzer?code=swift)