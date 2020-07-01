# Discovery V2

* [IBM Discovery V2 - API Reference](https://cloud.ibm.com/apidocs/discovery-data?code=swift)
* [IBM Discovery V2 - Documentation](https://cloud.ibm.com/docs/discovery/index.html)
* [IBM Discovery V2 - Service Page](https://www.ibm.com/cloud/watson-discovery)

**IMPORTANT:** `DiscoveryV2` is only available on [IBM Cloud Pak for Data.](https://www.ibm.com/products/cloud-pak-for-data) If you are using Discovery on the public IBM Cloud, see `DiscoveryV1`.

IBM Watson Discovery makes it possible to rapidly build cognitive, cloud-based exploration applications that unlock actionable insights hidden in unstructured data — including your own proprietary data, as well as public and third-party data. With Discovery, it only takes a few steps to prepare your unstructured data, create a query that will pinpoint the information you need, and then integrate those insights into your new application or existing solution.

Once you have a project a Discovery instance (managed via the Discovery tooling UI or API), you can query your collection with the following example.

```swift
import DiscoveryV2

let authenticator = WatsonCloudPakForDataAuthenticator(username: username, password: password, url: url)

let discovery = Discovery(version: "2019-11-29", authenticator: authenticator)
discovery.serviceURL = "{url}"

discovery.query(projectID: "{project_id}") {
  response, error in
  
  guard let results = response?.result else {
    print(error?.localizedDescription ?? "unexpected error")
    return
  }

  print(results)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/discovery-data?code=swift)
