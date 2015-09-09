//
//  SpeechToText.swift
//  SpeechToText
//
//  Created by Glenn Fisher on 9/5/15.
//  Copyright (c) 2015 MIL. All rights reserved.
//

/* Helpful Documentation:

    1. Watson: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/speech-to-text/
    2. Alamofire: https://github.com/Alamofire/Alamofire
    3. SwiftyJSON: https://github.com/SwiftyJSON/SwiftyJSON

*/

/* Example Call/Response:

    Call:

        1. SpeechToTextObject.transcribeAudio(pathToAudioFile) { transcript, error in ... }

        2. curl -u "***REMOVED***":"***REMOVED***" \
                -H "content-type: audio/flac" --data-binary @"test-audio.flac" \
                "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize"

    Response:

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

    1. Use callbacks for asynchronous network calls.

    2. Rely on Swift 2.0 idioms (esp. error-handling).

    3. Should we use 3rd-party libraries (Alamofire, SwiftyJSON) or roll our own?
        - If we roll our own, should it expose functionality common across REST APIs?
        - If we roll our own, should we contribute it to the open-source community?
        - If we roll our own and open-source it, why not just support a current open-source project?

    4. How much Speech to Text functionality should be exposed to the user?
        - Get models (/v1/models)? -> Doesn't seem like a run-time decision.
        - Get model details (/v1/models/{model_id})? -> Doesn't seem like a run-time decision.
        - Session vs. sessionless modes? -> Expose session use cases, but hide management details.
        - Multipart files? -> Should be supported somehow, for live/streaming client use cases.
        - Return type? How much data should it expose? -> Enums with map convenience functions that can be chained?
        - How should we expose varying amounts of complexity to the user? (e.g. per-word vs. per-transcription confidence?)

*/

/* TODO:
    
    1. Upgrade to Swift 2.0 idioms (esp. error-handling).
    2. Research and follow conventions for setting the domain of NSError.
    3. Update error-handling (and all code, really) to Swift 2.0.
    4. Determine why the upload() function is troublesome.
        - Why do we seem to need to establish a connection with request() first?
        - Why does it not seem to work every time?
        - Why does it almost seem like there is a race condition? (Perhaps with the GET request?)
    5. Ensure audio files meet the service's size constraints.
    6. Add support for l16 MIME-type.
    7. Add support for additional functionality, in-line with design decisions above.

*/

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