//
//  WatsonSpeechToText.swift
//  WatsonSpeechToText
//
//  Created by Glenn R. Fisher on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import WatsonCore

/**
The WatsonSpeechToText class is a convenient wrapper around the IBM Watson Speech to Text service available on BlueMix.

let stt = WatsonSpeechToText(username: username, password: password)
stt.transcribeFile(file: file) {
string, error in /* handle return values */
}

:param: username A string representing the username used to access the Watson Speech to Text service.
:param: password A string representing the password used to access the Watson Speech to Text service.
*/
public class WatsonSpeechToText {
    
    private let serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
    private let authentication: WatsonAuthentication
    
    /**
    Initialize the Watson Speech To Text service.
    */
    public init(username: String, password: String) {
        
        self.authentication = WatsonAuthentication(serviceURL: serviceURL, username: username, password: password)
        
    }
    
    /**
    An abstraction of a common pattern for handling asynchronous errors.
    */
    private func asynchronousError(function: String, message: String, code: Int?, completionHandler: (String?, NSError?) -> Void) {
        
        WatsonError("\(function): \(message)")
        let userInfo = [NSLocalizedDescriptionKey: message]
        let codeUnwrapped: Int
        if let code = code {
            codeUnwrapped = code
        } else {
            codeUnwrapped = 0
        }
        let error = NSError(domain: "WatsonSpeechToText", code: codeUnwrapped, userInfo: userInfo)
        completionHandler(nil, error)
        
    }
    
    /**
    Transcribe an audio file.
    */
    public func transcribeFile(file: NSURL, completionHandler: (String?, NSError?) -> Void) {
        
        let function = "WatsonSpeechToText.transcribeFile()"
        
        // get audio data from file
        guard let audioData = NSData(contentsOfURL: file) else {
            let message = "Cannot read audio file."
            asynchronousError(function, message: message, code: 0, completionHandler: completionHandler)
            return
        }
        
        // get content type and ensure it is supported by Watson
        guard let contentType = MIMETypeOfFile(file) else {
            let message = "Unsupported media type."
            asynchronousError(function, message: message, code: 415, completionHandler: completionHandler)
            return
        }
        
        transcribeData(audioData, contentType: contentType, completionHandler: completionHandler)
    }
    
    /**
    Transcribe audio data.
    */
    public func transcribeData(audioData: NSData, contentType: String, completionHandler: (String?, NSError?) -> Void) {

        let function = "WatsonSpeechToText.transcribeData()"
        
        // GET to establish connection
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: authentication, delegateQueue: nil)
        let endpoint = "\(serviceURL)/v1/recognize"
        let url = NSURL(string: endpoint)
        if let url = url {
            let dataTask = session.dataTaskWithURL(url) {
                data, response, error in
                
                // ensure GET response status code of 200
                let getStatusCode = (response as? NSHTTPURLResponse)?.statusCode
                guard getStatusCode == 200 else {
                    let message = "HTTP error code returned for GET request."
                    self.asynchronousError(function, message: message, code: getStatusCode, completionHandler: completionHandler)
                    return
                }
                
                // POST to send audio file
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.HTTPBody = audioData
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
                let uploadTask = session.dataTaskWithRequest(request) {
                    data, response, error in
                    
                    // ensure POST response status code of 200
                    let postStatusCode = (response as? NSHTTPURLResponse)?.statusCode
                    guard postStatusCode == 200 else {
                        let message = "HTTP error code returned for POST request."
                        self.asynchronousError(function, message: message, code: postStatusCode, completionHandler: completionHandler)
                        return
                    }
                    
                    // ensure response data is not nil
                    guard let data = data else {
                        let message = "Nil data returned for POST request."
                        self.asynchronousError(function, message: message, code: postStatusCode, completionHandler: completionHandler)
                        return
                    }
                    
                    // parse response data as JSON
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                        let transcript = json.valueForKey("results")?.objectAtIndex(0).valueForKey("alternatives")?.objectAtIndex(0).valueForKey("transcript") as? String
                        completionHandler(transcript, nil)
                    } catch let error {
                        let message = "Error parsing JSON: \(error)"
                        self.asynchronousError(function, message: message, code: postStatusCode, completionHandler: completionHandler)
                        return
                    }

                }
                uploadTask.resume()
            }
            dataTask.resume()
        }
        
    }
    
    /**
    Return a file's MIME Content-Type, if supported by the Watson Speech to Text service.
    
    Supported Content-Types: audio/wav, audio/flac, audio/l16
    */
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