# Watson Assistant

With the IBM Watson Assistant service you can create cognitive agents -- virtual agents 
that combine machine learning, natural language understanding, and integrated dialog scripting tools to provide conversation flows between your apps and your users.

The following example shows how to start a conversation with the Assistant service:

```swift
import AssistantV1

let apiKey = "your-api-key"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let assistant = Assistant(version: version, apiKey: apiKey)

let workspaceID = "your-workspace-id"
var context: Context? // save context to continue the conversation later
assistant.message(workspaceID: workspaceID) { response, error in
	if let error = error {
        print(error)
    }
    guard let message = response?.result else {
        print("Failed to get the message")
        return
    }
    print(message.output.text)
    context = message.context
}
```

The following example shows how to continue an existing conversation with the Assistant service:

```swift
let input = InputData(text: "Turn on the radio")
assistant.message(
	workspaceID: workspaceID,
	input: input,
	context: context) { response, error in

    if let error = error {
        print(error)
    }
    guard let message = response?.result else {
        print("Failed to get the message")
        return
    }
    print(message.output.text)
    context = message.context
}
```

### Context Variables

The Assistant service allows users to define custom context variables in their application's payload. For example, a workspace that guides users through a pizza order might include a context variable for pizza size: `"pizza_size": "large"`.

Context variables are get/set using the `additionalProperties` property of a `Context` model. The following example shows how to get and set a user-defined `pizza_size` variable:

```swift
// Get the `pizza_size` context variable
let input = InputData(text: "Order a pizza")
assistant.message(
	workspaceID: workspaceID,
	input: input,
	context: context) { response, error in

    if let error = error {
        print(error)
    }
    guard let message = response?.result else {
        print("Failed to get the message")
        return
    }
    if case let JSON.string(pizzaSize)? = message.context?.additionalProperties["pizza_size"] {
        print(pizzaSize)
    }
}

// Set the `pizza_size` context variable
assistant.message(
	workspaceID: workspaceID,
	input: input,
	context: context) { response, error in

	if let error = error {
        print(error)
    }
    guard let message = response?.result else {
        print("Failed to get the message")
        return
    }
    context = message.context
    context?.additionalProperties["pizza_size"] = JSON.string("large")
}
```

The following links provide more information about the IBM Watson Assistant service:

* [IBM Watson Assistant - Service Page](https://www.ibm.com/cloud/watson-assistant/)
* [IBM Watson Assistant - Documentation](https://console.bluemix.net/docs/services/assistant/index.html#about)
