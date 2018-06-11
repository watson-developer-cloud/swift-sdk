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
public struct RecognitionJob: Decodable {

    /**
     The current status of the job:
     * `waiting`: The service is preparing the job for processing. The service returns this status when the job is
     initially created or when it is waiting for capacity to process the job. The job remains in this state until the
     service has the capacity to begin processing it.
     * `processing`: The service is actively processing the job.
     * `completed`: The service has finished processing the job. If the job specified a callback URL and the event
     `recognitions.completed_with_results`, the service sent the results with the callback notification; otherwise, you
     must retrieve the results by checking the individual job.
     * `failed`: The job failed.
     */
    public enum Status: String {
        case waiting = "waiting"
        case processing = "processing"
        case completed = "completed"
        case failed = "failed"
    }

    /**
     The ID of the asynchronous job.
     */
    public var id: String

    /**
     The current status of the job:
     * `waiting`: The service is preparing the job for processing. The service returns this status when the job is
     initially created or when it is waiting for capacity to process the job. The job remains in this state until the
     service has the capacity to begin processing it.
     * `processing`: The service is actively processing the job.
     * `completed`: The service has finished processing the job. If the job specified a callback URL and the event
     `recognitions.completed_with_results`, the service sent the results with the callback notification; otherwise, you
     must retrieve the results by checking the individual job.
     * `failed`: The job failed.
     */
    public var status: String

    /**
     The date and time in Coordinated Universal Time (UTC) at which the job was created. The value is provided in full
     ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
     */
    public var created: String

    /**
     The date and time in Coordinated Universal Time (UTC) at which the job was last updated by the service. The value
     is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`). This field is returned only by the **Check jobs**
     and **Check a job** methods.
     */
    public var updated: String?

    /**
     The URL to use to request information about the job with the **Check a job** method. This field is returned only by
     the **Create a job** method.
     */
    public var url: String?

    /**
     The user token associated with a job that was created with a callback URL and a user token. This field can be
     returned only by the **Check jobs** method.
     */
    public var userToken: String?

    /**
     If the status is `completed`, the results of the recognition request as an array that includes a single instance of
     a `SpeechRecognitionResults` object. This field is returned only by the **Check a job** method.
     */
    public var results: [SpeechRecognitionResults]?

    /**
     An array of warning messages about invalid parameters included with the request. Each warning includes a
     descriptive message and a list of invalid argument strings, for example, `"unexpected query parameter 'user_token',
     query parameter 'callback_url' was not specified"`. The request succeeds despite the warnings. This field can be
     returned only by the **Create a job** method.
     */
    public var warnings: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case status = "status"
        case created = "created"
        case updated = "updated"
        case url = "url"
        case userToken = "user_token"
        case results = "results"
        case warnings = "warnings"
    }

}
