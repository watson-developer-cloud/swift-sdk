/**
*   TextToSpeechSDK
*   Constants.swift
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

struct Endpoints
{
    static let TTS_ENDPOINT = "https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize"
}


struct StatusCodes
{
    static let SUCCESS:Int = 200
    static let BAD_AUTH:Int = 401
}

struct NetworkOptions
{
    static let TIMEOUT_REQUEST = 30.0
    static let TIMEOUT_RESOURCE = 60.0
    static let HTTP_CONNECTIONS_PER_HOST = 1
}

func getVoiceId(gender: VoiceGender, language: VoiceLanguage) -> String
{
    switch (gender)
    {
    case .Male:
        
        switch (language)
        {
        case .German:
            return "de-DE_DieterVoice"
        case .EnglishUS:
            return "en-US_MichaelVoice"
        case .Spanish:
            return "es-ES_EnriqueVoice"
        default:
            return "en-US_MichaelVoice"
        }
        
    case .Female:
        
        switch (language)
        {
        case .German:
            return "de-DE_BirgitVoice"
        case .EnglishUS:
            return "en-US_AllisonVoice"
        default:
            return "en-US_AllisonVoice"
        }
        
    }
}