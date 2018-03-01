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

#if os(Linux)
#else

import Foundation
import AudioToolbox
import AVFoundation

internal class SpeechToTextRecorder {

    // This implementation closely follows Apple's "Audio Queue Services Programming Guide".
    // See the guide for more information about audio queues and recording.

    internal var onMicrophoneData: ((Data) -> Void)?                 // callback to handle pcm buffer
    internal var onPowerData: ((Float32) -> Void)?                   // callback for average dB power
    internal let session = AVAudioSession.sharedInstance()           // session for recording permission
    internal var isRecording = false                                 // state of recording
    internal private(set) var format = AudioStreamBasicDescription() // audio data format specification

    private var queue: AudioQueueRef?                                // opaque reference to an audio queue
    private var powerTimer: Timer?                                   // timer to invoke metering callback

    private let callback: AudioQueueInputCallback = {
        userData, queue, bufferRef, startTimeRef, numPackets, packetDescriptions in

        // parse `userData` as `SpeechToTextRecorder`
        guard let userData = userData else { return }
        let audioRecorder = Unmanaged<SpeechToTextRecorder>.fromOpaque(userData).takeUnretainedValue()

        // dereference pointers
        let buffer = bufferRef.pointee
        let startTime = startTimeRef.pointee

        // calculate number of packets
        var numPackets = numPackets
        if numPackets == 0 && audioRecorder.format.mBytesPerPacket != 0 {
            numPackets = buffer.mAudioDataByteSize / audioRecorder.format.mBytesPerPacket
        }

        // work with pcm data in an Autorelease Pool to make sure it is released in a timely manner
        autoreleasepool {
            // execute callback with audio data
            let pcm = Data(bytes: buffer.mAudioData, count: Int(buffer.mAudioDataByteSize))
            audioRecorder.onMicrophoneData?(pcm)
        }

        // return early if recording is stopped
        guard audioRecorder.isRecording else {
            return
        }

        // enqueue buffer
        if let queue = audioRecorder.queue {
            AudioQueueEnqueueBuffer(queue, bufferRef, 0, nil)
        }
    }

    internal init() {
        // define audio format
        var formatFlags = AudioFormatFlags()
        formatFlags |= kLinearPCMFormatFlagIsSignedInteger
        formatFlags |= kLinearPCMFormatFlagIsPacked
        format = AudioStreamBasicDescription(
            mSampleRate: 16000.0,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: formatFlags,
            mBytesPerPacket: UInt32(1*MemoryLayout<Int16>.stride),
            mFramesPerPacket: 1,
            mBytesPerFrame: UInt32(1*MemoryLayout<Int16>.stride),
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0
        )
    }

    private func prepareToRecord() {
        // create recording queue
        let pointer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        AudioQueueNewInput(&format, callback, pointer, nil, nil, 0, &queue)

        // ensure queue was set
        guard let queue = queue else {
            return
        }

        // update audio format
        var formatSize = UInt32(MemoryLayout<AudioStreamBasicDescription>.stride)
        AudioQueueGetProperty(queue, kAudioQueueProperty_StreamDescription, &format, &formatSize)

        // allocate and enqueue buffers
        let numBuffers = 5
        let bufferSize = deriveBufferSize(seconds: 0.5)
        for _ in 0..<numBuffers {
            let bufferRef = UnsafeMutablePointer<AudioQueueBufferRef?>.allocate(capacity: 1)
            AudioQueueAllocateBuffer(queue, bufferSize, bufferRef)
            if let buffer = bufferRef.pointee {
                AudioQueueEnqueueBuffer(queue, buffer, 0, nil)
            }
        }

        // enable metering
        var metering: UInt32 = 1
        let meteringSize = UInt32(MemoryLayout<UInt32>.stride)
        let meteringProperty = kAudioQueueProperty_EnableLevelMetering
        AudioQueueSetProperty(queue, meteringProperty, &metering, meteringSize)

        // set metering timer to invoke callback
        powerTimer = Timer(
            timeInterval: 0.025,
            target: self,
            selector: #selector(samplePower),
            userInfo: nil,
            repeats: true
        )
        RunLoop.current.add(powerTimer!, forMode: RunLoopMode.commonModes)
    }

    internal func startRecording() throws {
        guard !isRecording else { return }
        self.prepareToRecord()
        self.isRecording = true
        guard let queue = queue else { return }
        AudioQueueStart(queue, nil)
    }

    internal func stopRecording() throws {
        guard isRecording else { return }
        guard let queue = queue else { return }
        isRecording = false
        powerTimer?.invalidate()
        AudioQueueStop(queue, true)
        AudioQueueDispose(queue, false)
    }

    private func deriveBufferSize(seconds: Float64) -> UInt32 {
        guard let queue = queue else { return 0 }
        let maxBufferSize = UInt32(0x50000)
        var maxPacketSize = format.mBytesPerPacket
        if maxPacketSize == 0 {
            var maxVBRPacketSize = UInt32(MemoryLayout<UInt32>.stride)
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

    @objc
    private func samplePower() {
        guard let queue = queue else { return }
        var meters = [AudioQueueLevelMeterState(mAveragePower: 0, mPeakPower: 0)]
        var metersSize = UInt32(meters.count * MemoryLayout<AudioQueueLevelMeterState>.stride)
        let meteringProperty = kAudioQueueProperty_CurrentLevelMeterDB
        let meterStatus = AudioQueueGetProperty(queue, meteringProperty, &meters, &metersSize)
        guard meterStatus == 0 else { return }
        onPowerData?(meters[0].mAveragePower)
    }
}

#endif
