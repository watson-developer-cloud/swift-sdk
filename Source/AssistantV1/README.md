# Watson Assistant V1

* [IBM Watson Assistant - API Reference (includes Swift code examples)](https://cloud.ibm.com/apidocs/assistant/assistant-v1?code=swift)
* [IBM Watson Assistant - Documentation](https://cloud.ibm.com/docs/assistant/index.html#about)
* [IBM Watson Assistant - Service Page](https://www.ibm.com/cloud/watson-assistant/)

With the IBM Watson Assistant service you can create cognitive agents -- virtual agents
that combine machine learning, natural language understanding, and integrated dialog scripting tools to provide conversation flows between your apps and your users.

The following example shows how to start a conversation with the Assistant service:

```swift
import AssistantV1

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let assistant = Assistant(version: "2020-04-01", authenticator: authenticator)
assistant.serviceURL = "{url}"

let workspaceID = getWorkspaceID()
let input = MessageInput(text: "Hello")

assistant.message(workspaceID: "{workspace_id}", input: input) {
  response, error in

  guard let message = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }

  print(message)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/assistant/assistant-v1?code=swift)