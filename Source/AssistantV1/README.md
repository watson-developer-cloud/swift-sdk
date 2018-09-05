# Watson Assistant

With the IBM Watson Assistant service you can create cognitive agents--virtual agents that combine machine learning, natural language understanding, and integrated dialog scripting tools to provide outstanding customer engagements.

The following example shows how to start a conversation with the Assistant service:

```swift
import AssistantV1

let username = "your-username-here"
let password = "your-password-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let assistant = Assistant(username: username, password: password, version: version)

let workspaceID = "your-workspace-id-here"
let failure = { (error: Error) in print(error) }
var context: Context? // save context to continue conversation
assistant.message(workspaceID: workspaceID, failure: failure) {
    response in
    print(response.output.text)
    context = response.context
}
```

The following example shows how to continue an existing conversation with the Assistant service:

```swift
let input = InputData(text: "Turn on the radio.")
let request = MessageRequest(input: input, context: context)
let failure = { (error: Error) in print(error) }
assistant.message(workspaceID: workspaceID, request: request, failure: failure) {
    response in
    print(response.output.text)
    context = response.context
}
```

### Context Variables

The Assistant service allows users to define custom context variables in their application's payload. For example, a workspace that guides users through a pizza order might include a context variable for pizza size: `"pizza_size": "large"`.

Context variables are get/set using the `var additionalProperties: [String: JSON]` property of a `Context` model. The following example shows how to get and set a user-defined `pizza_size` variable:

```swift
// get the `pizza_size` context variable
assistant.message(workspaceID: workspaceID, request: request, failure: failure) {
    response in
    if case let .string(size) = response.context.additionalProperties["pizza_size"]! {
        print(size)
    }
}

// set the `pizza_size` context variable
assistant.message(workspaceID: workspaceID, request: request, failure: failure) {
    response in
    var context = response.context // `var` makes the context mutable
    context?.additionalProperties["pizza_size"] = .string("large")
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
    case array([JSON])
    case object([String: JSON])
}
```

The following links provide more information about the IBM Watson Assistant service:

* [IBM Watson Assistant - Service Page](https://www.ibm.com/watson/services/conversation/)
* [IBM Watson Assistant - Documentation](https://console.bluemix.net/docs/services/conversation/index.html)
