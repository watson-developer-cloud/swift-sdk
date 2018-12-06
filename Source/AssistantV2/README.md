# Watson Assistant

With the IBM Watson Assistant service you can create cognitive agents -- virtual agents 
that combine machine learning, natural language understanding, and integrated dialog scripting tools to provide conversation flows between your apps and your users.

### Starting a conversation

The following example shows how to start a conversation with the Assistant service:

```swift
import AssistantV2

let apiKey = "your-api-key"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let assistant = Assistant(version: version, apiKey: apiKey)

let workspaceID = "your-workspace-id"
let assistantID = "your-assistant-id"
var context: MessageContext? // save context to continue the conversation later

// First, create the session for a new conversation
assistant.createSession(assistantID: assistantID) { response, error in
	if let error = error {
        print(error)
    }
    guard let session = response?.result else {
        print("Failed to create a session")
        return
    }

    beginConversation(sessionID: session.sessionID)
}

// Start a conversation with the Assistant service
func beginConversation(sessionID: String) {
    assistant.message(assistantID: assistantID, sessionID: sessionID) { response, error in
	    if let error = error {
	        print(error)
	    }
	    guard let message = response?.result else {
	        print("Failed to get the message")
	        return
	    }
        context = message.context
        message.output.generic?.forEach({ response in
            print(response.text ?? "No response")
        })
        respond(sessionID: sessionID) // See the next code snippet
    }
}
```

The following example shows how to continue an existing conversation with the Assistant service:

```swift
func respond(sessionID: String) {
    let messageInput = MessageInput(
		messageType: MessageInput.MessageType.text.rawValue,
		text: "Turn on the radio"
	)
    assistant.message(
        assistantID: assistantID,
        sessionID: sessionID, 
        input: messageInput, 
        context: context) { response, error in
		
		if let error = error {
			print(error)
		}
		guard let message = response?.result else {
			print("Failed to get the message")
			return
		}
		context = message.context
		message.output.generic?.forEach({
			response in
			print(response.text ?? "No response")
		})
	}
}
```

### Skills

The Assistant service allows users to configure "skills" in their application's payload.
For example, a session that guides users through a pizza order might include a property for pizza size: `"pizza_size": "large"`.

The following example shows how to get and set a user-defined `pizza_size` property:

```swift
// Get the `pizza_size` property
let messageInput = MessageInput(
	messageType: MessageInput.MessageType.text.rawValue,
	text: "Order a pizza"
)
assistant.message(
    assistantID: assistantID,
    sessionID: sessionID,
    input: messageInput,
    context: context) { response, error in

	if let error = error {
        print(error)
    }
    guard let message = response?.result else {
        print("Failed to get the message")
        return
    }
    if case let JSON.string(pizzaSize)? = message.context?.skills?.additionalProperties["pizza_size"] {
        print(pizzaSize)
    }
}

// Set the `pizza_size` property
assistant.message(
    assistantID: assistantID,
    sessionID: sessionID,
    input: messageInput,
    context: context) { response, error in

	if let error = error {
        print(error)
    }
    guard let message = response?.result else {
        print("Failed to get the message")
        return
    }
    var context = message.context
    context?.skills?.additionalProperties["pizza_size"] = JSON.string("large")
}
```

### Additional resources

The following links provide more information about the IBM Watson Assistant service:

* [IBM Watson Assistant - Service Page](https://www.ibm.com/cloud/watson-assistant/)
* [IBM Watson Assistant - Documentation](https://console.bluemix.net/docs/services/assistant/index.html#about)
