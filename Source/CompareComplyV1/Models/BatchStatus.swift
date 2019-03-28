/**
 * Copyright IBM Corporation 2019
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

import Foundation

/**
 The batch-request status.
 */
public struct BatchStatus: Codable, Equatable {

    /**
     The method to be run against the documents. Possible values are `html_conversion`, `element_classification`, and
     `tables`.
     */
    public enum Function: String {
        case elementClassification = "element_classification"
        case htmlConversion = "html_conversion"
        case tables = "tables"
    }

    /**
     The method to be run against the documents. Possible values are `html_conversion`, `element_classification`, and
     `tables`.
     */
    public var function: String?

    /**
     The geographical location of the Cloud Object Storage input bucket as listed on the **Endpoint** tab of your COS
     instance; for example, `us-geo`, `eu-geo`, or `ap-geo`.
     */
    public var inputBucketLocation: String?

    /**
     The name of the Cloud Object Storage input bucket.
     */
    public var inputBucketName: String?

    /**
     The geographical location of the Cloud Object Storage output bucket as listed on the **Endpoint** tab of your COS
     instance; for example, `us-geo`, `eu-geo`, or `ap-geo`.
     */
    public var outputBucketLocation: String?

    /**
     The name of the Cloud Object Storage output bucket.
     */
    public var outputBucketName: String?

    /**
     The unique identifier for the batch request.
     */
    public var batchID: String?

    /**
     Document counts.
     */
    public var documentCounts: DocCounts?

    /**
     The status of the batch request.
     */
    public var status: String?

    /**
     The creation time of the batch request.
     */
    public var created: Date?

    /**
     The time of the most recent update to the batch request.
     */
    public var updated: Date?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case function = "function"
        case inputBucketLocation = "input_bucket_location"
        case inputBucketName = "input_bucket_name"
        case outputBucketLocation = "output_bucket_location"
        case outputBucketName = "output_bucket_name"
        case batchID = "batch_id"
        case documentCounts = "document_counts"
        case status = "status"
        case created = "created"
        case updated = "updated"
    }

}
