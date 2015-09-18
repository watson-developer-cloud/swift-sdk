/**
*   TextToSpeech
*   WatsonVoice.swift
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

public protocol Voice
{
    func say(text: String)
    func say(text:String, completion: CompletionBlock);
    func prepareToSay(text:String)
}

public class WatsonVoice : NSObject, Voice
{
    
    private let TAG = "[TextToSpeechSDK]"
    private let _speechService: TextToSpeechService
    
    private var _debug: Bool = false
    
    /**
    Default object initializer.
    
    - parameter speechService:  Speech service that created the voice.
    
    - returns: An initialized Voice.
    */
    public init (speechService: TextToSpeechService)
    {
        _speechService = speechService
    }
    
    public func say(text: String)
    {
        _speechService.synthesizeSpeech(text, voice: self)
    }
    
    public func say(text: String, completion: CompletionBlock) {
        
        _speechService.synthesizeSpeech(text, voice: self, completion: completion)
    }
    
    public func prepareToSay(text:String)
    {
        _speechService.downloadSpeech(text , voice: self)
    }
}

