# Personality Insights

The IBM Watson Personality Insights service enables applications to derive insights from social media, enterprise data, or other digital communications. The service uses linguistic analytics to infer personality and social characteristics, including Big Five, Needs, and Values, from text.

The following example demonstrates how to use the Personality Insights service:

```swift
import PersonalityInsightsV3

let apiKey = "your-api-key"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let personalityInsights = PersonalityInsights(version: version, apiKey: apiKey)

let content = ProfileContent.text("your-text")
personalityInsights.profile(profileContent: content) { response, error in
	if let error = error {
        print(error)
    }
    guard let profile = response?.result else {
        print("Failed to generate profile")
        return
    }
    print(profile)
}
```

The following links provide more information about the Personality Insights service:

* [IBM Watson Personality Insights - Service Page](https://www.ibm.com/watson/services/personality-insights/)
* [IBM Watson Personality Insights - Documentation](https://console.bluemix.net/docs/services/personality-insights/index.html)
* [IBM Watson Personality Insights - Demo](https://personality-insights-demo.ng.bluemix.net/)
