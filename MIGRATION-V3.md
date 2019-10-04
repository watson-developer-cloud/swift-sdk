# Migrating to `swift-sdk`@3.0.0

## Breaking Changes

- [New Authentication Scheme](#new-authentication-scheme)
- [Breaking changes by service](#breaking-changes-by-service)
- [iOS minimum deployment target](#ios-deployment-target)
- [Speech to Text Cloud Foundry Web Socket support](#stt-cloudfoundry-websocket-support)
- [Dropping Swift 4.1 support](#swift-4.1-support)

### New Authentication Scheme

We have implemented a new way to authenticate for all services. We now provide `Authenticator`s that are used to authenticate behind-the-scenes. This requires a minor change to the initialization of a service class.

Below is an example of the difference between the old and new method, using IAM authentication (the default authentication type for most services on the public IBM Cloud) as an example:

OLD VERSION (swift-sdk@2.3.0 and earlier):
```swift
// NOTE: this is the OLD version which no longer works!!!
import NaturalLanguageClassifierV1

let naturalLanguageClassifier = NaturalLanguageClassifier(apiKey: "apikey")
```

NEW VERSION (swift-sdk@3.0.0 and beyond):
```swift
import NaturalLanguageClassifierV1

let authenticator = WatsonIAMAuthenticator(apiKey: "apikey")
let naturalLanguageClassifier = NaturalLanguageClassifier(authenticator: authenticator)
```

Additionally, the new authentication format for service instances that are on Cloud Foundry would now look like:

```swift
import NaturalLanguageClassifierV1

let authenticator = WatsonBasicAuthenticator(username: "username", password: "password")
let naturalLanguageClassifier = NaturalLanguageClassifier(authenticator: authenticator)
```

### Changes by service
For detailed listings of what specifically has changed in the various service wrappers and models, see the [CHANGELOG](https://github.com/watson-developer-cloud/swift-sdk/blob/master/CHANGELOG.md)

### iOS Deployment Target

The minimum iOS Deployment target has been raised to `iOS 10.0`

### STT CloudFoundry Websocket support

Websocket support for Speech to Text Cloud Foundry instances has been dropped. Please migrate your service instance to a Resource Controller instance which uses IAM authentication.

### Swift 4.1 support

We no longer support Swift 4.1. The SDK may continue to work on this version, as Swift does maintain strong source compatibility, but we are no longer actively testing against that version and cannot guarantee that the Swift SDK will work.