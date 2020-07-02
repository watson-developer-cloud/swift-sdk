# Language Translator V3

* [IBM Watson Language Translator - API Reference](https://cloud.ibm.com/apidocs/language-translator?code=swift)
* [IBM Watson Language Translator - Documentation](https://cloud.ibm.com/docs/language-translator/index.html)
* [IBM Watson Language Translator - Service Page](https://www.ibm.com/cloud/watson-language-translator)

The IBM Watson Language Translator service lets you select a domain, customize it, then identify or select the language of text, and then translate the text from one supported language to another.

The following example demonstrates how to use the Language Translator service:

```swift
import LanguageTranslatorV3

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let languageTranslator = LanguageTranslator(version: "2018-05-01", authenticator: authenticator)
languageTranslator.serviceURL = "{url}"

languageTranslator.translate(text: ["Hello"], modelID: "en-es") {
  response, error in

  guard let translation = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }

  print(translation)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/language-translator?code=swift)