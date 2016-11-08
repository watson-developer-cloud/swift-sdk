/**
 * Copyright IBM Corporation 2016
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

internal class SpeechToTextEncoder {
    
    // This implementation uses the libopus and libogg libraries to encode and encapsulate audio.
    // For more information about these libraries, refer to their online documentation.
    // (The opus-tools source code was also helpful to verify the implementation.)
    
    private typealias opus_encoder = OpaquePointer
    
    private var stream: ogg_stream_state   // state of the ogg stream
    private var encoder: opus_encoder      // encoder to convert pcm to opus
    private var granulePosition: Int64     // total number of encoded pcm samples in the stream
    private var packetNumber: Int64        // total number of packets encoded in the stream
    private let frameSize: Int32           // number of pcm frames to encode in an opus frame (20ms)
    private let maxFrameSize: Int32 = 3832 // maximum size of an opus frame
    private let opusRate: Int32            // desired sample rate of the opus audio
    private let pcmBytesPerFrame: UInt32   // bytes per frame in the pcm audio
    private var pcmCache = Data()          // cache for pcm audio that is too short to encode
    private var oggCache = Data()          // cache for ogg stream
    
    convenience init(format: AudioStreamBasicDescription, opusRate: Int32, application: Application) throws {
        try self.init(
            pcmRate: Int32(format.mSampleRate),
            pcmChannels: Int32(format.mChannelsPerFrame),
            pcmBytesPerFrame: format.mBytesPerFrame,
            opusRate: opusRate,
            application: application
        )
    }
    
    init(pcmRate: Int32, pcmChannels: Int32, pcmBytesPerFrame: UInt32, opusRate: Int32, application: Application) throws {
        // avoid resampling
        guard pcmRate == opusRate else {
            print("Resampling is not supported. Please ensure that the PCM and Opus sample rates match.")
            throw OggError.internalError
        }

        // set properties
        self.granulePosition = 0
        self.packetNumber = 0
        self.frameSize = Int32(960 / (48000 / opusRate))
        self.opusRate = opusRate
        self.pcmBytesPerFrame = pcmBytesPerFrame
        self.pcmCache = Data()
        
        // create status to capture errors
        var status = Int32(0)
        
        // initialize ogg stream
        stream = ogg_stream_state()
        let serial = Int32(bitPattern: arc4random())
        status = ogg_stream_init(&stream, serial)
        guard status == 0 else {
            throw OggError.internalError
        }
        
        // initialize opus encoder
        encoder = opus_encoder_create(opusRate, pcmChannels, application.rawValue, &status)
        guard let error = OpusError(rawValue: status) else { throw OpusError.internalError }
        guard error == .ok else { throw error }
        
        // add opus headers to ogg stream
        try addOpusHeader(channels: UInt8(pcmChannels), rate: UInt32(pcmRate))
        try addOpusCommentHeader()
    }
    
    deinit {
        // ogg_stream_destroy(&stream)
        opus_encoder_destroy(encoder)
    }
    
    private func addOpusHeader(channels: UInt8, rate: UInt32) throws {
        // construct opus header
        let header = Header(
            outputChannels: channels,
            preskip: 0,
            inputSampleRate: rate,
            outputGain: 0,
            channelMappingFamily: .rtp
        )
        
        // convert header to a data buffer
        let headerData = header.toData()
        let packetData = UnsafeMutablePointer<UInt8>.allocate(capacity: headerData.count)
        headerData.copyBytes(to: packetData, count: headerData.count)
        
        // construct ogg packet with header
        var packet = ogg_packet()
        packet.packet = packetData
        packet.bytes = headerData.count
        packet.b_o_s = 1
        packet.e_o_s = 0
        packet.granulepos = granulePosition
        packet.packetno = Int64(packetNumber)
        packetNumber += 1
        
        // add packet to ogg stream
        let status = ogg_stream_packetin(&stream, &packet)
        guard status == 0 else {
            throw OggError.internalError
        }
        
        // deallocate header data buffer
        packetData.deallocate(capacity: headerData.count)
        
        // assemble pages and add to ogg cache
        assemblePages(flush: true)
    }
    
    private func addOpusCommentHeader() throws {
        // construct opus comment header
        let header = CommentHeader()
        let headerData = header.toData()
        let packetData = UnsafeMutablePointer<UInt8>.allocate(capacity: headerData.count)
        headerData.copyBytes(to: packetData, count: headerData.count)
        
        // construct ogg packet with comment header
        var packet = ogg_packet()
        packet.packet = packetData
        packet.bytes = headerData.count
        packet.b_o_s = 0
        packet.e_o_s = 0
        packet.granulepos = granulePosition
        packet.packetno = Int64(packetNumber)
        packetNumber += 1
        
        // add packet to ogg stream
        let status = ogg_stream_packetin(&stream, &packet)
        guard status == 0 else {
            throw OggError.internalError
        }
        
        // deallocate header data buffer
        packetData.deallocate(capacity: headerData.count)
        
        // assemble pages and add to ogg cache
        assemblePages(flush: true)
    }
    
    internal func encode(pcm: AudioQueueBuffer) throws {
        let pcmData = pcm.mAudioData.assumingMemoryBound(to: Int16.self)
        try encode(pcm: pcmData, count: Int(pcm.mAudioDataByteSize))
    }
    
    internal func encode(pcm: Data) throws {
        try pcm.withUnsafeBytes { (bytes: UnsafePointer<Int16>) in
            try encode(pcm: bytes, count: pcm.count)
        }
        
        // try encode(pcm: pcm.bytes, bytes: pcm.length)
    }
    
    internal func encode(pcm: UnsafePointer<Int16>, count: Int) throws {
        // ensure we have complete pcm frames
        guard UInt32(count) % pcmBytesPerFrame == 0 else {
            throw OpusError.internalError
        }
        
        // construct audio buffers
        var pcm = UnsafeMutablePointer<Int16>(mutating: pcm)
        var opus = Array<UInt8>(repeating: 0, count: Int(maxFrameSize))
        var count = count
        
        // encode cache, if necessary
        try encodeCache(pcm: &pcm, bytes: &count)
        
        // encode complete frames
        while count >= Int(frameSize) * Int(pcmBytesPerFrame) {
            
            // encode an opus frame
            let numBytes = opus_encode(encoder, pcm, frameSize, &opus, maxFrameSize)
            guard numBytes >= 0 else {
                throw OpusError.internalError
            }
            
            // construct ogg packet with opus frame
            var packet = ogg_packet()
            granulePosition += Int64(frameSize * 48000 / opusRate)
            packet.packet = UnsafeMutablePointer<UInt8>(mutating: opus)
            packet.bytes = Int(numBytes)
            packet.b_o_s = 0
            packet.e_o_s = 0
            packet.granulepos = granulePosition
            packet.packetno = Int64(packetNumber)
            packetNumber += 1
            
            // add packet to ogg stream
            let status = ogg_stream_packetin(&stream, &packet)
            guard status == 0 else {
                throw OggError.internalError
            }
            
            // advance pcm buffer
            let bytesEncoded = Int(frameSize) * Int(pcmBytesPerFrame)
            pcm = pcm.advanced(by: bytesEncoded / MemoryLayout<Int16>.stride)
            count = count - bytesEncoded
        }
        
        // cache remaining pcm data
        pcm.withMemoryRebound(to: UInt8.self, capacity: count) { data in
            pcmCache.append(data, count: count)
        }
    }
    
    private func encodeCache(pcm: inout UnsafeMutablePointer<Int16>, bytes: inout Int) throws {
        // ensure there is cached data
        guard pcmCache.count > 0 else {
            return
        }
        
        // ensure we can add enough pcm data for a complete frame
        guard pcmCache.count + bytes >= Int(frameSize) * Int(pcmBytesPerFrame) else {
            return
        }
        
        // append pcm data to create a complete frame
        let toAppend = Int(frameSize) * Int(pcmBytesPerFrame) - pcmCache.count
        pcm.withMemoryRebound(to: UInt8.self, capacity: toAppend) { data in
            pcmCache.append(data, count: toAppend)
        }
        
        // advance pcm buffer (modifies the inout arguments)
        pcm = pcm.advanced(by: toAppend / MemoryLayout<Int16>.stride)
        bytes = bytes - toAppend
        
        // encode an opus frame
        var opus = Array<UInt8>(repeating: 0, count: Int(maxFrameSize))
        var numBytes: opus_int32 = 0
        try pcmCache.withUnsafeBytes { (cache: UnsafePointer<Int16>) in
            numBytes = opus_encode(encoder, cache, frameSize, &opus, maxFrameSize)
            guard numBytes >= 0 else {
                throw OpusError.internalError
            }
        }
        
        // construct ogg packet with opus frame
        var packet = ogg_packet()
        granulePosition += Int64(frameSize * 48000 / opusRate)
        packet.packet = UnsafeMutablePointer<UInt8>(mutating: opus)
        packet.bytes = Int(numBytes)
        packet.b_o_s = 0
        packet.e_o_s = 0
        packet.granulepos = granulePosition
        packet.packetno = Int64(packetNumber)
        packetNumber += 1
        
        // add packet to ogg stream
        let status = ogg_stream_packetin(&stream, &packet)
        guard status == 0 else {
            throw OggError.internalError
        }
        
        // reset cache
        pcmCache = Data()
    }
    
    internal func bitstream(flush: Bool = false, fillBytes: Int32? = nil) -> Data {
        assemblePages(flush: flush, fillBytes: fillBytes)
        let bitstream = oggCache
        oggCache = Data()
        return bitstream
    }
    
    internal func endstream(fillBytes: Int32? = nil) throws -> Data {
        // compute granule position using cache
        let pcmFrames = pcmCache.count / Int(pcmBytesPerFrame)
        granulePosition += Int64(pcmFrames * 48000 / Int(opusRate))
        
        // add padding to cache to construct complete frame
        let toAppend = Int(frameSize) * Int(pcmBytesPerFrame) - pcmCache.count
        let padding = Array<UInt8>(repeating: 0, count: toAppend)
        pcmCache.append(padding, count: toAppend)
        
        // encode an opus frame
        var opus = Array<UInt8>(repeating: 0, count: Int(maxFrameSize))
        var numBytes: opus_int32 = 0
        try pcmCache.withUnsafeBytes { (cache: UnsafePointer<Int16>) in
            numBytes = opus_encode(encoder, cache, frameSize, &opus, maxFrameSize)
            guard numBytes >= 0 else {
                throw OpusError.internalError
            }
        }
        
        // construct ogg packet with opus frame
        var packet = ogg_packet()
        packet.packet = UnsafeMutablePointer<UInt8>(mutating: opus)
        packet.bytes = Int(numBytes)
        packet.b_o_s = 0
        packet.e_o_s = 1
        packet.granulepos = granulePosition
        packet.packetno = Int64(packetNumber)
        packetNumber += 1
        
        // add packet to ogg stream
        let status = ogg_stream_packetin(&stream, &packet)
        guard status == 0 else {
            throw OggError.internalError
        }
        
        return bitstream(flush: true)
    }
    
    private func assemblePages(flush: Bool = false, fillBytes: Int32? = nil) {
        var page = ogg_page()
        var status = Int32(1)
        
        // assemble pages until there is insufficient data to fill a page
        while true {
            
            // assemble accumulated packets into an ogg page
            switch (flush, fillBytes) {
            case (true, .some(let fillBytes)): status = ogg_stream_flush_fill(&stream, &page, fillBytes)
            case (true, .none): status = ogg_stream_flush(&stream, &page)
            case (false, .some(let fillBytes)): status = ogg_stream_pageout_fill(&stream, &page, fillBytes)
            case (false, .none): status = ogg_stream_pageout(&stream, &page)
            }
            
            // break when all packet data has been accumulated into pages
            guard status != 0 else {
                return
            }
            
            // add ogg page to cache
            oggCache.append(page.header, count: page.header_len)
            oggCache.append(page.body, count: page.body_len)
        }
    }
}

// MARK: - Header
private class Header {
    private(set) var magicSignature: [UInt8]
    private(set) var version: UInt8
    private(set) var outputChannels: UInt8
    private(set) var preskip: UInt16
    private(set) var inputSampleRate: UInt32
    private(set) var outputGain: Int16
    private(set) var channelMappingFamily: ChannelMappingFamily
    
    init(outputChannels: UInt8, preskip: UInt16, inputSampleRate: UInt32, outputGain: Int16, channelMappingFamily: ChannelMappingFamily) {
        self.magicSignature = [ 0x4f, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64 ] // "OpusHead"
        self.version = 1 // must always be `1` for this version of the encapsulation specification
        self.outputChannels = outputChannels
        self.preskip = preskip
        self.inputSampleRate = inputSampleRate
        self.outputGain = outputGain
        self.channelMappingFamily = channelMappingFamily
    }
    
    func toData() -> Data {
        var data = Data()
        data.append(magicSignature, count: magicSignature.count)
        withUnsafePointer(to: &version) { ptr in data.append(ptr, count: MemoryLayout<UInt8>.size) }
        withUnsafePointer(to: &outputChannels) { ptr in data.append(ptr, count: MemoryLayout<UInt8>.size) }
        withUnsafePointer(to: &preskip) { ptr in ptr.withMemoryRebound(to: UInt8.self, capacity: 1) { ptr in data.append(ptr, count: MemoryLayout<UInt16>.size) }}
        withUnsafePointer(to: &inputSampleRate) { ptr in ptr.withMemoryRebound(to: UInt8.self, capacity: 1) { ptr in data.append(ptr, count: MemoryLayout<UInt32>.size) }}
        withUnsafePointer(to: &outputGain) { ptr in ptr.withMemoryRebound(to: UInt8.self, capacity: 1) { ptr in data.append(ptr, count: MemoryLayout<UInt16>.size) }}
        withUnsafePointer(to: &channelMappingFamily) { ptr in ptr.withMemoryRebound(to: UInt8.self, capacity: 1) { ptr in data.append(ptr, count: MemoryLayout<ChannelMappingFamily>.size) }}
        return data
    }
}

// MARK: - Comment Header
private class CommentHeader {
    private(set) var magicSignature: [UInt8]
    private(set) var vendorStringLength: UInt32
    private(set) var vendorString: String
    private(set) var userCommentListLength: UInt32
    private(set) var userComments: [Comment]
    
    init() {
        magicSignature = [ 0x4f, 0x70, 0x75, 0x73, 0x54, 0x61, 0x67, 0x73 ] // "OpusTags"
        vendorString = String(validatingUTF8: opus_get_version_string())!
        vendorStringLength = UInt32(vendorString.characters.count)
        userComments = [Comment(tag: "ENCODER", value: "IBM Mobile Innovation Lab")]
        userCommentListLength = UInt32(userComments.count)
    }
    
    func toData() -> Data {
        var data = Data()
        data.append(magicSignature, count: magicSignature.count)
        withUnsafePointer(to: &vendorStringLength) { ptr in ptr.withMemoryRebound(to: UInt8.self, capacity: 1) { ptr in data.append(ptr, count: MemoryLayout<UInt32>.size) }}
        data.append(vendorString.data(using: String.Encoding.utf8)!)
        withUnsafePointer(to: &userCommentListLength) { ptr in ptr.withMemoryRebound(to: UInt8.self, capacity: 1) { ptr in data.append(ptr, count: MemoryLayout<UInt32>.size) }}
        for comment in userComments {
            data.append(comment.toData())
        }
        return data
    }
}

// MARK: - Comment
fileprivate class Comment {
    private(set) var length: UInt32
    private(set) var comment: String
    
    fileprivate init(tag: String, value: String) {
        comment = "\(tag)=\(value)"
        length = UInt32(comment.characters.count)
    }
    
    fileprivate func toData() -> Data {
        var data = Data()
        withUnsafePointer(to: &length) { ptr in ptr.withMemoryRebound(to: UInt8.self, capacity: 1) { ptr in data.append(ptr, count: MemoryLayout<UInt32>.size) }}
        data.append(comment.data(using: String.Encoding.utf8)!)
        return data
    }
}

// MARK: - ChannelMappingFamily
fileprivate enum ChannelMappingFamily: UInt8 {
    case rtp = 0
    case vorbis = 1
    case undefined = 255
}

// MARK: - Application
internal enum Application {
    case voip
    case audio
    case lowDelay
    
    var rawValue: Int32 {
        switch self {
        case .voip: return OPUS_APPLICATION_VOIP
        case .audio: return OPUS_APPLICATION_AUDIO
        case .lowDelay: return OPUS_APPLICATION_RESTRICTED_LOWDELAY
        }
    }
    
    init?(rawValue: Int32) {
        switch rawValue {
        case OPUS_APPLICATION_VOIP: self = .voip
        case OPUS_APPLICATION_AUDIO: self = .audio
        case OPUS_APPLICATION_RESTRICTED_LOWDELAY: self = .lowDelay
        default: return nil
        }
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
