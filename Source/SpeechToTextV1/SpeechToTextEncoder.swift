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
    
    private var stream: ogg_stream_state   // state of the ogg stream
    private var encoder: opus_encoder      // encoder to convert pcm to opus
    private var granulePosition: Int64     // total number of encoded pcm samples in the stream
    private var packetNumber: Int64        // total number of packets encoded in the stream
    private let frameSize: Int32           // number of pcm frames to encode in an opus frame (20ms)
    private let maxFrameSize: Int32 = 3832 // maximum size of an opus frame
    private let opusRate: Int32            // desired sample rate of the opus audio
    private let pcmBytesPerFrame: UInt32   // bytes per frame in the pcm audio
    private var pcmCache: NSMutableData    // cache for pcm audio that is too short to encode
    private var oggCache = NSMutableData() // cache for ogg stream
    
    private typealias opus_encoder = COpaquePointer
    
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
            throw OggError.InternalError
        }

        // set properties
        self.granulePosition = 0
        self.packetNumber = 0
        self.frameSize = Int32(960 / (48000 / opusRate))
        self.opusRate = opusRate
        self.pcmBytesPerFrame = pcmBytesPerFrame
        self.pcmCache = NSMutableData()
        
        // create status to capture errors
        var status = Int32(0)
        
        // initialize ogg stream
        stream = ogg_stream_state()
        let serial = Int32(bitPattern: arc4random())
        status = ogg_stream_init(&stream, serial)
        guard status == 0 else {
            throw OggError.InternalError
        }
        
        // initialize opus encoder
        encoder = opus_encoder_create(opusRate, pcmChannels, application.rawValue, &status)
        guard let error = OpusError(rawValue: status) else { throw OpusError.InternalError }
        guard error == .OK else { throw error }
        
        // add opus headers to ogg stream
        try addOpusHeader(UInt8(pcmChannels), rate: UInt32(pcmRate))
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
            channelMappingFamily: .RTP
        ).toData()
        
        // construct ogg packet with header
        var packet = ogg_packet()
        packet.packet = UnsafeMutablePointer<UInt8>(header.bytes)
        packet.bytes = header.length
        packet.b_o_s = 1
        packet.e_o_s = 0
        packet.granulepos = granulePosition
        packet.packetno = Int64(packetNumber)
        packetNumber += 1
        
        // add packet to ogg stream
        let status = ogg_stream_packetin(&stream, &packet)
        guard status == 0 else {
            throw OggError.InternalError
        }
        
        // assemble pages and add to ogg cache
        assemblePages(true)
    }
    
    private func addOpusCommentHeader() throws {
        // construct opus comment header
        let header = CommentHeader().toData()
        
        // construct ogg packet with comment header
        var packet = ogg_packet()
        packet.packet = UnsafeMutablePointer<UInt8>(header.bytes)
        packet.bytes = header.length
        packet.b_o_s = 0
        packet.e_o_s = 0
        packet.granulepos = granulePosition
        packet.packetno = Int64(packetNumber)
        packetNumber += 1
        
        // add packet to ogg stream
        let status = ogg_stream_packetin(&stream, &packet)
        guard status == 0 else {
            throw OggError.InternalError
        }
        
        // assemble pages and add to ogg cache
        assemblePages(true)
    }
    
    internal func encode(pcm: AudioQueueBuffer) throws {
        try encode(pcm.mAudioData, bytes: Int(pcm.mAudioDataByteSize))
    }
    
    internal func encode(pcm: NSData) throws {
        try encode(pcm.bytes, bytes: pcm.length)
    }
    
    internal func encode(pcm: UnsafePointer<Void>, bytes: Int) throws {
        // ensure we have complete pcm frames
        guard UInt32(bytes) % pcmBytesPerFrame == 0 else {
            throw OpusError.InternalError
        }
        
        // construct audio buffers
        var pcm = UnsafeMutablePointer<Int16>(pcm)
        var opus = Array<UInt8>(count: Int(maxFrameSize), repeatedValue: 0)
        var bytes = bytes
        
        // encode cache, if necessary
        try encodeCache(&pcm, bytes: &bytes)
        
        // encode complete frames
        while bytes >= Int(frameSize) * Int(pcmBytesPerFrame) {
            
            // encode an opus frame
            let numBytes = opus_encode(encoder, pcm, frameSize, &opus, maxFrameSize)
            guard numBytes >= 0 else {
                throw OpusError.InternalError
            }
            
            // construct ogg packet with opus frame
            var packet = ogg_packet()
            granulePosition += Int64(frameSize * 48000 / opusRate)
            packet.packet = UnsafeMutablePointer<UInt8>(opus)
            packet.bytes = Int(numBytes)
            packet.b_o_s = 0
            packet.e_o_s = 0
            packet.granulepos = granulePosition
            packet.packetno = Int64(packetNumber)
            packetNumber += 1
            
            // add packet to ogg stream
            let status = ogg_stream_packetin(&stream, &packet)
            guard status == 0 else {
                throw OggError.InternalError
            }
            
            // advance pcm buffer
            let bytesEncoded = Int(frameSize) * Int(pcmBytesPerFrame)
            pcm = pcm.advancedBy(bytesEncoded / strideof(Int16))
            bytes = bytes - bytesEncoded
        }
        
        // cache remaining pcm data
        pcmCache.appendBytes(pcm, length: bytes)
    }
    
    private func encodeCache(inout pcm: UnsafeMutablePointer<Int16>, inout bytes: Int) throws {
        // ensure there is cached data
        guard pcmCache.length > 0 else {
            return
        }
        
        // ensure we can add enough pcm data for a complete frame
        guard pcmCache.length + bytes >= Int(frameSize) * Int(pcmBytesPerFrame) else {
            return
        }
        
        // append pcm data to create a complete frame
        let toAppend = Int(frameSize) * Int(pcmBytesPerFrame) - pcmCache.length
        pcmCache.appendBytes(pcm, length: toAppend)
        
        // advance pcm buffer (modifies the inout arguments)
        pcm = pcm.advancedBy(toAppend / strideof(Int16))
        bytes = bytes - toAppend
        
        // construct opus buffer
        let cache = UnsafeMutablePointer<Int16>(pcmCache.bytes)
        var opus = Array<UInt8>(count: Int(maxFrameSize), repeatedValue: 0)
        
        // encode an opus frame
        let numBytes = opus_encode(encoder, cache, frameSize, &opus, maxFrameSize)
        guard numBytes >= 0 else {
            throw OpusError.InternalError
        }
        
        // construct ogg packet with opus frame
        var packet = ogg_packet()
        granulePosition += Int64(frameSize * 48000 / opusRate)
        packet.packet = UnsafeMutablePointer<UInt8>(opus)
        packet.bytes = Int(numBytes)
        packet.b_o_s = 0
        packet.e_o_s = 0
        packet.granulepos = granulePosition
        packet.packetno = Int64(packetNumber)
        packetNumber += 1
        
        // add packet to ogg stream
        let status = ogg_stream_packetin(&stream, &packet)
        guard status == 0 else {
            throw OggError.InternalError
        }
        
        // reset cache
        pcmCache = NSMutableData()
    }
    
    internal func bitstream(flush: Bool = false, fillBytes: Int32? = nil) -> NSData {
        assemblePages(flush, fillBytes: fillBytes)
        let bitstream = NSData(data: oggCache)
        oggCache = NSMutableData()
        return bitstream
    }
    
    internal func endstream(fillBytes: Int32? = nil) throws -> NSData {
        // compute granule position using cache
        let pcmFrames = pcmCache.length / Int(pcmBytesPerFrame)
        granulePosition += Int64(pcmFrames * 48000 / Int(opusRate))
        
        // add padding to cache to construct complete frame
        let toAppend = Int(frameSize) * Int(pcmBytesPerFrame) - pcmCache.length
        let padding = Array<UInt8>(count: toAppend, repeatedValue: 0)
        pcmCache.appendBytes(padding, length: toAppend)
        
        // construct opus buffer
        let cache = UnsafeMutablePointer<Int16>(pcmCache.bytes)
        var opus = Array<UInt8>(count: Int(maxFrameSize), repeatedValue: 0)
        
        // encode an opus frame
        let numBytes = opus_encode(encoder, cache, frameSize, &opus, maxFrameSize)
        guard numBytes >= 0 else {
            throw OpusError.InternalError
        }
        
        // construct ogg packet with opus frame
        var packet = ogg_packet()
        packet.packet = UnsafeMutablePointer<UInt8>(opus)
        packet.bytes = Int(numBytes)
        packet.b_o_s = 0
        packet.e_o_s = 1
        packet.granulepos = granulePosition
        packet.packetno = Int64(packetNumber)
        packetNumber += 1
        
        // add packet to ogg stream
        let status = ogg_stream_packetin(&stream, &packet)
        guard status == 0 else {
            throw OggError.InternalError
        }
        
        return bitstream(true)
    }
    
    private func assemblePages(flush: Bool = false, fillBytes: Int32? = nil) {
        var page = ogg_page()
        var status = Int32(1)
        
        // assemble pages until there is insufficient data to fill a page
        while true {
            
            // assemble accumulated packets into an ogg page
            switch (flush, fillBytes) {
            case (true, .Some(let fillBytes)): status = ogg_stream_flush_fill(&stream, &page, fillBytes)
            case (true, .None): status = ogg_stream_flush(&stream, &page)
            case (false, .Some(let fillBytes)): status = ogg_stream_pageout_fill(&stream, &page, fillBytes)
            case (false, .None): status = ogg_stream_pageout(&stream, &page)
            }
            
            // break when all packet data has been accumulated into pages
            guard status != 0 else {
                return
            }
            
            // add ogg page to cache
            oggCache.appendBytes(page.header, length: page.header_len)
            oggCache.appendBytes(page.body, length: page.body_len)
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
    
    func toData() -> NSData {
        let data = NSMutableData()
        data.appendBytes(magicSignature, length: magicSignature.count)
        data.appendBytes(&version, length: sizeof(version.dynamicType))
        data.appendBytes(&outputChannels, length: sizeof(outputChannels.dynamicType))
        data.appendBytes(&preskip, length: sizeof(preskip.dynamicType))
        data.appendBytes(&inputSampleRate, length: sizeof(inputSampleRate.dynamicType))
        data.appendBytes(&outputGain, length: sizeof(outputGain.dynamicType))
        data.appendBytes(&channelMappingFamily, length: sizeof(channelMappingFamily.dynamicType))
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
        vendorString = String.fromCString(opus_get_version_string())!
        vendorStringLength = UInt32(vendorString.characters.count)
        userComments = [Comment(tag: "ENCODER", value: "IBM Mobile Innovation Lab")]
        userCommentListLength = UInt32(userComments.count)
    }
    
    func toData() -> NSData {
        let data = NSMutableData()
        data.appendBytes(magicSignature, length: magicSignature.count)
        data.appendBytes(&vendorStringLength, length: sizeof(vendorStringLength.dynamicType))
        data.appendData(vendorString.dataUsingEncoding(NSUTF8StringEncoding)!)
        data.appendBytes(&userCommentListLength, length: sizeof(userCommentListLength.dynamicType))
        for comment in userComments {
            data.appendData(comment.toData())
        }
        return data
    }
}

// MARK: - Comment
private class Comment {
    private(set) var length: UInt32
    private(set) var comment: String
    
    init(tag: String, value: String) {
        comment = "\(tag)=\(value)"
        length = UInt32(comment.characters.count)
    }
    
    private func toData() -> NSData {
        let data = NSMutableData()
        data.appendBytes(&length, length: sizeof(length.dynamicType))
        data.appendData(comment.dataUsingEncoding(NSUTF8StringEncoding)!)
        return data
    }
}

// MARK: - ChannelMappingFamily
private enum ChannelMappingFamily: UInt8 {
    case RTP = 0
    case Vorbis = 1
    case Undefined = 255
}

// MARK: - Application
internal enum Application {
    case VOIP
    case Audio
    case LowDelay
    
    var rawValue: Int32 {
        switch self {
        case .VOIP: return OPUS_APPLICATION_VOIP
        case .Audio: return OPUS_APPLICATION_AUDIO
        case .LowDelay: return OPUS_APPLICATION_RESTRICTED_LOWDELAY
        }
    }
    
    init?(rawValue: Int32) {
        switch rawValue {
        case OPUS_APPLICATION_VOIP: self = .VOIP
        case OPUS_APPLICATION_AUDIO: self = .Audio
        case OPUS_APPLICATION_RESTRICTED_LOWDELAY: self = .LowDelay
        default: return nil
        }
    }
}

// MARK: - OpusError
internal enum OpusError: ErrorType {
    case OK
    case BadArgument
    case BufferTooSmall
    case InternalError
    case InvalidPacket
    case Unimplemented
    case InvalidState
    case AllocationFailure
    
    var rawValue: Int32 {
        switch self {
        case .OK: return OPUS_OK
        case .BadArgument: return OPUS_BAD_ARG
        case .BufferTooSmall: return OPUS_BUFFER_TOO_SMALL
        case .InternalError: return OPUS_INTERNAL_ERROR
        case .InvalidPacket: return OPUS_INVALID_PACKET
        case .Unimplemented: return OPUS_UNIMPLEMENTED
        case .InvalidState: return OPUS_INVALID_STATE
        case .AllocationFailure: return OPUS_ALLOC_FAIL
        }
    }
    
    init?(rawValue: Int32) {
        switch rawValue {
        case OPUS_OK: self = .OK
        case OPUS_BAD_ARG: self = .BadArgument
        case OPUS_BUFFER_TOO_SMALL: self = .BufferTooSmall
        case OPUS_INTERNAL_ERROR: self = .InternalError
        case OPUS_INVALID_PACKET: self = .InvalidPacket
        case OPUS_UNIMPLEMENTED: self = .Unimplemented
        case OPUS_INVALID_STATE: self = .InvalidState
        case OPUS_ALLOC_FAIL: self = .AllocationFailure
        default: return nil
        }
    }
}

// MARK: - OggError
internal enum OggError: ErrorType {
    case OutOfSync
    case InternalError
}
