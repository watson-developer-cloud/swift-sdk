//
//  TextToSpeech.swift
//  TextSpeech
//
//  Created by Robert Dickerson on 9/4/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

enum SpeechState {
    case New, Downloaded, Played, Failed
}

enum SpeechGender {
    case Male, Female
}

class SpeechSample {
    
    // initial state is new and waiting to be downloaded
    var state = SpeechState.New
    
    // This is the text to synthesize
    let text: String!
    
    let language: String!
    let gender: SpeechGender!
    
    // once the text has been transcribed
    var soundData: NSData?
    
    init(text:String) {
        
        self.text = text
        self.language = "English (American Dialect"
        self.gender = .Male
        
    }
}

class PendingOperations {
    
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
}

func bytesToDouble (firstByte: UInt8, secondByte: UInt8) -> Float
{
    let s : UInt16 = UInt16(secondByte) << 8 | UInt16(firstByte)
    return Float(s) / Float(UINT16_MAX)
}

extension SpeechDownloader {
    
    func playAudio(player: AVAudioPlayer, data: NSData)
    {
   
        do {
        
            let player = try AVAudioPlayer.init(data: data,
                fileTypeHint: AVFileTypeWAVE )
        
            print ("Duration for received audio is \(player.duration)")
            print ("Sampling rate is \(player.rate)")
        
            player.play()
        
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
    
    }
}

// taken from:
// http://stackoverflow.com/questions/28058777/generating-a-tone-in-ios-with-16-bit-pcm-audioengine-connect-throws-ausetform

extension SpeechDownloader {
    
    
}


class SpeechDownloader : NSOperation {
    
    let ttsURL = NSURL(string: "https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize")
    
    let speechSample : SpeechSample

    var player : AVAudioPlayer?
    var audioEngine : AVAudioEngine?
    
    init(speechSample: SpeechSample) {
        self.speechSample = speechSample
        
        audioEngine = AVAudioEngine()
    }
    
        
    
    override func main() {
        
        if self.cancelled {
            return
        }
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let userPasswordString = "***REMOVED***:***REMOVED***"
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let authString = "Basic \(base64EncodedCredential)"
        
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        config.HTTPMaximumConnectionsPerHost = 1
        
        let session = NSURLSession(configuration: config)
        
        let request = NSMutableURLRequest(URL: ttsURL!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "{\"text\":\"All the problems of the world could be settled easily if men were only willing to think.\"}".dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("audio/wav", forHTTPHeaderField: "Accept")
        
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) -> Void in
            
            let statusCode = (response as? NSHTTPURLResponse)?.statusCode ?? -1
            
            if let d = data {
                print("Received a data payload that is \(d.length) bytes")
                
            
                // if a success
                if statusCode == 200
                {
                    self.speechSample.soundData = d
                    self.speechSample.state = .Downloaded
                
                    let processedSound = createPCM(d)
                    
                    if let engine = self.audioEngine {
                        playAudioPCM(engine, data: processedSound.samples)
                    }
                    // playAudio(player, processedSound)
                }
                
            }
            
        }
        
        dataTask.resume()
        
        if self.cancelled {
            return
        }
        
    }
    
}