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

internal class WAVRepair {

    /**
     Convert a big-endian byte buffer to a UTF-8 encoded string.
     - parameter data: The byte buffer that contains a big-endian UTF-8 encoded string.
     - parameter offset: The location within the byte buffer where the string begins.
     - parameter length: The length of the string (without a null-terminating character).
     - returns: A String initialized by converting the given big-endian byte buffer into
        Unicode characters using a UTF-8 encoding.
     */
    private static func dataToUTF8String(data: Data, offset: Int, length: Int) -> String? {
        let range = Range(uncheckedBounds: (lower: offset, upper: offset + length))
        let subdata = data.subdata(in: range)
        return String(data: subdata, encoding: String.Encoding.utf8)
    }

    /**
     Convert a little-endian byte buffer to a UInt32 integer.
     - parameter data: The byte buffer that contains a little-endian 32-bit unsigned integer.
     - parameter offset: The location within the byte buffer where the integer begins.
     - returns: An Int initialized by converting the given little-endian byte buffer into an unsigned 32-bit integer.
     */
    private static func dataToUInt32(data: Data, offset: Int) -> Int {
        var num: UInt8 = 0
        let length = 4
        let range = Range(uncheckedBounds: (lower: offset, upper: offset + length))
        data.copyBytes(to: &num, from: range)
        return Int(num)
    }

    /**
     Returns true if the given data is a WAV-formatted audio file.

     To verify that the data is a WAV-formatted audio file, we simply check the "RIFF" chunk
     descriptor. That is, we verify that the "ChunkID" field is "RIFF" and the "Format" is "WAVE".
     Note that this does not require the "ChunkSize" to be valid and does not guarantee that any
     sub-chunks are valid.

     - parameter data: The byte buffer that may contain a WAV-formatted audio file.
     - returns: `true` if the given data is a WAV-formatted audio file; otherwise, false.
     */
    internal static func isWAVFile(data: Data) -> Bool {

        // resources for WAV header format:
        // [1] http://unusedino.de/ec64/technical/formats/wav.html
        // [2] http://soundfile.sapp.org/doc/WaveFormat/

        let riffHeaderChunkIDOffset = 0
        let riffHeaderChunkIDSize = 4
        let riffHeaderChunkSizeOffset = 8
        let riffHeaderChunkSizeSize = 4
        let riffHeaderSize = 12

        guard data.count >= riffHeaderSize else {
            return false
        }

        let riffChunkID = dataToUTF8String(data: data, offset: riffHeaderChunkIDOffset, length: riffHeaderChunkIDSize)
        guard riffChunkID == "RIFF" else {
            return false
        }

        let riffFormat = dataToUTF8String(data: data, offset: riffHeaderChunkSizeOffset, length: riffHeaderChunkSizeSize)
        guard riffFormat == "WAVE" else {
            return false
        }

        return true
    }

    /**
     Repair the WAV header for a WAV-formatted audio file produced by Watson Text to Speech.

     - parameter data: The WAV-formatted audio file produced by Watson Text to Speech.
        The byte data will be analyzed and repaired in-place.
     */
    internal static func repairWAVHeader(data: inout Data) {

        // resources for WAV header format:
        // [1] http://unusedino.de/ec64/technical/formats/wav.html
        // [2] http://soundfile.sapp.org/doc/WaveFormat/

        // update RIFF chunk size
        let fileLength = data.count
        var riffChunkSize = UInt32(fileLength - 8)
        let riffChunkSizeData = Data(bytes: &riffChunkSize, count: MemoryLayout<UInt32>.stride)
        data.replaceSubrange(Range(uncheckedBounds: (lower: 4, upper: 8)), with: riffChunkSizeData)

        // find data subchunk
        var subchunkID: String?
        var subchunkSize = 0
        var fieldOffset = 12
        let fieldSize = 4
        while true {
            // prevent running off the end of the byte buffer
            if fieldOffset + 2*fieldSize >= data.count {
                return
            }

            // read subchunk ID
            subchunkID = dataToUTF8String(data: data, offset: fieldOffset, length: fieldSize)
            fieldOffset += fieldSize
            if subchunkID == "data" {
                break
            }

            // read subchunk size
            subchunkSize = dataToUInt32(data: data, offset: fieldOffset)
            fieldOffset += fieldSize + subchunkSize
        }

        // compute data subchunk size (excludes id and size fields)
        var dataSubchunkSize = UInt32(data.count - fieldOffset - fieldSize)

        // update data subchunk size
        let dataSubchunkSizeData = Data(bytes: &dataSubchunkSize, count: MemoryLayout<UInt32>.stride)
        data.replaceSubrange(Range(uncheckedBounds: (lower: fieldOffset, upper: fieldOffset+fieldSize)), with: dataSubchunkSizeData)
    }
}
