# Compare and Comply

* [IBM Watson Compare & Comply - API Reference](https://cloud.ibm.com/apidocs/compare-comply?code=swift)
* [IBM Watson Compare & Comply - Documentation](https://cloud.ibm.com/docs/compare-comply/index.html#about)
* [IBM Watson Compare & Comply - Service Page](https://www.ibm.com/cloud/compare-and-comply)

Watson Compare & Comply extracts data and elements from your contracts and other governing documents to streamline business processes.

The following example shows how to generate an analysis of a document's structural and semantic elements:

```swift
import CompareComplyV1

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let compareComply = CompareComply(version: "2018-10-15", authenticator: authenticator)
compareComply.serviceURL = "{url}"

let url = Bundle.main.url(forResource: "contract_A", withExtension: "pdf")!
let contract = try! Data(contentsOf: url)
compareComply.classifyElements(file: contract, fileContentType: "application/pdf") {
  response, error in

  guard let classification = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }

  print(classification)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/compare-comply?code=swift)