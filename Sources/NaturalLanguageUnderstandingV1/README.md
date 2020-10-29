# Natural Language Understanding

* [IBM Watson Natural Language Understanding - API Reference](https://cloud.ibm.com/apidocs/natural-language-understanding?code=swift)
* [IBM Watson Natural Language Understanding - Documentation](https://cloud.ibm.com/docs/natural-language-understanding/index.html)
* [IBM Watson Natural Language Understanding - Service Page](https://www.ibm.com/cloud/watson-natural-language-understanding)

The IBM Natural Language Understanding service explores various features of text content. Provide text, raw HTML, or a public URL, and IBM Watson Natural Language Understanding will give you results for the features you request. The service cleans HTML content before analysis by default, so the results can ignore most advertisements and other unwanted content.

The following example demonstrates how to use the service:

```swift
import NaturalLanguageUnderstandingV1

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(version: "2019-07-12", authenticator: authenticator)
naturalLanguageUnderstanding.serviceURL = "{url}"

let text = "IBM is an American multinational technology " +
  "company headquartered in Armonk, New York, " +
  "United States, with operations in over 170 countries."

let features = Features(
  entities: EntitiesOptions(limit: 2, sentiment: true, emotion: true),
  keywords: KeywordsOptions(limit: 2, sentiment: true, emotion: true)
)
naturalLanguageUnderstanding.analyze(features: features, text: text) {
  response, error in

  guard let analysis = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }

  print(analysis)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/natural-language-understanding?code=swift)