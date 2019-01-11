# Compare and Comply

Watson Compare & Comply extracts data and elements from your contracts and other governing documents to streamline business processes.

The following example shows how to generate an analysis of a document's structural and semantic elements:

```swift
import CompareComplyV1

let apiKey = "your-api-key"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let compareComply = CompareComply(version: version, apiKey: apiKey)

let contractA = URL(fileURLWithPath: "./Documents/ContractA.pdf")
compareComply.classifyElements(file: contractA) {
    response, error in

    if let error = error {
        print(error)
    }
    guard let classification = response?.result else {
        print("Failed to get the message")
        return
    }
    
    print(classification)
}
```


The following links provide more information about the IBM Watson Compare and Comply service:

* [IBM Watson Compare & Comply - Service Page](https://www.ibm.com/cloud/compare-and-comply)
* [IBM Watson Compare & Comply - Documentation](https://console.bluemix.net/docs/services/compare-comply/index.html#about)
