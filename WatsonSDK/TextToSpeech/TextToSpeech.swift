/**
 * Copyright IBM Corporation 2015
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
import AVFoundation
import ObjectMapper


public protocol TextToSpeechService
{
    func synthesize ( theText:String, voice: String, oncompletion: (data: NSData?, error:NSError?) -> Void )
    
    func listVoices ( oncompletion: (voices: [Voice], error:NSError?) -> Void )
    
}

public class TextToSpeech : Service, TextToSpeechService
{
    // Provides the Opus/Ogg decompression
    let opus: OpusHelper = OpusHelper()
    
    // Default endpoint for TTS services
    private let _serviceURL = "/text-to-speech/api"
    
    // Sampling rate returned from the Opus decoder is 48KHz by default.
    private let DEFAULT_SAMPLE_RATE = 48000
    
    public init() {
        
        super.init(type: .Streaming, serviceURL: _serviceURL)
       
    }
    
    /**
     This function invokes a call to synthesize text and decompress the audio to 
     produce a WAVE formatted NSData

     - parameter theText:           String that will be synthesized
     - parameter voice:             String specifying the voice name
     - parameter oncompletion:      Callback function that will present the WAVE data
    */
    public func synthesize(theText: String,
        voice: String = "",
        oncompletion: (data: NSData?, error:NSError?) -> Void ) {
        
        let endpoint = getEndpoint("/v1/synthesize")
            
        var params = Dictionary<String, String>()
        params.updateValue(theText, forKey: "text")
        // Opus codec is the default, so the accept type is optional
        // params.updateValue("audio/ogg; codecs=opus", forKey: "accept")
        
        if (voice != "")
        {
            params.updateValue(voice, forKey: "voice")
        }
        
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .GET,
            parameters: params,
            contentType: .AUDIO_OPUS,
            accept: .AUDIO_OPUS,
            apiKey: _apiKey,
            completionHandler: {
            
            response in
                
                if let data = response.data as? NSData {
                    
                    let pcm = self.opus.opusToPCM(data, sampleRate: self.DEFAULT_SAMPLE_RATE)
                    let waveData = self.addWaveHeader(pcm)
                    
                    oncompletion(data: waveData, error: response.error)
                    
                } else {
                    oncompletion(data: nil, error: response.error)
                }
            
        })
    
    }
    
    /**
     This function returns a list of voices that Watson supports
     
     - parameter oncompletion:      Callback function that presents an array of Voices
    */
    public func listVoices ( oncompletion: (voices: [Voice], error:NSError?) -> Void ) {
        let endpoint = getEndpoint("/v1/voices")
        
        NetworkUtils.performBasicAuthRequest(endpoint, apiKey: _apiKey,
            completionHandler: {response in
            
            var voices : [Voice] = []
            
            if case let data as Dictionary<String, AnyObject> = response.data {
                
                if case let rawVoices as [AnyObject] = data["voices"]
                {
                    for rawVoice in rawVoices {
                        if let voice = Mapper<Voice>().map(rawVoice) {
                            voices.append(voice)
                        }
                    }
                }
                
            }
           
            
            oncompletion(voices: voices, error: response.error)
        })

    }
    
    /**
     This function converts a PCM of UInt16s to a WAVE file by prepending a header
     
     - parameter data:      Contains PCM (pulse coded modulation) raw data for audio
     - returns:             WAVE formatted header prepended to the data
    **/
    private func addWaveHeader(data: NSData) -> NSData {
        
        let headerSize: Int = 44
        let totalAudioLen: Int = data.length
        let totalDataLen: Int = totalAudioLen + headerSize - 8
        let longSampleRate: Int = 48000
        let channels = 1
        let byteRate = 16 * 11025 * channels / 8
        
        let byteArray = [UInt8]("RIFF".utf8)
        let byteArray2 = [UInt8]("WAVEfmt ".utf8)
        let byteArray3 = [UInt8]("data".utf8)
        var header : [UInt8] = [UInt8](count: 44, repeatedValue: 0)
        
        header[0] = byteArray[0]
        header[1] = byteArray[1]
        header[2] = byteArray[2]
        header[3] = byteArray[3]
        header[4] = (UInt8) (totalDataLen & 0xff)
        header[5] = (UInt8) ((totalDataLen >> 8) & 0xff)
        header[6] = (UInt8) ((totalDataLen >> 16) & 0xff)
        header[7] = (UInt8) ((totalDataLen >> 24) & 0xff)
        header[8] = byteArray2[0]
        header[9] = byteArray2[1]
        header[10] = byteArray2[2]
        header[11] = byteArray2[3]
        header[12] = byteArray2[4]
        header[13] = byteArray2[5]
        header[14] = byteArray2[6]
        header[15] = byteArray2[7]
        header[16] = 16
        header[17] = 0
        header[18] = 0
        header[19] = 0
        header[20] = 1
        header[21] = 0
        header[22] = (UInt8) (channels)
        header[23] = 0
        header[24] = (UInt8) (longSampleRate & 0xff)
        header[25] = (UInt8) ((longSampleRate >> 8) & 0xff)
        header[26] = (UInt8) ((longSampleRate >> 16) & 0xff)
        header[27] = (UInt8) ((longSampleRate >> 24) & 0xff)
        header[28] = (UInt8) (byteRate & 0xff)
        header[29] = (UInt8) (byteRate >> 8 & 0xff)
        header[30] = (UInt8) (byteRate >> 16 & 0xff)
        header[31] = (UInt8) (byteRate >> 24 & 0xff)
        header[32] = (UInt8) (2 * 8 / 8)
        header[33] = 0
        header[34] = 16 // bits per sample
        header[35] = 0
        header[36] = byteArray3[0]
        header[37] = byteArray3[1]
        header[38] = byteArray3[2]
        header[39] = byteArray3[3]
        header[40] = (UInt8) (totalAudioLen & 0xff)
        header[41] = (UInt8) (totalAudioLen >> 8 & 0xff)
        header[42] = (UInt8) (totalAudioLen >> 16 & 0xff)
        header[43] = (UInt8) (totalAudioLen >> 24 & 0xff)
        
        let newWavData = NSMutableData(bytes: header, length: 44)
        newWavData.appendData(data)
        
        return newWavData
    }
    
    
    

}
    
    
    
 

    
    
