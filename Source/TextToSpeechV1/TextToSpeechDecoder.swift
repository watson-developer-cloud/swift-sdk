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
    private var beginStream = true
    private var pageGranulePosition: Int64 = 0     // Positiion of the packet data at page
    private var hasOpusStream = false
    private var hasTagsPacket = false
    
    convenience init(data: Data) throws {
        
        try self.init(
            audioData: data
        )
        
    }
    
    init(audioData: Data) throws {
        // set properties
        streamState = ogg_stream_state()
        syncState = ogg_sync_state()
        page = ogg_page()
        packet = ogg_packet()
        
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
            
            /// Add page to the stream.
            ogg_stream_pagein(&streamState, &page)
            
            /// Check granularity position?
            pageGranulePosition = ogg_page_granulepos(&page)
            
            /// While there's a packet, extract.
            if extractPacket(&streamState, &packet) {
                print ("yay")
            }
//            while (ogg_stream_packetout(&streamState, &packet) == 1) {
//                /// Check for initial stream header
//                if (packet.bytes >= 8 && packet.b_o_s == 1) {
//                    
//                }
//            }
            
            
            
            // initialize ogg stream state to allocate memory to decode. Returns 0 if successful.
            //        let status = ogg_stream_init(&streamState, serial)
            //        guard status == 0 else {
            //            throw OpusError.internalError
            //        }
            // build buffer.
            
        }
        
    }
    

    private func extractPacket(_ streamState: inout ogg_stream_state, _ packet: inout ogg_packet) -> Bool {
        while (ogg_stream_packetout(&streamState, &packet) == 1) {
            /// Check for initial stream header
            if (packet.bytes >= 8 && packet.b_o_s == 1 && (memcmp(packet.packet, "OpusHead", 8) == 0)) {
                /// Check if there's another opus head to see if stream is chained without EOS.
                if (hasOpusStream && hasTagsPacket) {
                    hasOpusStream = false
                    if
                }
            }
            return false
        }
        return false
    }
    
    private func processHeader(_ packet inout ogg_packet, _ rate opus_int32 *rate, int *mapping_family, int *channels, int *preskip, float *gain, float manual_gain, int *streams, int wav_format)
}
