/**
*   TextToSpeechSDK
*   WatsonTextToSpeech.swift
*
*   Object to contain all beacon information.
*
*   Copyright (c) 2015 IBM Corporation. All rights reserved.
*
*   Licensed under the Apache License, Version 2.0 (the "License");
*   you may not use this file except in compliance with the License.
*   You may obtain a copy of the License at
*
*   http://www.apache.org/licenses/LICENSE-2.0
*
*   Unless required by applicable law or agreed to in writing, software
*   distributed under the License is distributed on an "AS IS" BASIS,
*   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*   See the License for the specific language governing permissions and
*   limitations under the License.
**/


import Foundation
import UIKit
import AVFoundation


public enum SpeechState {
    case New, Downloaded, Failed
}

public enum VoiceGender {
    case Male, Female
}

public enum VoiceLanguage {
    case EnglishUS, EnglishUK, German, Spanish, Italian
}



public typealias CompletionBlock = (error: NSError?) -> Void

// enum region?

// put regions and languages in plist



// MARK: - Delegate protocol.
public protocol TextToSpeechServiceDelegate
{
    func speechDidDownload()
    func speechDidPlay()
}



public protocol TextToSpeechService
{
    init(username: String, password: String)
    func getDefaultVoice() -> Voice
    func getVoiceByName(name: String) -> Voice
    func getVoiceByType(gender: VoiceGender, language: VoiceLanguage) -> Voice
    func synthesizeSpeech(text:String, voice: Voice)
    func synthesizeSpeech(text:String, voice: Voice, completion: CompletionBlock)
    func downloadSpeech(text:String, voice: Voice)
    func enableLogging()
}

public class WatsonTextToSpeechService : NSObject, TextToSpeechService
{
    
    public var delegate: TextToSpeechServiceDelegate?
    
    private var _speechRequests = [SpeechRequest]()
    private let _pendingOperations = PendingOperations()
    
    private let _username : String
    private let _password : String
    
    private var _debug: Bool = false
    
    /**
    Default object initializer.

    - parameter username:   Username credential from Bluemix
    - parameter password:   Password credential from Bluemix
    */
    public required init(username: String, password: String)    {
        
        _username = username
        _password = password
    }
    
    
    public func synthesizeSpeech(text:String, voice: Voice)
    {
        
    }
    
    public func synthesizeSpeech(text:String, voice: Voice, completion: CompletionBlock)
    {
        let speechRequest = SpeechRequest(text: text)
        _speechRequests.append(speechRequest)
        
        let downloader = SpeechDownloadOperation(username: _username, password: _password, speechRequest: speechRequest, delegate: delegate )
        
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            
            self.delegate?.speechDidPlay()
            
            completion(error: nil)
            
            dispatch_async(dispatch_get_main_queue(), {
                //self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                
            })
        }
        
        // Uncomment this to make the network call
        _pendingOperations.downloadQueue.addOperation(downloader)
        
    }
    
    public func getDefaultVoice() -> Voice
    {
        return WatsonVoice(speechService: self)
    }
    
    
    public func getVoiceByName(name: String) -> Voice
    {
        return WatsonVoice(speechService: self)
    }
    
    public func getVoiceByType(gender: VoiceGender, language: VoiceLanguage) -> Voice
    {
        return WatsonVoice(speechService: self)
    }
    
    
    public func downloadSpeech(text:String, voice: Voice)
    {
        
    }
    
    public func enableLogging() {
        _debug = true
    }
    
    
    
    
    
    
}

// SpeechRequest
// change to struct
public class SpeechRequest: NSObject {
    
    // initial state is new and waiting to be downloaded
    public var state: SpeechState
    
    public let _text: String!
    public let _language: VoiceLanguage!
    public let _gender: VoiceGender!
    
    public var speechAudio: SpeechAudio?
    
    public init(text:String, gender: VoiceGender, language: VoiceLanguage ) {
        
        _text = text
        state = .New
        _language = .EnglishUS
        _gender = .Male
        
    }
    
    public convenience init (text:String) {
    
        self.init(text: text, gender: .Male, language: .EnglishUS)
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

// MARK: - deprecated. IBM Watson returns a corrupted WAVE file that is not compatible. So the following method will not work.
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
    
    let ttsURL = NSURL(string: Endpoints.TTS_ENDPOINT)
    
    var _speechRequest : SpeechRequest
    
    let _username: String!
    let _password: String!
    
    var _delegate: TextToSpeechServiceDelegate?
    
    lazy var audioEngine : AVAudioEngine = AVAudioEngine()
    
    public init(username: String, password: String, speechRequest: SpeechRequest, delegate: TextToSpeechServiceDelegate?) {
       
        _speechRequest = speechRequest
        _delegate = delegate
        _username = username
        _password = password
        
    }
    
    
    
    public override func main() {
        
        if self.cancelled {
            return
        }
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        // let userPasswordString = "76b77f2f-a0ea-49a7-ad34-53b5636326ec:ggzipaZ7L3o0"
        
        let userPasswordString = _username + ":" + _password
        
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let authString = "Basic \(base64EncodedCredential)"
        
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        config.timeoutIntervalForRequest = NetworkOptions.TIMEOUT_REQUEST
        config.timeoutIntervalForResource = NetworkOptions.TIMEOUT_RESOURCE
        config.HTTPMaximumConnectionsPerHost = NetworkOptions.HTTP_CONNECTIONS_PER_HOST
        
        let session = NSURLSession(configuration: config)
        
        let request = NSMutableURLRequest(URL: ttsURL!)
        request.HTTPMethod = "POST"
        
        let toSay = _speechRequest._text
        
        request.HTTPBody = "{\"text\":\"\(toSay)\"}".dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("audio/wav", forHTTPHeaderField: "Accept")
        
        // only support WAVE because native
        
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) -> Void in
            
            let statusCode = (response as? NSHTTPURLResponse)?.statusCode ?? -1
            
            if let d = data {
                print("Received a data payload that is \(d.length) bytes")
                
                
                if statusCode == StatusCodes.SUCCESS
                {
                    
                    self._speechRequest.speechAudio = createPCM(d)
                    self._speechRequest.state = .Downloaded
                    
                    
                    if let audio = self._speechRequest.speechAudio {
                        playAudioPCM(self.audioEngine, audioSegment: audio, delegate: nil)
                    } else {
                        print ("Could not read the audio")
                        self._speechRequest.state = .Failed
                    }
                    
                } else {
                    
                    print("Received a bad response from server: \(statusCode)")
                    self._speechRequest.state = .Failed
                }
                
            }
            
        }
        
        dataTask.resume()
        
        if self.cancelled {
            return
        }
        
    }
    
}