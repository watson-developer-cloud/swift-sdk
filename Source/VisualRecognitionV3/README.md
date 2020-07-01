# Visual Recognition V3

* [IBM Watson Visual Recognition V3 - API Reference](https://cloud.ibm.com/apidocs/visual-recognition/visual-recognition-v3?code=swift)
* [IBM Watson Visual Recognition V3 - Documentation](https://cloud.ibm.com/docs/visual-recognition/index.html)
* [IBM Watson Visual Recognition V3 - Service Page](https://www.ibm.com/cloud/watson-visual-recognition)

The IBM Watson Visual Recognition V3 service uses deep learning algorithms to analyze images (.jpg or .png) for scenes, objects, text, and other content, and return keywords that provide information about that content. The service comes with a set of built-in classes so that you can analyze images with high accuracy right out of the box. You can also train custom classifiers to create specialized classes.

The following example demonstrates how to use the Visual Recognition service:

```swift
import VisualRecognitionV3

let authenticator = WatsonIAMAuthenticator(apiKey: "{apikey}")
let visualRecognition = VisualRecognition(version: "2018-03-19", authenticator: authenticator)
visualRecognition.serviceURL = "{url}"

let url = Bundle.main.url(forResource: "fruitbowl", withExtension: "jpg")
let fruitbowl = try? Data(contentsOf: url!)

visualRecognition.classify(imagesFile: fruitbowl, threshold: 0.6, owners: ["me"]) {
  response, error in

  guard let result = response?.result else {
    print(error?.localizedDescription ?? "unknown error")
    return
  }

  print(result)
}
```

For details on all API operations, including Swift examples, [see the API reference.](https://cloud.ibm.com/apidocs/visual-recognition/visual-recognition-v3?code=swift)

## Using Core ML

The Watson Swift SDK supports offline image classification using Apple Core ML. Classifiers must be trained or updated with the `coreMLEnabled` flag set to true. Once the classifier's `coreMLStatus` is `ready` then a Core ML model is available to download and use for offline classification.

Once the Core ML model is in the device's file system, images can be classified offline, directly on the device.

```swift
let classifierID = "your-classifier-id"
let failure = { (error: Error) in print(error) }
let image = UIImage(named: "your-image-filename")
visualRecognition.classifyWithLocalModel(image: image, classifierIDs: [classifierID], failure: failure) {
    classifiedImages in print(classifiedImages)
}
```

The local Core ML model can be updated as needed.

```swift
let classifierID = "your-classifier-id"
visualRecognition.updateLocalModel(classifierID: classifierID) { _, error in
	if let error = error {
		print(error)
	} else {
		print("model successfully updated")
	}
}
```

The following example demonstrates how to list the Core ML models that are stored in the filesystem and available for offline use:

```swift
let localModels = try? visualRecognition.listLocalModels()
print(localModels)
```

If you would prefer to bypass `classifyWithLocalModel` and construct your own Core ML classification request, then you can retrieve a Core ML model from the local filesystem with the following example.

```swift
let classifierID = "your-classifier-id"
let localModel = try? visualRecognition.getLocalModel(classifierID: classifierID)
print(localModel)
```

The following example demonstrates how to delete a local Core ML model from the filesystem. This saves space when the model is no longer needed.

```swift
let classifierID = "your-classifier-id"
try? visualRecognition.deleteLocalModel(classifierID: classifierID)
```

### Bundling a model directly with your application
You may also choose to include a Core ML model with your application, enabling images to be classified offline without having to download a model first. To include a model, add it to your application bundle following the naming convention [classifier_id].mlmodel. This will enable the SDK to locate the model when using any function that accepts a classifierID argument.

The following links provide more information about the IBM Watson Visual Recognition service:


