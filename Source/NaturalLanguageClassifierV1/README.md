# Natural Language Classifier

* [IBM Watson Natural Language Classifier - API Reference](https://cloud.ibm.com/apidocs/natural-language-classifier?code=swift)
* [IBM Watson Natural Language Classifier - Documentation](https://cloud.ibm.com/docs/natural-language-classifier/natural-language-classifier-overview.html)
* [IBM Watson Natural Language Classifier - Service Page](https://www.ibm.com/cloud/watson-natural-language-classifier)


The IBM Watson Natural Language Classifier service enables developers without a background in machine learning or statistical algorithms to create natural language interfaces for their applications. The service interprets the intent behind text and returns a corresponding classification with associated confidence levels. The return value can then be used to trigger a corresponding action, such as redirecting the request or answering a question.

The following example demonstrates how to use the Natural Language Classifier service:

```swift
import NaturalLanguageClassifierV1

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let naturalLanguageClassifier = NaturalLanguageClassifier(authenticator: authenticator)
naturalLanguageClassifier.serviceURL = "{url}"

naturalLanguageClassifier.classify(classifierID: "{classifier_id}", text: "How hot will it be today?") {
  response, error in

  guard let classification = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }

  print(classification)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/natural-language-classifier?code=swift)