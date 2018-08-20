/**
 * Copyright IBM Corporation 2018
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
import RestKit

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
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func classify(
        image: UIImage,
        threshold: Double? = nil,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        acceptLanguage: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // save image to disk
        let file: URL
        do {
            file = try saveToDisk(image: image)
        } catch {
            failure?(error)
            return
        }

        // delete image after service call
        let deleteFile = { try? FileManager.default.removeItem(at: file) }
        let failureWithDelete = { (error: Error) in deleteFile(); failure?(error) }
        let successWithDelete = { (classifiedImages: ClassifiedImages) in deleteFile(); success(classifiedImages) }

        self.classify(
            imagesFile: file,
            url: nil,
            threshold: threshold,
            owners: owners,
            classifierIDs: classifierIDs,
            acceptLanguage: acceptLanguage,
            failure: failureWithDelete,
            success: successWithDelete
        )
    }

    /**
     Detect faces in images.

     Analyze and get data about faces in images. Responses can include estimated age and gender, and the service can
     identify celebrities. This feature uses a built-in classifier, so you do not train it on custom classifiers. The
     Detect faces method does not support general biometric facial recognition.

     - parameter imagesFile: An image file (.jpg, .png) or .zip file with images. Include no more than 15 images. You
        can also include images with the `url` parameter.  All faces are detected, but if there are more than 10 faces
        in an image, age and gender confidence scores might return scores of 0.
     - url: A string with the image URL to analyze. Must be in .jpg, or .png format. The minimum recommended
        pixel density is 32X32 pixels per inch, and the maximum image size is 10 MB. You can also include images
        in the `imagesFile` parameter.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func detectFaces(
        image: UIImage,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DetectedFaces) -> Void)
    {
        // save image to disk
        let file: URL
        do {
            file = try saveToDisk(image: image)
        } catch {
            failure?(error)
            return
        }

        // delete image after service call
        let deleteFile = { try? FileManager.default.removeItem(at: file) }
        let failureWithDelete = { (error: Error) in deleteFile(); failure?(error) }
        let successWithDelete = { (detectedFaces: DetectedFaces) in deleteFile(); success(detectedFaces) }

        self.detectFaces(imagesFile: file, url: nil, failure: failureWithDelete, success: successWithDelete)
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // convert UIImage to Data
        guard let imageData = UIImagePNGRepresentation(image) else {
            let description = "Failed to convert image from UIImage to Data."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        self.classifyWithLocalModel(imageData: imageData, classifierIDs: classifierIDs, threshold: threshold,
                                    failure: failure, success: success)
    }

    /**
     Save an image to a temporary location on disk.
     The image will be compressed in an attempt to stay under the service's 10MB image size restriction.
     */
    private func saveToDisk(image: UIImage) throws -> URL {
        let filename = UUID().uuidString + ".jpg"
        let directory = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        guard let file = directory.appendingPathComponent(filename) else { throw RestError.encodingError }
        guard let data = UIImageJPEGRepresentation(image, 0.75) else { throw RestError.encodingError }
        try data.write(to: file)
        return file
    }
}

#endif
