# Watson Assistant

With the IBM Watson Assistant service you can create cognitive agents: virtual agents 
that combine machine learning, natural language understanding, and integrated dialog scripting tools 
to provide conversation flows between your apps and your users.

### Starting a conversation

The following example shows how to start a conversation with the Assistant service:

```swift
let username = "your-username-here"
let password = "your-password-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let assistant = Assistant(username: username, password: password, version: version)

let assistantID = "your-assistant-id-here"
let failure = { (error: Error) in print(error) }
var context: MessageContext? // save context to continue the conversation

// First, create the session for a new conversation
assistant.createSession(assistantID: assistantID, failure: failure) {
    response in

    beginConversation(sessionID: response.sessionID)
}

// Start a conversation with the Assistant service
func beginConversation(sessionID: String) {

    assistant.message(assistantID: assistantID, sessionID: sessionID, failure: failure) {
        response in
        context = response.context
        response.output.generic?.forEach({
            response in
            print(response.text ?? "No response")
        })
        respond(sessionID: sessionID) // See the next code snippet
    }
}
```

The following example shows how to continue an existing conversation with the Assistant service:

```swift
func respond(sessionID: String) {

    let messageInput = MessageInput(messageType: MessageInput.MessageType.text.rawValue, text: "Turn on the radio.")
    assistant.message(
        assistantID: assistantID,
        sessionID: sessionID, 
        input: messageInput, 
        context: context, 
        failure: failure) 
    {
        response in
        context = response.context
        response.output.generic?.forEach({
            response in
            print(response.text ?? "No response")
        })
    }
}
```

### Skills

The Assistant service allows users to configure "skills" in their application's payload, like ordering a pizza.
For example, a session that guides users through a pizza order might include a property for pizza size: `"pizza_size": "large"`.

The following example shows how to get and set a user-defined `pizza_size` property:

```swift
// Get the `pizza_size` property
let messageInput = MessageInput(messageType: MessageInput.MessageType.text.rawValue, text: "Order a pizza")
assistant.message(
    assistantID: assistantID,
    sessionID: "sessionID",
    input: messageInput,
    context: context,
    failure: failure)
{
    response in
    if case let .string(size)? = response.context?.skills?.additionalProperties["pizza_size"] {
        print(size)
    }
}

// Set the `pizza_size` property
assistant.message(
    assistantID: assistantID,
    sessionID: "sessionID",
    input: messageInput,
    context: context,
    failure: failure)
{
    response in
    var context = response.context
    context?.skills?.additionalProperties["pizza_size"] = .string("large")
}
```

For reference, the `JSON` type is defined as:

```swift
/// A JSON value (one of string, number, object, array, true, false, or null).
public enum JSON: Equatable, Codable {
    case null
    case boolean(Bool)
    case string(String)
    case int(Int)
    case double(Double)
    case date(Date)
    case array([JSON])
    case object([String: JSON])
}
```

### Additional resources

The following links provide more information about the IBM Watson Assistant service:

* [IBM Watson Assistant - Service Page](https://www.ibm.com/watson/services/conversation/)
* [IBM Watson Assistant - Documentation](https://console.bluemix.net/docs/services/conversation/index.html)
