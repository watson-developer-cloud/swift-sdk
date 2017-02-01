/**
 * Copyright IBM Corporation 2016-2017
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
import AudioToolbox

internal class TextToSpeechDecoder {
    
    private typealias opus_decoder = OpaquePointer
    
    private var audioData: Data
    
//    private var buffer: oggpack_buffer
    private var page: ogg_page
    private var streamState: ogg_stream_state    // state of ogg stream?
    private var packet: ogg_packet          // packet within a stream passing information
    private var syncState: ogg_sync_state        // state of ogg sync
    private var beginStream: true
    
    convenience init(data: Data) {
        self.audioData = data
        
    }
    
    init() throws {
        // set properties
        
        // initialize ogg sync state 
        ogg_sync_init(&syncState)
        var processedByteCount = 0 // guarantee data is pulled from stream.
        var audioDataSize = audioData.count
        
        // write into buffer of size __
        var bufferSize: Int
        var bufferData: UnsafeMutablePointer<Int8>
        
        if audioData.count < 255 {
            bufferSize = 255
        } else {
            bufferSize = audioData.count - processedByteCount
        }
//        let range = Range(uncheckedBounds: (lower: processedByteCount, upper: bufferSize))
        bufferData = ogg_sync_buffer(&syncState, bufferSize)
        
        for index in processedByteCount..<bufferSize+processedByteCount {
            bufferData[index] = Int8(audioData[index])
        }
        processedByteCount += bufferSize
        /// Advance pointer to end of processed data
        ogg_sync_wrote(&syncState, bufferSize)
        
        let receivedData = ogg_sync_pageout(&syncState, &page)
        while (receivedData == 1) {
            if beginStream {
                /// Assign stream's number with the page.
                ogg_stream_init(&streamState, ogg_page_serialno(&page))
                beginStream = false
            }
            /// If ogg page's serial number does not match stream's serial number
            /// reset stream's serial number because.... ___
            if (ogg_page_serialno(&page) != Int32(streamState.serialno)) {
                ogg_stream_reset_serialno(&streamState, ogg_page_serialno(&page))
            }
        }
        
        // initialize ogg stream state to allocate memory to decode. Returns 0 if successful.
        let status = ogg_stream_init(&streamState, serial)
        guard status == 0 else {
            throw OpusError.internalError
        }
        // build buffer.
        
    }
    
}

// MARK: - OpusError
internal enum OpusError: Error {
    case ok
    case badArgument
    case bufferTooSmall
    case internalError
    case invalidPacket
    case unimplemented
    case invalidState
    case allocationFailure
    
    var rawValue: Int32 {
        switch self {
        case .ok: return OPUS_OK
        case .badArgument: return OPUS_BAD_ARG
        case .bufferTooSmall: return OPUS_BUFFER_TOO_SMALL
        case .internalError: return OPUS_INTERNAL_ERROR
        case .invalidPacket: return OPUS_INVALID_PACKET
        case .unimplemented: return OPUS_UNIMPLEMENTED
        case .invalidState: return OPUS_INVALID_STATE
        case .allocationFailure: return OPUS_ALLOC_FAIL
        }
    }
    
    init?(rawValue: Int32) {
        switch rawValue {
        case OPUS_OK: self = .ok
        case OPUS_BAD_ARG: self = .badArgument
        case OPUS_BUFFER_TOO_SMALL: self = .bufferTooSmall
        case OPUS_INTERNAL_ERROR: self = .internalError
        case OPUS_INVALID_PACKET: self = .invalidPacket
        case OPUS_UNIMPLEMENTED: self = .unimplemented
        case OPUS_INVALID_STATE: self = .invalidState
        case OPUS_ALLOC_FAIL: self = .allocationFailure
        default: return nil
        }
    }
}
