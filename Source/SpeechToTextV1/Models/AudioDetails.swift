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

/** AudioDetails. */
public struct AudioDetails: Decodable {

    /**
     The type of the audio resource:
     * `audio` for an individual audio file
     * `archive` for an archive (**.zip** or **.tar.gz**) file that contains audio files
     * `undetermined` for a resource that the service cannot validate (for example, if the user mistakenly passes a file
     that does not contain audio, such as a JPEG file).
     */
    public enum ModelType: String {
        case audio = "audio"
        case archive = "archive"
        case undetermined = "undetermined"
    }

    /**
     **For an archive-type resource,** the format of the compressed archive:
     * `zip` for a **.zip** file
     * `gzip` for a **.tar.gz** file
     Omitted for an audio-type resource.
     */
    public enum Compression: String {
        case zip = "zip"
        case gzip = "gzip"
    }

    /**
     The type of the audio resource:
     * `audio` for an individual audio file
     * `archive` for an archive (**.zip** or **.tar.gz**) file that contains audio files
     * `undetermined` for a resource that the service cannot validate (for example, if the user mistakenly passes a file
     that does not contain audio, such as a JPEG file).
     */
    public var type: String?

    /**
     **For an audio-type resource,** the codec in which the audio is encoded. Omitted for an archive-type resource.
     */
    public var codec: String?

    /**
     **For an audio-type resource,** the sampling rate of the audio in Hertz (samples per second). Omitted for an
     archive-type resource.
     */
    public var frequency: Int?

    /**
     **For an archive-type resource,** the format of the compressed archive:
     * `zip` for a **.zip** file
     * `gzip` for a **.tar.gz** file
     Omitted for an audio-type resource.
     */
    public var compression: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case codec = "codec"
        case frequency = "frequency"
        case compression = "compression"
    }

}
