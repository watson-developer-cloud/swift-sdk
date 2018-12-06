# Language Translator V3

The IBM Watson Language Translator service lets you select a domain, customize it, then identify or select the language of text, and then translate the text from one supported language to another.

The following example demonstrates how to use the Language Translator service:

```swift
import LanguageTranslatorV3

let apiKey = "your-api-key"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let languageTranslator = LanguageTranslator(version: version, apiKey: apiKey)

languageTranslator.translate(
	text: ["Hello"],
	source: "en",
	target: "es") { response, error in

	if let error = error {
        print(error)
    }
    guard let translation = response?.result else {
        print("Failed to translate")
        return
    }
    print(translation.translations)
}
```

The following links provide more information about the IBM Watson Language Translator service:

* [IBM Watson Language Translator - Service Page](https://www.ibm.com/watson/services/language-translator/)
* [IBM Watson Language Translator - Documentation](https://console.bluemix.net/docs/services/language-translator/index.html)
* [IBM Watson Language Translator - Demo](https://language-translator-demo.ng.bluemix.net/)
