# Visual Recognition

The IBM Watson Visual Recognition service uses deep learning algorithms to analyze images (.jpg or .png) for scenes, objects, faces, text, and other content, and return keywords that provide information about that content. The service comes with a set of built-in classes so that you can analyze images with high accuracy right out of the box. You can also train custom classifiers to create specialized classes.

The following example demonstrates how to use the Visual Recognition service:

```swift
import VisualRecognitionV3

let apiKey = "your-apikey-here"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)

let url = "your-image-url"
let failure = { (error: Error) in print(error) }
visualRecognition.classify(image: url, failure: failure) { classifiedImages in
    print(classifiedImages)
}
```

Note: a different initializer is used for authentication with instances created before May 23, 2018:
```swift
let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
```

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
let failure = { (error: Error) in print(error) }
visualRecognition.updateLocalModel(classifierID: classifierID, failure: failure) {
    print("model updated")
}
```

The following example demonstrates how to list the Core ML models that are stored in the filesystem and available for offline use:

```swift
let localModels = try! visualRecognition.listLocalModels()
print(localModels)
```

If you would prefer to bypass `classifyWithLocalModel` and construct your own Core ML classification request, then you can retrieve a Core ML model from the local filesystem with the following example.
```swift
let classifierID = "your-classifier-id"
let localModel = try! visualRecognition.getLocalModel(classifierID: classifierID)
print(localModel)
```

The following example demonstrates how to delete a local Core ML model from the filesystem. This saves space when the model is no longer needed.
```swift
let classifierID = "your-classifier-id"
visualRecognition.deleteLocalModel(classifierID: classifierID)
```

### Bundling a model directly with your application
You may also choose to include a Core ML model with your application, enabling images to be classified offline without having to download a model first. To include a model, add it to your application bundle following the naming convention [classifier_id].mlmodel. This will enable the SDK to locate the model when using any function that accepts a classifierID argument.

The following links provide more information about the IBM Watson Visual Recognition service:

* [IBM Watson Visual Recognition - Service Page](https://www.ibm.com/watson/services/visual-recognition/)
* [IBM Watson Visual Recognition - Documentation](https://console.bluemix.net/docs/services/visual-recognition/index.html)
* [IBM Watson Visual Recognition - Demo](https://visual-recognition-demo.ng.bluemix.net/)

