//
//  SpeechToText.swift
//  SpeechToText
//
//  Created by Glenn Fisher on 9/5/15.
//  Copyright (c) 2015 MIL. All rights reserved.
//

// Watson Documentation: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/speech-to-text/
// Alamofire Documentation: https://github.com/Alamofire/Alamofire

// todo: What conventions are used when setting the domain of an NSError?

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
        
        // ensure audio file is supported by Watson
        let contentType = MIMETypeOfFile(file)
        if contentType == nil {
            let error = NSError(domain: "FileType", code: 415, userInfo: [NSLocalizedDescriptionKey:"Unsupported media type"])
            completionHandler(nil, error)
            return
        }
        
        // query Watson for transcript
        let endpoint = "\(baseURL)/v1/recognize"
        let headers = ["content-type":contentType!]
        upload(.POST, endpoint, headers: headers, file: file)
            .authenticate(user: username, password: password, persistence: .None)
            .validate(contentType: ["application/json"])
            .responseJSON() { _, _, body, error in
                
                println("This branch is never reached.") // todo: debugging
                
                // successful transcription
                if let body: AnyObject = body {
                    // let transcript = body["results"]["alternatives"]["transcript"]
                    let transcript = "\(body)" // todo: debugging
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
                // todo: what's l16?!
            default:
                contentType = nil
            }
            
        }
        
        return contentType
        
    }
    
}