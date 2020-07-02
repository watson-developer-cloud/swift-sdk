# Visual Recognition V4

* [IBM Watson Visual Recognition V4 - API Reference](https://cloud.ibm.com/apidocs/visual-recognition/visual-recognition-v4?code=swift)
* [IBM Watson Visual Recognition V4 - Documentation](https://cloud.ibm.com/docs/visual-recognition/index.html)
* [IBM Watson Visual Recognition V4 - Service Page](https://www.ibm.com/cloud/watson-visual-recognition)

The IBM Watson Visual Recognition V4 service uses deep learning algorithms to analyze images (.jpg or .png) for scenes, objects, text, and other content, and return keywords that provide information about that content. The service comes with a set of built-in classes so that you can analyze images with high accuracy right out of the box. You can also train custom classifiers to create specialized classes.

The following example demonstrates how to use the Visual Recognition service:

```swift
import VisualRecognitionV4

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let visualRecognition = VisualRecognition(version: "2019-02-11", authenticator: authenticator)
visualRecognition.serviceURL = "{url}"

let hondaFileURL = Bundle.main.url(forResource: "honda", withExtension: "jpg")
let hondaImageData = try? Data(contentsOf: hondaFileURL!)
let hondaImageFile = FileWithMetadata(data: hondaImageData!, filename: "honda.jpg", contentType: "image/jpg")

let diceFileURL = Bundle.main.url(forResource: "honda", withExtension: "jpg")
let diceImageData = try? Data(contentsOf: diceFileURL!)
let diceImageFile = FileWithMetadata(data: hondaImageData!, filename: "honda.jpg", contentType: "image/jpg")

visualRecognition.analyze(
  collectionIDs: "5826c5ec-6f86-44b1-ab2b-cca6c75f2fc7",
  features: ["objects"],
  imagesFile: [hondaImageFile, diceImageFile]
) {
  response, error in
  
  guard let result = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }
  
  print(result)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/visual-recognition/visual-recognition-v4?code=swift)

## Differences between version 3 and version 4

`VisualRecognitionV4` is not a 1:1 replacement of `VisualRecognitionV3`. It offers primarily object detection capabilities as opposed to image classification. Additionally, and importantly for Swift, it does not support CoreML models.

If you are trying to perform image classification or use CoreML, see `VisualRecognitionV3`.

