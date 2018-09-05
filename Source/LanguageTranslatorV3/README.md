# Language Translator V3

The IBM Watson Language Translator service lets you select a domain, customize it, then identify or select the language of text, and then translate the text from one supported language to another.

The following example demonstrates how to use the Language Translator service:

```swift
import LanguageTranslatorV3

let username = "your-username-here"
let password = "your-password-here"
let version = "yyyy-mm-dd" // use today's date for the most recent version
let languageTranslator = LanguageTranslator(username: username, password: password, version: version)

let failure = { (error: Error) in print(error) }
let request = TranslateRequest(text: ["Hello"], source: "en", target: "es")
languageTranslator.translate(request: request, failure: failure) {
    translation in
    print(translation)
}
```

The following links provide more information about the IBM Watson Language Translator service:

* [IBM Watson Language Translator - Service Page](https://www.ibm.com/watson/services/language-translator/)
* [IBM Watson Language Translator - Documentation](https://console.bluemix.net/docs/services/language-translator/index.html)
* [IBM Watson Language Translator - Demo](https://language-translator-demo.ng.bluemix.net/)
