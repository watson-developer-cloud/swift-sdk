# Natural Language Classifier

The IBM Watson Natural Language Classifier service enables developers without a background in machine learning or statistical algorithms to create natural language interfaces for their applications. The service interprets the intent behind text and returns a corresponding classification with associated confidence levels. The return value can then be used to trigger a corresponding action, such as redirecting the request or answering a question.

The following example demonstrates how to use the Natural Language Classifier service:

```swift
import NaturalLanguageClassifierV1

let username = "your-username-here"
let password = "your-password-here"
let naturalLanguageClassifier = NaturalLanguageClassifier(username: username, password: password)

let classifierID = "your-trained-classifier-id"
let text = "your-text-here"
let failure = { (error: Error) in print(error) }
naturalLanguageClassifier.classify(classifierID: classifierID, text: text, failure: failure) {
    classification in
    print(classification)
}
```

The following links provide more information about the Natural Language Classifier service:

* [IBM Watson Natural Language Classifier - Service Page](https://www.ibm.com/watson/services/natural-language-classifier/)
* [IBM Watson Natural Language Classifier - Documentation](https://console.bluemix.net/docs/services/natural-language-classifier/natural-language-classifier-overview.html)
* [IBM Watson Natural Language Classifier - Demo](https://natural-language-classifier-demo.ng.bluemix.net/)
