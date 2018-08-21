# Natural Language Understanding

The IBM Natural Language Understanding service explores various features of text content. Provide text, raw HTML, or a public URL, and IBM Watson Natural Language Understanding will give you results for the features you request. The service cleans HTML content before analysis by default, so the results can ignore most advertisements and other unwanted content.

Natural Language Understanding has the following features:

- Concepts
- Entities
- Keywords
- Categories
- Sentiment
- Emotion
- Relations
- Semantic Roles

The following example demonstrates how to use the service:

```swift
import NaturalLanguageUnderstandingV1

let username = "your-username-here"
let password = "your-password-here"
let version = "yyyy-mm-dd" // use today's date for the most recent version
let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: username, password: password, version: version)

let features = Features(concepts: ConceptsOptions(limit: 5))
let parameters = Parameters(features: features, text: "your-text-here")
let failure = { (error: Error) in print(error) }
naturalLanguageUnderstanding.analyze(parameters: parameters, failure: failure) {
    results in
    print(results)
}
```

### 500 errors
Note that **you are required to include at least one feature in your request.** You will receive a 500 error if you do not include any features in your request.

The following links provide more information about the Natural Language Understanding service:

* [IBM Watson Natural Language Understanding - Service Page](https://www.ibm.com/watson/services/natural-language-understanding/)
* [IBM Watson Natural Language Understanding - Documentation](https://console.bluemix.net/docs/services/natural-language-understanding/index.html)
* [IBM Watson Natural Language Understanding - Demo](https://natural-language-understanding-demo.ng.bluemix.net/)
