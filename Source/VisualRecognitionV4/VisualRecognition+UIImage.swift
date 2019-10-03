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
     Analyze images.
     Analyze images by URL, by file, or both against your own collection. Make sure that
     **training_status.objects.ready** is `true` for the feature before you use a collection to analyze images.
     Encode the image and .zip file names in UTF-8 if they contain non-ASCII characters. The service assumes UTF-8
     encoding if it encounters non-ASCII characters.
     - parameter images: an array of UIImages to be classified
     - parameter collectionIDs: The IDs of the collections to analyze. Separate multiple values with commas.
     - parameter features: The features to analyze. Separate multiple values with commas.
     - parameter threshold: The minimum score a feature must have to be returned.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func analyze(
        images: [UIImage],
        collectionIDs: [String],
        features: [String],
        threshold: Double? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<AnalyzeResponse>?, WatsonError?) -> Void)
    {

        var imageFiles = [FileWithMetadata]()

        // convert all UIImages to Data, and then to FileWithMetadata
        for image in images {
            guard let imageData = getImageData(image: image) else {
                let error = WatsonError.serialization(values: "image to data")
                completionHandler(nil, error)
                return
            }

            let imageFile = FileWithMetadata(
                data: imageData,
                filename: "image.png",
                contentType: "image/png"
            )

            imageFiles.append(imageFile)
        }

        self.analyze(
            collectionIDs: collectionIDs,
            features: features,
            imagesFile: imageFiles,
            imageURL: nil,
            threshold: threshold,
            headers: headers,
            completionHandler: completionHandler
        )
    }

    /**
     Convert UIImage to Data
     */
    private func getImageData(image: UIImage) -> Data? {
        return image.pngData()
    }
}

#endif
