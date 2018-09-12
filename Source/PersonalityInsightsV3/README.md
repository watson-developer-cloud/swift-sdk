# Personality Insights

The IBM Watson Personality Insights service enables applications to derive insights from social media, enterprise data, or other digital communications. The service uses linguistic analytics to infer personality and social characteristics, including Big Five, Needs, and Values, from text.

The following example demonstrates how to use the Personality Insights service:

```swift
import PersonalityInsightsV3

let username = "your-username-here"
let password = "your-password-here"
let version = "yyyy-mm-dd" // use today's date for the most recent version
let personalityInsights = PersonalityInsights(username: username, password: password, version: version)

let failure = { (error: Error) in print(error) }
personalityInsights.profile(text: "your-input-text", failure: failure) { profile in
    print(profile)
}
```

The following links provide more information about the Personality Insights service:

* [IBM Watson Personality Insights - Service Page](https://www.ibm.com/watson/services/personality-insights/)
* [IBM Watson Personality Insights - Documentation](https://console.bluemix.net/docs/services/personality-insights/index.html)
* [IBM Watson Personality Insights - Demo](https://personality-insights-demo.ng.bluemix.net/)
