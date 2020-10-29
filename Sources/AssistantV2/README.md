# Watson Assistant V2

* [IBM Watson Assistant V2 - API Reference](https://cloud.ibm.com/apidocs/assistant/assistant-v2?code=swift)
* [IBM Watson Assistant V2 - Service Page](https://www.ibm.com/cloud/watson-assistant/)
* [IBM Watson Assistant V2 - Documentation](https://cloud.ibm.com/docs/assistant/index.html#about)

With the IBM Watson Assistant service you can create cognitive agents -- virtual agents
that combine machine learning, natural language understanding, and integrated dialog scripting tools to provide conversation flows between your apps and your users.

Version 2 of the Watson Assistant API is the recommended version, and features a simplified API surface and skills support.

### Starting a conversation

The following example shows how to start a conversation with the Assistant service:

```swift
import AssistantV2

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let assistant = Assistant(version: "2020-04-01", authenticator: authenticator)
assistant.serviceURL = "{url}"

let input = MessageInput(messageType: "text", text: "Hello")

assistant.message(assistantID: "{assistant_id}", sessionID: "{session_id}", input: input) {
  response, error in

  guard let message = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }

  print(message)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/assistant/assistant-v2?code=swift)