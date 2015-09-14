//
//  TextToSpeech.swift
//  TextSpeech
//
//  Created by Robert Dickerson on 9/4/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

/**
TODO:

Put the regions and languages into a plist

**/


import Foundation
import UIKit
import AVFoundation
import CoreAudio

enum SpeechState {
    case New, Downloaded, Played, Failed
}

enum VoiceGender {
    case Male, Female
}

enum SpeechLanguage {
    case EnglishUS, EnglishUK, German, Spanish, Italian
}

// enum region?

// put regions and languages in plist

public protocol Voice
{
    func say(text:String);
    func prepareToSay(text:String)
}



protocol TextToSpeechServiceDelegate
{
    func speechDidDownload()
    func speechDidPlay()
    // func speechWillPlay()
}

public class WatsonVoice : Voice
{
    
    let _speechService: TextToSpeechService
    
    init (service: TextToSpeechService)
    {
        _speechService = service
    }
    
    public func say(text: String) {
        
        _speechService.synthesizeSpeech(text, voice: self)
    }
    
    public func prepareToSay(text:String)
    {
        _speechService.downloadSpeech(text , voice: self)
    }
}

protocol TextToSpeechService
{
    //init(username: String, password: String)
    func getDefaultVoice() -> Voice
    func getVoiceByName(name: String) -> Voice
    func getVoiceByType(gender: VoiceGender, language: SpeechLanguage) -> Voice
    func synthesizeSpeech(text:String, voice: Voice)
    func downloadSpeech(text:String, voice: Voice)
}

public class WatsonTextToSpeechService : TextToSpeechService
{
    
    var _speechRequests = [SpeechRequest]()
    let _pendingOperations = PendingOperations()
    
    let _username : String
    let _password : String
    
    public required init(username: String, password: String)    {
        
        _username = username
        _password = password
    }
    
    // maximum size cache, cache purging?
    
    public func synthesizeSpeech(text:String, voice: Voice)
    {
        let speechRequest = SpeechRequest(text: text)
        _speechRequests.append(speechRequest)
        
        let downloader = SpeechDownloadOperation(speechRequest: speechRequest )
        
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            
            self.delegate?.speechDidPlay()
            
            dispatch_async(dispatch_get_main_queue(), {
                //self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                
            })
        }
        
        // Uncomment this to make the network call
        _pendingOperations.downloadQueue.addOperation(downloader)
        
    }
    
    func getDefaultVoice() -> Voice
    {
        return WatsonVoice(service: self)
    }
    
    
    func getVoiceByName(name: String) -> Voice
    {
        return WatsonVoice(service: self)
    }
    
    func getVoiceByType(gender: VoiceGender, language: SpeechLanguage) -> Voice
    {
        return WatsonVoice(service: self)
    }
    
    
    func downloadSpeech(text:String, voice: Voice)
    {
        
    }

    
    var delegate: TextToSpeechServiceDelegate?

    
    
}

// SpeechRequest
// change to struct
public struct SpeechRequest {
    
    // initial state is new and waiting to be downloaded
    var state = SpeechState.New
    
    // This is the text to synthesize
    let text: String!
    
    // let language: String!
    // let gender: SpeechGender!
    
    // once the text has been transcribed
    // replace this with Sound information
    var speechAudio: SpeechAudio?
    
    public init(text:String) {
        
        self.text = text
        
        
    }
}


public class PendingOperations {
    
    // not implemented yet
    public lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    
    public lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = self._numConcurrentOperations
        return queue
    }()
    
    var _numConcurrentOperations: Int = 5
    
    public init()
    {
        
    }
    
    public init(numConcurrentOperations: Int)
    {
        _numConcurrentOperations = numConcurrentOperations
    }
    
}

// deprecated. IBM Watson returns a corrupted WAVE file that is not compatible
extension SpeechDownloadOperation {
    
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



public class SpeechDownloadOperation : NSOperation {
    
    // elevate this to the commons library
    let ttsURL = NSURL(string: "https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize")
    
    var _speechRequest : SpeechRequest

    // var player : AVAudioPlayer?
    lazy var audioEngine : AVAudioEngine = AVAudioEngine()
    
    public init(speechRequest: SpeechRequest) {
        _speechRequest = speechRequest
        
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
        
        // only support WAVE because native
        
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) -> Void in
            
            let statusCode = (response as? NSHTTPURLResponse)?.statusCode ?? -1
            
            if let d = data {
                print("Received a data payload that is \(d.length) bytes")
                
            
                // if a success
                if statusCode == 200
                {
                    //_speechRequest.soundData = d
                    
                    self._speechRequest.speechAudio = createPCM(d)
                    self._speechRequest.state = .Downloaded
                
                    //let processedSound = createPCM(d)
                    
                    
                    // playAudioPCM(self.audioEngine, data: processedSound)
                    
                    // playAudio(player, processedSound)
                } else {
                    // what should we do if not 500
                    // log the problem
                    print("Received a bad response from server: \(statusCode)")
                }
                
            }
            
        }
        
        dataTask.resume()
        
        if self.cancelled {
            return
        }
        
    }
    
}