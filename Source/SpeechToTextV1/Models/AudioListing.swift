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

/** AudioListing. */
public struct AudioListing: Decodable {

    /**
     **For an audio-type resource,** the status of the resource:
     * `ok` indicates that the service has successfully analyzed the audio data. The data can be used to train the
     custom model.
     * `being_processed` indicates that the service is still analyzing the audio data. The service cannot accept
     requests to add new audio resources or to train the custom model until its analysis is complete.
     * `invalid` indicates that the audio data is not valid for training the custom model (possibly because it has the
     wrong format or sampling rate, or because it is corrupted).
     Omitted for an archive-type resource.
     */
    public enum Status: String {
        case ok = "ok"
        case beingProcessed = "being_processed"
        case invalid = "invalid"
    }

    /**
     **For an audio-type resource,**  the total seconds of audio in the resource. The value is always a whole number.
     Omitted for an archive-type resource.
     */
    public var duration: Double?

    /**
     **For an audio-type resource,** the user-specified name of the resource. Omitted for an archive-type resource.
     */
    public var name: String?

    /**
     **For an audio-type resource,** an `AudioDetails` object that provides detailed information about the resource. The
     object is empty until the service finishes processing the audio. Omitted for an archive-type resource.
     */
    public var details: AudioDetails?

    /**
     **For an audio-type resource,** the status of the resource:
     * `ok` indicates that the service has successfully analyzed the audio data. The data can be used to train the
     custom model.
     * `being_processed` indicates that the service is still analyzing the audio data. The service cannot accept
     requests to add new audio resources or to train the custom model until its analysis is complete.
     * `invalid` indicates that the audio data is not valid for training the custom model (possibly because it has the
     wrong format or sampling rate, or because it is corrupted).
     Omitted for an archive-type resource.
     */
    public var status: String?

    /**
     **For an archive-type resource,** an object of type `AudioResource` that provides information about the resource.
     Omitted for an audio-type resource.
     */
    public var container: AudioResource?

    /**
     **For an archive-type resource,** an array of `AudioResource` objects that provides information about the
     audio-type resources that are contained in the resource. Omitted for an audio-type resource.
     */
    public var audio: [AudioResource]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case duration = "duration"
        case name = "name"
        case details = "details"
        case status = "status"
        case container = "container"
        case audio = "audio"
    }

}
