//
//  WatsonSpeechToText.swift
//  WatsonSpeechToText
//
//  Created by Glenn Fisher on 9/16/15.
//  Copyright © 2015 MIL. All rights reserved.
//

/* Watson Speech To Text Service

    Documentation:

        http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/speech-to-text/

    Example Call:

        1. SpeechToTextObject.transcribeAudio(pathToAudioFile) { transcript, error in ... }

        2. curl -u "***REMOVED***":"***REMOVED***" \
           -H "content-type: audio/flac" --data-binary @"test-audio.flac" \
           "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize"

    Example Response:

        {
            "results": [
                {
                    "alternatives": [
                        {
                            "confidence": 0.869285523891449,
                            "transcript": "several tornadoes touch down as a line of severe thunderstorms swept through colorado on sunday "
                        }
                    ],
                    "final": true
                }
            ],
            "result_index": 0
        }

*/

/* Design Decisions and Questions:

    How much functionality should be exposed to (or hidden from) the user?
    - Get models (/v1/models)? -> Doesn't seem like a run-time decision.
    - Get model details (/v1/models/{model_id})? -> Doesn't seem like a run-time decision.
    - Session vs. sessionless modes? -> Expose session use cases, but hide management details.
    - Multipart files? -> Should be supported somehow, for live/streaming client use cases.
    - Return type? How much data should it expose? -> Enums with map convenience functions that can be chained?
    - How should we expose varying amounts of complexity to the user? (e.g. per-word vs. per-transcription confidence?)

*/

/* TODO:

    - Determine why the upload() function is troublesome.
    - Ensure audio files meet the service's size constraints.
    - Add support for l16 MIME-type.
    - Add support for additional functionality, in-line with design decisions above.

*/

import Foundation

import Foundation

public class WatsonSpeechToText {
    
    private let baseURL = "https://stream.watsonplatform.net/speech-to-text/api"
    private let tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    
    private let username: String
    private let password: String
    private var token: String
    
    /** Initialize the Watson Speech To Text service. */
    public init(username: String, password: String) {
        
        self.username = username
        self.password = password
        self.token = ""
        
    }
    
    /** Transcribe an audio file. */
    public func transcribeFile(file: NSURL, completionHandler: (String?, NSError?) -> Void) {
        
        // ensure audio file format is supported by Watson
        let contentType = MIMETypeOfFile(file)
        if contentType == nil {
            let error = NSError(domain: "FileType", code: 415, userInfo: [NSLocalizedDescriptionKey:"Unsupported media type"])
            completionHandler(nil, error)
            return
        }
        
        // establish connection to Watson Speech to Text service
        let endpoint = "\(baseURL)/v1/recognize"
        request(.GET, endpoint)
            .authenticate(user: username, password: password)
            .responseString() { _, _, _, _ in }
        
        // query Watson for transcript
        let headers = ["Content-Type": contentType!]
        upload(.POST, endpoint, headers: headers, file: file)
            .authenticate(user: username, password: password)
            .validate(contentType: ["application/json"])
            .responseJSON() { _, _, body, error in
                
                // successful transcription
                if let body: AnyObject = body {
                    let json = JSON(body)
                    let transcript = json["results"][0]["alternatives"][0]["transcript"].stringValue
                    completionHandler(transcript, nil)
                }
                    
                    // networking error
                else if let error = error {
                    completionHandler(nil, error)
                }
                    
                    // unknown error
                else {
                    let error = NSError(domain: "Unknown", code: 500, userInfo: [NSLocalizedDescriptionKey:"Internal server error"])
                }
                
        }
    }
    
    /** Retrieve an authentication token. */
    private func retrieveAuthenticationToken() {
        
        let authenticationURL = "\(tokenURL)?url=\(baseURL)"
        request(.GET, authenticationURL)
            .authenticate(user: username, password: password)
            .validate(contentType: ["application/json"])
            .responseString { _, _, body, _ in
                
                if let body = body {
                    self.token = body
                }
                
        }
    }
    
    /** Return a file's MIME Content-Type, if supported by the Watson Speech to Text service.
    Supported Content-Types: audio/wav, audio/flac, audio/l16 */
    private func MIMETypeOfFile(file: NSURL) -> String? {
        
        var contentType: String?
        let fileExtension = file.pathExtension?.lowercaseString
        if let fileExtension = fileExtension {
            
            switch (fileExtension) {
            case "wav":
                contentType = "audio/wav"
            case "flac":
                contentType = "audio/flac"
            default:
                contentType = nil
            }
            
        }
        
        return contentType
        
    }
    
}