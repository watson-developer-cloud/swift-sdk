# Discovery V1

* [IBM Discovery V1 - API Reference](https://cloud.ibm.com/apidocs/discovery?code=swift)
* [IBM Discovery V1 - Documentation](https://cloud.ibm.com/docs/discovery/index.html)
* [IBM Discovery V1 - Service Page](https://www.ibm.com/cloud/watson-discovery)

IBM Watson Discovery makes it possible to rapidly build cognitive, cloud-based exploration applications that unlock actionable insights hidden in unstructured data — including your own proprietary data, as well as public and third-party data. With Discovery, it only takes a few steps to prepare your unstructured data, create a query that will pinpoint the information you need, and then integrate those insights into your new application or existing solution.

Once you have a collection of documents within a Discovery instance (managed via the Discovery tooling UI or API), you can query your collection with the following example.

```swift
import DiscoveryV1

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let discovery = Discovery(version: "2019-04-30", authenticator: authenticator)
discovery.serviceURL = "{url}"

discovery.query(
  environmentID: "{environment_id}",
  collectionID: "{collection_id}",
  query: "relations.action.lemmatized:acquire")
{
  response, error in

  guard let result = response?.result else {
    print(error?.localizedDescription ?? "unexpected error")
    return
  }

  print(result)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/discovery?code=swift)
