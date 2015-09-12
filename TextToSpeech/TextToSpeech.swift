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

enum SpeechLanguages {
    case EnglishUS, EnglishUK, German, Spanish, Italian
}

protocol TextToSpeech
{
    func synthesize(text:String);
}

protocol TextToSpeechDelegate
{
    
    func speechDownloaded()
    func speechPlayed()
}

public class WatsonTextToSpeech : TextToSpeech
{
    
    var speech = [SpeechSample]()
    let pendingOperations = PendingOperations()
    
    public init()
    {
    
    }
    
    public func synthesize(text:String)
    {
        let speechRequest = SpeechSample(text: "The rain in Spain stays mainly in the plain.")
        self.speech.append(speechRequest)
        
        let downloader = SpeechDownloader(speechSample: speechRequest )
        
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            
            self.delegate?.speechPlayed()
            
            dispatch_async(dispatch_get_main_queue(), {
                //self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                
            })
        }
        
        // Uncomment this to make the network call
        pendingOperations.downloadQueue.addOperation(downloader)

    }
    
    var delegate: TextToSpeechDelegate?
    
}

public class SpeechSample {
    
    // initial state is new and waiting to be downloaded
    var state = SpeechState.New
    
    // This is the text to synthesize
    let text: String!
    
    let language: String!
    let gender: SpeechGender!
    
    // once the text has been transcribed
    var soundData: NSData?
    
    public init(text:String) {
        
        self.text = text
        self.language = "English (American Dialect"
        self.gender = .Male
        
    }
}

public class PendingOperations {
    
    public lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    public lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    public init()
    {
        
    }
    
}

func bytesToDouble (firstByte: UInt8, secondByte: UInt8) -> Float
{
    let s : UInt16 = UInt16(secondByte) << 8 | UInt16(firstByte)
    return Float(s) / Float(UINT16_MAX)
}

extension SpeechDownloader {
    
    public func playAudio(player: AVAudioPlayer, data: NSData)
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


public class SpeechDownloader : NSOperation {
    
    let ttsURL = NSURL(string: "https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize")
    
    let speechSample : SpeechSample

    var player : AVAudioPlayer?
    lazy var audioEngine : AVAudioEngine = AVAudioEngine()
    
    public init(speechSample: SpeechSample) {
        self.speechSample = speechSample
        
        // audioEngine = AVAudioEngine()
    }
    
        
    
    public override func main() {
        
        if self.cancelled {
            return
        }
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let userPasswordString = "76b77f2f-a0ea-49a7-ad34-53b5636326ec:ggzipaZ7L3o0"
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
                
                    //let processedSound = createPCM(d)
                    
                    
                    // playAudioPCM(self.audioEngine, data: processedSound)
                    
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