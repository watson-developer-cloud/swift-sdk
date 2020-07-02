# Personality Insights

* [IBM Watson Personality Insights - API Reference](https://cloud.ibm.com/apidocs/personality-insights?code=swift)
* [IBM Watson Personality Insights - Documentation](https://cloud.ibm.com/docs/personality-insights/index.html)
* [IBM Watson Personality Insights - Service Page](https://www.ibm.com/cloud/watson-personality-insights)

The IBM Watson Personality Insights service enables applications to derive insights from social media, enterprise data, or other digital communications. The service uses linguistic analytics to infer personality and social characteristics, including Big Five, Needs, and Values, from text.

The following example demonstrates how to use the Personality Insights service:

```swift
import PersonalityInsightsV3

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let personalityInsights = PersonalityInsights(version: "2017-10-13", authenticator: authenticator)
personalityInsights.serviceURL = "{url}"

let url = Bundle.main.url(forResource: "profile", withExtension: "json")!
let content = try JSONDecoder().decode(Content.self, from: Data(contentsOf: url))

personalityInsights.profile(profileContent: ProfileContent.content(content)) {
  response, error in

  guard let profile = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }

  print(profile)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/personality-insights?code=swift)