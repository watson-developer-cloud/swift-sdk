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

internal class TextToSpeechDecoder {
    
    var pcmDataWithHeaders = Data()             // object containing the decoded pcm data with wav headers
    
    private typealias opus_decoder = OpaquePointer
    private let MAX_FRAME_SIZE = Int32(960 * 6)
    
    private var streamState: ogg_stream_state   // state of ogg stream
    private var page: ogg_page                  // encapsulates the data for an Ogg page
    private var syncState: ogg_sync_state       // tracks the status of data during decoding
    private var packet: ogg_packet              // packet within a stream passing information
    private var header: OpusHeader              // header of the Opus file to decode
    private var decoder: opus_decoder           // decoder to convert opus to pcm
    
    private var packetCount: Int64 = 0          // number of packets read during decoding
    private var beginStream = true              // if decoding of stream has begun
    private var pageGranulePosition: Int64 = 0  // position of the packet data at page
    private var hasOpusStream = false           // whether or not the opus stream has been created
    private var hasTagsPacket = false           // whether or not the tags packet has been read
    private var opusSerialNumber: Int = 0       // the assigned serial number of the opus stream
    private var linkOut: Int32 = 0              // total number of bytes written from opus stream to pcmData
    private var totalLinks: Int = 0             // a count of the number of opus streams
    private var numChannels: Int32 = 1          // number of channels
    private var pcmDataBuffer = UnsafeMutablePointer<Float>.allocate(capacity: 0)
    private var sampleRate: Int32 = 48000       // sample rate for decoding. default value by Opus is 48000
    private var preSkip: Int32 = 0              // number of samples to be skipped at beginning of stream
    private var granOffset: Int32 = 0           // where to begin reading the data from Opus
    private var frameSize: Int32 = 0            // number of samples decoded
    private var pcmData = Data()                // decoded pcm data
    
    init(audioData: Data) throws {
        // set properties
        streamState = ogg_stream_state()
        page = ogg_page()
        syncState = ogg_sync_state()
        packet = ogg_packet()
        header = OpusHeader()
        
        // status to catch errors when creating decoder
        var status = Int32(0)
        decoder = opus_decoder_create(sampleRate, numChannels, &status)
        
        // initialize ogg sync state
        ogg_sync_init(&syncState)
        var processedByteCount = 0
        
        while processedByteCount < audioData.count {
            // determine the size of the buffer to ask for
            var bufferSize: Int
            if audioData.count - processedByteCount > 200 {
                bufferSize = 200
            } else {
                bufferSize = audioData.count - processedByteCount
            }
            
            // obtain a buffer from the syncState
            var bufferData: UnsafeMutablePointer<Int8>
            bufferData = ogg_sync_buffer(&syncState, bufferSize)
            
            // write data from the service into the syncState buffer
            bufferData.withMemoryRebound(to: UInt8.self, capacity: bufferSize) { bufferDataUInt8 in
                audioData.copyBytes(to: bufferDataUInt8, from: processedByteCount..<processedByteCount + bufferSize)
            }
            processedByteCount += bufferSize
            // notify syncState of number of bytes we actually wrote
            ogg_sync_wrote(&syncState, bufferSize)
            
            // attempt to get a page from the data that we wrote
            while (ogg_sync_pageout(&syncState, &page) == 1) {
                if beginStream {
                    // assign stream's number with the page.
                    ogg_stream_init(&streamState, ogg_page_serialno(&page))
                    beginStream = false
                }
                
                if ogg_page_serialno(&page) != Int32(streamState.serialno) {
                    ogg_stream_reset_serialno(&streamState, ogg_page_serialno(&page))
                }
                
                // add page to the ogg stream
                ogg_stream_pagein(&streamState, &page)
                
                // save position of the current decoding process
                pageGranulePosition = ogg_page_granulepos(&page)
                
                // extract packets from the ogg stream until no packets are left
                try extractPacket(&streamState, &packet)
            }
        }
        
        if totalLinks == 0 {
            NSLog("Does not look like an opus file.")
            throw OpusError.invalidState
        }
        
        // add wav header
        addWAVHeader()
        
        // perform cleanup
        opus_multistream_decoder_destroy(decoder)
        if (!beginStream) {
            ogg_stream_clear(&streamState)
        }
        ogg_sync_clear(&syncState)
    }
    
    // Extract a packet from the ogg stream and store the extracted data within the packet object.
    private func extractPacket(_ streamState: inout ogg_stream_state, _ packet: inout ogg_packet) throws {
        // attempt to extract a packet from the ogg stream
        while ogg_stream_packetout(&streamState, &packet) == 1 {
            // execute if initial stream header
            if packet.b_o_s != 0 && packet.bytes >= 8 && memcmp(packet.packet, "OpusHead", 8) == 0 {
                // check if there's another opus head to see if stream is chained without EOS
                if hasOpusStream && hasTagsPacket {
                    hasOpusStream = false
                    opus_multistream_decoder_destroy(decoder)
                }
                
                // set properties if we are in a new opus stream
                if !hasOpusStream {
                    if packetCount > 0 && opusSerialNumber == streamState.serialno {
                        NSLog("Apparent chaining without changing serial number. Something bad happened.")
                        throw OpusError.internalError
                    }
                    opusSerialNumber = streamState.serialno
                    hasOpusStream = true
                    hasTagsPacket = false
                    linkOut = 0
                    packetCount = 0
                    totalLinks += 1
                } else {
                    NSLog("Warning: ignoring opus stream.")
                }
            }
            
            if !hasOpusStream || streamState.serialno != opusSerialNumber {
                break
            }
            
            // if first packet in logical stream, process header
            if packetCount == 0 {
                // create decoder from information in Opus header
                decoder = try processHeader(&packet, &numChannels, &preSkip)
                
                // Check that there are no more packets in the first page.
                let lastElementIndex = page.header_len - 1
                let lacingValue = page.header[lastElementIndex]
                // A lacing value of 255 would suggest that the packet continues on the next page.
                if ogg_stream_packetout(&streamState, &packet) != 0 || lacingValue == 255 {
                    throw OpusError.invalidPacket
                }
                
                granOffset = preSkip
                
                pcmDataBuffer = UnsafeMutablePointer<Float>.allocate(capacity: MemoryLayout<Float>.stride * Int(MAX_FRAME_SIZE) * Int(numChannels))
                
                // deallocate pcmDataBuffer when the function ends, regardless if the function ended normally or with an error.
                defer {
                    pcmDataBuffer.deallocate(capacity: MemoryLayout<Float>.stride * Int(MAX_FRAME_SIZE) * Int(numChannels))
                }
            } else if packetCount == 1 {
                hasTagsPacket = true

                let lastElementIndex = page.header_len - 1
                let lacingValue = page.header[lastElementIndex]
                if ogg_stream_packetout(&streamState, &packet) != 0 || lacingValue == 255 {
                    NSLog("Extra packets on initial tags page. Invalid stream.")
                    throw OpusError.invalidPacket
                }
            } else {
                var numberOfSamplesDecoded: Int32
                var maxOut: Int64
                var outSample: Int64
                
                // Decode opus packet.
                numberOfSamplesDecoded = opus_multistream_decode_float(decoder, packet.packet, Int32(packet.bytes), pcmDataBuffer, MAX_FRAME_SIZE, 0)
                
                if numberOfSamplesDecoded < 0 {
                    NSLog("Decoding error: \(opus_strerror(numberOfSamplesDecoded))")
                    throw OpusError.internalError
                }
                
                frameSize = numberOfSamplesDecoded
                
                // Make sure the output duration follows the final end-trim
                // Output sample count should not be ahead of granpos value.
                maxOut = ((pageGranulePosition - Int64(granOffset)) * Int64(sampleRate) / 48000) - Int64(linkOut)
                outSample = try audioWrite(&pcmDataBuffer, numChannels, frameSize, &preSkip, &maxOut)
                
                linkOut += Int32(outSample)
            }
            packetCount += 1
        }
        
    }
    
    // Process the Opus header and create a decoder with these values
    private func processHeader(_ packet: inout ogg_packet, _ channels: inout Int32, _ preskip: inout Int32) throws -> opus_decoder {
        // create status to capture errors
        var status = Int32(0)
        
        if opus_header_parse(packet.packet, Int32(packet.bytes), &header) == 0 {
            throw OpusError.invalidPacket
        }
        
        channels = header.channels
        preskip = header.preskip
        
        // update the sample rate if a reasonable one is specified in the header
        let rate = Int32(header.input_sample_rate)
        if rate >= 8000 && rate <= 192000 {
            sampleRate = rate
        }
        
        decoder = opus_multistream_decoder_create(sampleRate, channels, header.nb_streams, header.nb_coupled, &header.stream_map.0, &status)
        if status != OpusError.ok.rawValue {
            throw OpusError.badArgument
        }
        return decoder
    }
    
    // Write the decoded Opus data (now PCM) to the pcmData object
    private func audioWrite(_ pcmDataBuffer: inout UnsafeMutablePointer<Float>,
                            _ channels: Int32,
                            _ frameSize: Int32,
                            _ skip: inout Int32,
                            _ maxOut: inout Int64) throws -> Int64 {
        var sampOut: Int64 = 0
        var tmpSkip: Int32
        var outLength: UInt
        var shortOutput: UnsafeMutablePointer<CShort>
        var floatOutput: UnsafeMutablePointer<Float>
        shortOutput = UnsafeMutablePointer<CShort>.allocate(capacity: MemoryLayout<CShort>.stride * Int(MAX_FRAME_SIZE) * Int(channels))
        
        if maxOut < 0 {
            maxOut = 0
        }
        
        if skip != 0 {
            if skip > frameSize {
                tmpSkip = frameSize
            } else {
                tmpSkip = skip
            }
            skip -= tmpSkip
        } else {
            tmpSkip = 0
        }
        floatOutput = pcmDataBuffer.advanced(by: Int(channels) * Int(tmpSkip))
        
        outLength = UInt(frameSize) - UInt(tmpSkip)
        
        let maxLoop = Int(outLength) * Int(channels)
        for count in 0..<maxLoop {
            let maxMin = max(-32768, min(floatOutput.advanced(by: count).pointee * Float(32768), 32767))
            let float2int = CShort((floor(0.5 + maxMin)))
            shortOutput.advanced(by: count).initialize(to: float2int)
        }
        
        shortOutput.withMemoryRebound(to: UInt8.self, capacity: Int(outLength) * Int(channels)) { shortOutputUint8 in
            if maxOut > 0 {
                pcmData.append(shortOutputUint8, count: Int(outLength) * 2)
                sampOut = sampOut + Int64(outLength)
            }
        }
        
        return sampOut
    }
    
    // Add WAV headers to the decoded PCM data.
    // Refer to the documentation here for details: http://soundfile.sapp.org/doc/WaveFormat/
    private func addWAVHeader() {
        var header = Data()
        let headerSize = 44
        let pcmDataLength = pcmData.count
        let bitsPerSample = Int32(16)
        
        // RIFF chunk descriptor
        let chunkID = [UInt8]("RIFF".utf8)
        header.append(chunkID, count: 4)
        
        var chunkSize = Int32(pcmDataLength + headerSize - 4).littleEndian
        let chunkSizePointer = UnsafeBufferPointer(start: &chunkSize, count: 1)
        header.append(chunkSizePointer)
        
        let format = [UInt8]("WAVE".utf8)
        header.append(format, count: 4)
        
        // "fmt" sub-chunk
        let subchunk1ID = [UInt8]("fmt ".utf8)
        header.append(subchunk1ID, count: 4)
        
        var subchunk1Size = Int32(16).littleEndian
        let subchunk1SizePointer = UnsafeBufferPointer(start: &subchunk1Size, count: 1)
        header.append(subchunk1SizePointer)
        
        var audioFormat = Int16(1).littleEndian
        let audioFormatPointer = UnsafeBufferPointer(start: &audioFormat, count: 1)
        header.append(audioFormatPointer)
        
        var headerNumChannels = Int16(numChannels).littleEndian
        let headerNumChannelsPointer = UnsafeBufferPointer(start: &headerNumChannels, count: 1)
        header.append(headerNumChannelsPointer)
        
        var headerSampleRate = Int32(sampleRate).littleEndian
        let headerSampleRatePointer = UnsafeBufferPointer(start: &headerSampleRate, count: 1)
        header.append(headerSampleRatePointer)
        
        var byteRate = Int32(sampleRate * numChannels * bitsPerSample / 8).littleEndian
        let byteRatePointer = UnsafeBufferPointer(start: &byteRate, count: 1)
        header.append(byteRatePointer)
        
        var blockAlign = Int16(numChannels * bitsPerSample / 8).littleEndian
        let blockAlignPointer = UnsafeBufferPointer(start: &blockAlign, count: 1)
        header.append(blockAlignPointer)
        
        var headerBitsPerSample = Int16(bitsPerSample).littleEndian
        let headerBitsPerSamplePointer = UnsafeBufferPointer(start: &headerBitsPerSample, count: 1)
        header.append(headerBitsPerSamplePointer)
        
        // "data" sub-chunk
        let subchunk2ID = [UInt8]("data".utf8)
        header.append(subchunk2ID, count: 4)
        
        var subchunk2Size = Int32(pcmDataLength).littleEndian
        let subchunk2SizePointer = UnsafeBufferPointer(start: &subchunk2Size, count: 1)
        header.append(subchunk2SizePointer)
        
        pcmDataWithHeaders.append(header)
        pcmDataWithHeaders.append(pcmData)
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

// MARK: - OggError
internal enum OggError: Error {
    case outOfSync
    case internalError
}

