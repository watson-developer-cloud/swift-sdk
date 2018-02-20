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
public struct AudioDetails {

    /// The type of the audio resource: * `audio` for an individual audio file * `archive` for an archive (**.zip** or **.tar.gz**) file that contains audio files.
    public enum ModelType: String {
        case audio = "audio"
        case archive = "archive"
    }

    /// **For an archive-type resource,** the format of the compressed archive: * `zip` for a **.zip** file * `gzip` for a **.tar.gz** file   Omitted for an audio-type resource.
    public enum Compression: String {
        case zip = "zip"
        case gzip = "gzip"
    }

    /// The type of the audio resource: * `audio` for an individual audio file * `archive` for an archive (**.zip** or **.tar.gz**) file that contains audio files.
    public var type: String

    /// **For an audio-type resource,** the codec in which the audio is encoded. Omitted for an archive-type resource.
    public var codec: String?

    /// **For an audio-type resource,** the sampling rate of the audio in Hertz (samples per second). Omitted for an archive-type resource.
    public var frequency: Int?

    /// **For an archive-type resource,** the format of the compressed archive: * `zip` for a **.zip** file * `gzip` for a **.tar.gz** file   Omitted for an audio-type resource.
    public var compression: String?

    /**
     Initialize a `AudioDetails` with member variables.

     - parameter type: The type of the audio resource: * `audio` for an individual audio file * `archive` for an archive (**.zip** or **.tar.gz**) file that contains audio files.
     - parameter codec: **For an audio-type resource,** the codec in which the audio is encoded. Omitted for an archive-type resource.
     - parameter frequency: **For an audio-type resource,** the sampling rate of the audio in Hertz (samples per second). Omitted for an archive-type resource.
     - parameter compression: **For an archive-type resource,** the format of the compressed archive: * `zip` for a **.zip** file * `gzip` for a **.tar.gz** file   Omitted for an audio-type resource.

     - returns: An initialized `AudioDetails`.
    */
    public init(type: String, codec: String? = nil, frequency: Int? = nil, compression: String? = nil) {
        self.type = type
        self.codec = codec
        self.frequency = frequency
        self.compression = compression
    }
}

extension AudioDetails: Codable {

    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case codec = "codec"
        case frequency = "frequency"
        case compression = "compression"
        static let allValues = [type, codec, frequency, compression]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        codec = try container.decodeIfPresent(String.self, forKey: .codec)
        frequency = try container.decodeIfPresent(Int.self, forKey: .frequency)
        compression = try container.decodeIfPresent(String.self, forKey: .compression)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(codec, forKey: .codec)
        try container.encodeIfPresent(frequency, forKey: .frequency)
        try container.encodeIfPresent(compression, forKey: .compression)
    }

}
