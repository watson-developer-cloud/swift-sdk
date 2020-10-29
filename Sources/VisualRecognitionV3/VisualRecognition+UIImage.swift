/**
 * (C) Copyright IBM Corp. 2018, 2019.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

#if os(iOS) || os(tvOS) || os(watchOS)

import Foundation
import UIKit
import IBMSwiftSDKCore

// This extension adds convenience methods for using `UIImage`. The comments and interface were copied from
// `VisualRecognition.swift`, then modified to use `UIImage` instead of `URL`. Some parameters were also
// removed or modified because they are not necessary in this context (e.g. `imagesFileContentType`).

extension VisualRecognition {

    /**
      Classify images.

      Classify images with built-in or custom classifiers.

      - parameter image: An image to classify. Since the service limits images to 10MB, the image will be compressed.
         For greater control over the image's compression, you should compress the image yourself, save it to a file,
         and call the other `classify` method.
      - parameter url: A string with the image URL to analyze. Must be in .jpg, or .png format. The minimum recommended
         pixel density is 32X32 pixels per inch, and the maximum image size is 10 MB. You can also include images
         in the `imagesFile` parameter.
      - parameter threshold: A floating point value that specifies the minimum score a class must have to be displayed
         in the response. The default threshold for returning scores from a classifier is `0.5`. Set the threshold
         to `0.0` to ignore the classification score and return all values.
      - parameter owners: An array of the categories of classifiers to apply. Use `IBM` to classify against the `default`
         general classifier, and use `me` to classify against your custom classifiers. To analyze the image against
         both classifier categories, set the value to both `IBM` and `me`. The built-in `default` classifier is
         used if both `classifierIDs` and `owners` parameters are empty. The `classifierIDs` parameter
         overrides `owners`, so make sure that `classifierIDs` is empty.
      - parameter classifierIDs: Specifies which classifiers to apply and overrides the `owners` parameter. You can
         specify both custom and built-in classifiers. The built-in `default` classifier is used if both
         `classifier_ids` and `owners` parameters are empty.  The following built-in classifier IDs
         require no training:
         - `default`: Returns classes from thousands of general tags.
         - `food`: (Beta) Enhances specificity and accuracy for images of food items.
         - `explicit`: (Beta) Evaluates whether the image might be pornographic.
      - parameter acceptLanguage: Specifies the language of the output class names.  Can be `en` (English), `ar`
         (Arabic), `de` (German), `es` (Spanish), `it` (Italian), `ja` (Japanese), or `ko` (Korean).  Classes for
         which no translation is available are omitted.  The response might not be in the specified language under
         these conditions:
         - English is returned when the requested language is not supported.
         - Classes are not returned when there is no translation for them.
         - Custom classifiers returned with this method return tags in the language of the custom classifier.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func classify(
        image: UIImage,
        threshold: Double? = nil,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        acceptLanguage: String? = nil,
        completionHandler: @escaping (WatsonResponse<ClassifiedImages>?, WatsonError?) -> Void) {
        // convert UIImage to Data
        guard let imageData = getImageData(image: image) else {
            let error = WatsonError.serialization(values: "image to data")
            completionHandler(nil, error)
            return
        }

        self.classify(
            imagesFile: imageData,
            imagesFilename: "image.png",
            threshold: threshold,
            owners: owners,
            classifierIDs: classifierIDs,
            acceptLanguage: acceptLanguage,
            completionHandler: completionHandler
        )
    }

    /**
     Classify an image using a Core ML model from the local filesystem.

     - parameter image: The image to classify.
     - parameter classifierIDs: A list of the classifier ids to use. "default" is the id of the
     built-in classifier.
     - parameter threshold: The minimum score a class must have to be displayed in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, *)
    public func classifyWithLocalModel(
        image: UIImage,
        classifierIDs: [String] = ["default"],
        threshold: Double? = nil,
        completionHandler: @escaping (ClassifiedImages?, WatsonError?) -> Void) {
        // convert UIImage to Data
        guard let imageData = getImageData(image: image) else {
            let error = WatsonError.serialization(values: "image to data")
            completionHandler(nil, error)
            return
        }

        self.classifyWithLocalModel(imageData: imageData, classifierIDs: classifierIDs, threshold: threshold, completionHandler: completionHandler)
    }

    /**
     Convert UIImage to Data
     */
    private func getImageData(image: UIImage) -> Data? {
        return image.pngData()
    }
}

#endif
