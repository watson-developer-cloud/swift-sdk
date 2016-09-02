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

internal class SpeechToTextRecorder {
    
    // This implementation closely follows Apple's "Audio Queue Services Programming Guide".
    // See the guide for more information about audio queues and recording.
    
    internal var onAudio: (NSData -> Void)?                          // callback to handle pcm buffer
    private(set) internal var format = AudioStreamBasicDescription() // audio data format specification
    private var queue: AudioQueueRef = nil                           // opaque reference to an audio queue
    private var buffers = [AudioQueueBufferRef]()                    // array of audio queue buffers
    private var bufferSize: UInt32 = 0                               // capacity of each buffer, in bytes
    private var currentPacket: Int64 = 0                             // current packet index
    private var isRecording = false                                  // state of recording
    
    private let callback: AudioQueueInputCallback = {
        userData, queue, bufferRef, startTimeRef, numPackets, packetDescriptions in
        print("callback")
        
        // dereference pointers
        let unmanagedAudioRecorder = Unmanaged<SpeechToTextRecorder>.fromOpaque(COpaquePointer(userData))
        let audioRecorder = unmanagedAudioRecorder.takeUnretainedValue()
        let buffer = UnsafePointer<AudioQueueBuffer>(bufferRef).memory
        let startTime = startTimeRef.memory
        
        // calculate number of packets
        var numPackets = numPackets
        if (numPackets == 0 && audioRecorder.format.mBytesPerPacket != 0) {
            numPackets = buffer.mAudioDataByteSize / audioRecorder.format.mBytesPerPacket
        }
        
        // execute callback with audio data
        let pcm = NSData(bytes: buffer.mAudioData, length: Int(buffer.mAudioDataByteSize))
        audioRecorder.onAudio?(pcm)
        print("handled audio")
        
        // return early if recording is stopped
        guard audioRecorder.isRecording else {
            return
        }
        
        // enqueue buffer
        let enqueueStatus = AudioQueueEnqueueBuffer(audioRecorder.queue, bufferRef, 0, nil)
        print("enqueue status: \(enqueueStatus)")
    }
    
    internal func startRecording() {
        // define audio format
        var formatFlags = AudioFormatFlags()
        formatFlags |= kLinearPCMFormatFlagIsSignedInteger
        formatFlags |= kLinearPCMFormatFlagIsPacked
        format = AudioStreamBasicDescription(
            mSampleRate: 16000.0,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: formatFlags,
            mBytesPerPacket: UInt32(1*strideof(Int16)),
            mFramesPerPacket: 1,
            mBytesPerFrame: UInt32(1*strideof(Int16)),
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0
        )
        
        // create recording queue
        let opaque = Unmanaged<SpeechToTextRecorder>.passUnretained(self).toOpaque()
        let pointer = UnsafeMutablePointer<Void>(opaque)
        let queueStatus = AudioQueueNewInput(&format, callback, pointer, nil, nil, 0, &queue)
        print("queue status: \(queueStatus)")
        
        // update audio format
        var formatSize = UInt32(strideof(format.dynamicType))
        let propertyStatus = AudioQueueGetProperty(queue, kAudioQueueProperty_StreamDescription, &format, &formatSize)
        print("property status: \(propertyStatus)")
        
        // allocate and enqueue buffers
        let numBuffers = 5
        bufferSize = deriveBufferSize(0.5)
        buffers = Array<AudioQueueBufferRef>(count: numBuffers, repeatedValue: nil)
        for i in 0..<numBuffers {
            let allocateStatus = AudioQueueAllocateBuffer(queue, bufferSize, &buffers[i])
            print("allocate status: \(allocateStatus)")
            let enqueueStatus = AudioQueueEnqueueBuffer(queue, buffers[i], 0, nil)
            print("enqueue status: \(enqueueStatus)")
        }
        
        // start recording
        isRecording = true
        AudioQueueStart(queue, nil)
    }
    
    internal func stopRecording() {
        isRecording = false
        AudioQueueStop(queue, true)
    }
    
    private func deriveBufferSize(seconds: Float64) -> UInt32 {
        let maxBufferSize = UInt32(0x50000)
        var maxPacketSize = format.mBytesPerPacket
        if maxPacketSize == 0 {
            var maxVBRPacketSize = UInt32(strideof(maxPacketSize.dynamicType))
            AudioQueueGetProperty(
                queue,
                kAudioQueueProperty_MaximumOutputPacketSize,
                &maxPacketSize,
                &maxVBRPacketSize
            )
        }
        
        let numBytesForTime = UInt32(format.mSampleRate * Float64(maxPacketSize) * seconds)
        let bufferSize = (numBytesForTime < maxBufferSize ? numBytesForTime : maxBufferSize)
        return bufferSize
    }
}
