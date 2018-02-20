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

import Foundation

/** RecognitionJob. */
public struct RecognitionJob {

    /// The current status of the job: * `waiting`: The service is preparing the job for processing. The service returns this status when the job is initially created or when it is waiting for capacity to process the job. The job remains in this state until the service has the capacity to begin processing it. * `processing`: The service is actively processing the job. * `completed`: The service has finished processing the job. If the job specified a callback URL and the event `recognitions.completed_with_results`, the service sent the results with the callback notification; otherwise, you must retrieve the results by checking the individual job. * `failed`: The job failed.
    public enum Status: String {
        case waiting = "waiting"
        case processing = "processing"
        case completed = "completed"
        case failed = "failed"
    }

    /// The ID of the job.
    public var id: String

    /// The current status of the job: * `waiting`: The service is preparing the job for processing. The service returns this status when the job is initially created or when it is waiting for capacity to process the job. The job remains in this state until the service has the capacity to begin processing it. * `processing`: The service is actively processing the job. * `completed`: The service has finished processing the job. If the job specified a callback URL and the event `recognitions.completed_with_results`, the service sent the results with the callback notification; otherwise, you must retrieve the results by checking the individual job. * `failed`: The job failed.
    public var status: String

    /// The date and time in Coordinated Universal Time (UTC) at which the job was created. The value is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
    public var created: String

    /// The date and time in Coordinated Universal Time (UTC) at which the job was last updated by the service. The value is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`). **Note:** This field is returned only when you list information about a specific or all existing jobs.
    public var updated: String?

    /// The URL to use to request information about the job with the `GET /v1/recognitions/{id}` method. **Note:** This field is returned only when you create a new job.
    public var url: String?

    /// The user token associated with a job that was created with a callback URL and a user token. **Note:** This field can be returned only when you list information about all existing jobs.
    public var userToken: String?

    /// If the status is `completed`, the results of the recognition request as an array that includes a single instance of a `SpeechRecognitionResults` object. **Note:** This field can be returned only when you list information about a specific existing job.
    public var results: [SpeechRecognitionResults]?

    /// An array of warning messages about invalid query parameters included with the request. Each warning includes a descriptive message and a list of invalid argument strings, for example, `"unexpected query parameter 'user_token', query parameter 'callback_url' was not specified"`. The request succeeds despite the warnings. **Note:** This field can be returned only when you create a new job.
    public var warnings: [String]?

    /**
     Initialize a `RecognitionJob` with member variables.

     - parameter id: The ID of the job.
     - parameter status: The current status of the job: * `waiting`: The service is preparing the job for processing. The service returns this status when the job is initially created or when it is waiting for capacity to process the job. The job remains in this state until the service has the capacity to begin processing it. * `processing`: The service is actively processing the job. * `completed`: The service has finished processing the job. If the job specified a callback URL and the event `recognitions.completed_with_results`, the service sent the results with the callback notification; otherwise, you must retrieve the results by checking the individual job. * `failed`: The job failed.
     - parameter created: The date and time in Coordinated Universal Time (UTC) at which the job was created. The value is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
     - parameter updated: The date and time in Coordinated Universal Time (UTC) at which the job was last updated by the service. The value is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`). **Note:** This field is returned only when you list information about a specific or all existing jobs.
     - parameter url: The URL to use to request information about the job with the `GET /v1/recognitions/{id}` method. **Note:** This field is returned only when you create a new job.
     - parameter userToken: The user token associated with a job that was created with a callback URL and a user token. **Note:** This field can be returned only when you list information about all existing jobs.
     - parameter results: If the status is `completed`, the results of the recognition request as an array that includes a single instance of a `SpeechRecognitionResults` object. **Note:** This field can be returned only when you list information about a specific existing job.
     - parameter warnings: An array of warning messages about invalid query parameters included with the request. Each warning includes a descriptive message and a list of invalid argument strings, for example, `"unexpected query parameter 'user_token', query parameter 'callback_url' was not specified"`. The request succeeds despite the warnings. **Note:** This field can be returned only when you create a new job.

     - returns: An initialized `RecognitionJob`.
    */
    public init(id: String, status: String, created: String, updated: String? = nil, url: String? = nil, userToken: String? = nil, results: [SpeechRecognitionResults]? = nil, warnings: [String]? = nil) {
        self.id = id
        self.status = status
        self.created = created
        self.updated = updated
        self.url = url
        self.userToken = userToken
        self.results = results
        self.warnings = warnings
    }
}

extension RecognitionJob: Codable {

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case status = "status"
        case created = "created"
        case updated = "updated"
        case url = "url"
        case userToken = "user_token"
        case results = "results"
        case warnings = "warnings"
        static let allValues = [id, status, created, updated, url, userToken, results, warnings]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(String.self, forKey: .status)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decodeIfPresent(String.self, forKey: .updated)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        userToken = try container.decodeIfPresent(String.self, forKey: .userToken)
        results = try container.decodeIfPresent([SpeechRecognitionResults].self, forKey: .results)
        warnings = try container.decodeIfPresent([String].self, forKey: .warnings)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(status, forKey: .status)
        try container.encode(created, forKey: .created)
        try container.encodeIfPresent(updated, forKey: .updated)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(userToken, forKey: .userToken)
        try container.encodeIfPresent(results, forKey: .results)
        try container.encodeIfPresent(warnings, forKey: .warnings)
    }

}
