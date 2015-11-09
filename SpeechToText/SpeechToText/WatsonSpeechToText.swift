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
Major Design Decisions:
1. All asynchronous (but can register delegate for interim results)
2. Client functions v. service functions
3. Define constant strings for convenience + flexibility
4. Integrate service API endpoint defaults into Swift
*/

// todo: does it violate standard Swift style to default optional delegates to nil?

public class WatsonSpeechToText {
    
    private let serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
    private let authentication: WatsonAuthentication
    
    /**
    Initialize the Watson Speech To Text service.
    */
    public init(username: String, password: String) {
        self.authentication = WatsonAuthentication(serviceURL: serviceURL, username: username, password: password)
    }
    
    /*******************************************************************
    * Client Functions: These functions are intended for use by the
    * framework's client. They expose the functionality of the service
    * in convenient, easy-to-use functions for Swift developers.
    *******************************************************************/
    
    /**
    Transcribe an audio file.
    */
    public func recognize(audio: NSURL, model: String = en_us_broadbandModel, delegate: WatsonSpeechToTextDelegate? = nil, completionHandler: (WatsonSpeechToTextResults?, WatsonSpeechToTextError?) -> Void) {
        
    }
    
    /**
    Transcribe multiple audio files.
    */
    public func recognize(audio: [NSURL], model: String = en_us_broadbandModel, delegate: WatsonSpeechToTextDelegate? = nil, completionHandler: (WatsonSpeechToTextResults?, WatsonSpeechToTextError?) -> Void) {
        
    }
    
    /**
    Transcribe audio data.
    */
    public func recognize(audio: NSData, model: String = en_us_broadbandModel, contentType: String, delegate: WatsonSpeechToTextDelegate? = nil, completionHandler: (WatsonSpeechToTextResults?, WatsonSpeechToTextError?) -> Void) {
        
    }
    
    /**
    Transcribe multiple audio data parts.
    */
    public func recognize(audio: [NSData], model: String = en_us_broadbandModel, contentType: String, delegate: WatsonSpeechToTextDelegate? = nil, completionHandler: (WatsonSpeechToTextResults?, WatsonSpeechToTextError?) -> Void) {
        
    }
    
    /**
    Transcribe an audio stream.
    */
    // public func recognize(audio: NSStream, contentType: String, delegate: WatsonSpeechToTextDelegate? = nil, completionHandler: (WatsonSpeechToTextResults?, WatsonSpeechToTextError?) -> Void)
        // want stream to be asynchronous:
        // (1) client maintains reference to stream
        // (2) client obtains new audio (e.g. from microphone)
        // (3) client pushes new audio onto stream
        // (4) class recognizes new audio in stream
        // (5) class sends results to delegate
    
    /*******************************************************************
    * Service Helper Functions: These functions map directly to the
    * endpoints of the service, but are not exposed to the client.
    * Instead, they abstract the service's functionality for internal
    * use only (i.e. for use by the client functions).
    *******************************************************************/
    
    /**
    Retrieve the models available for the Watson Speech to Text service.
    */
    private func retrieveModels(completionHandler: ([WatsonSpeechToTextModel]?, WatsonSpeechToTextError?) -> Void) {
        // GET /v1/models
    }
    
    /**
    Retrieve information about an available model.
    */
    private func retrieveModel(model: String, completionHandler: (WatsonSpeechToTextModel?, WatsonSpeechToTextError?) -> Void) {
        // GET /v1/models/{model_id}
    }
    
    /**
    Create a session.
    */
    private func createSession(model: String = en_us_broadbandModel, completionHandler: (WatsonSpeechToTextSession?, WatsonSpeechToTextError?) -> Void) {
        // POST /v1/sessions/
    }
    
    /**
    Delete a session.
    */
    private func deleteSession(session: WatsonSpeechToTextSession, completionHandler: WatsonSpeechToTextError? -> Void) {
        // DELETE /v1/sessions/{session_id}
    }
    
    /**
    Observe results for a recognition task within a session.
    */
    private func observeResult(session: WatsonSpeechToTextSession, sequenceID: Int?, interimResults: Bool = false, trainingOptOut: Bool = true, completionHandler: (WatsonSpeechToTextResults?, WatsonSpeechToTextError?) -> Void) {
        // GET /v1/sessions/{session_id}/observe_result
    }

    /**
    Check whether the session is ready to accept a new recognition task.
    */
    private func isSessionAvailable(session: WatsonSpeechToTextSession, completionHandler: (WatsonSpeechToTextSessionAvailability?, WatsonSpeechToTextError?) -> Void) {
        // GET /v1/sessions/{session_id}/recognize
    }
    
    /**
    Send audio for speech recognition within a session.
    */
    private func recognize(session: WatsonSpeechToTextSession, contentType: String, audio: NSData, sequenceID: Int?, continuous: Bool = false, maxAlternatives: Int = 1, timestamps: Bool = false, wordConfidence: Bool = false, inactivityTimeout: Int = 30, chunked: Bool = false, trainingOptOut: Bool = true, completionHandler: (WatsonSpeechToTextResults?, WatsonSpeechToTextError?) -> Void) {
        // POST /v1/sessions/{session_id}/recognize
    }
    
    /**
    Send audio as multipart for speech recognition within a session.
    */
    private func recognize(session: WatsonSpeechToTextSession, parts: [WatsonSpeechToTextPart], chunked: Bool = false, trainingOptOut: Bool = true, completionHandler: (WatsonSpeechToTextResults?, WatsonSpeechToTextError?) -> Void) {
        // POST /v1/sessions/{session_id}/recognize
    }
    
    /**
    Send audio for speech recognition in sessionless mode.
    */
    private func recognize(contentType: String, audio: NSData, model: String = en_us_broadbandModel, continuous: Bool = false, maxAlternatives: Int = 1, timestamps: Bool = false, wordConfidence: Bool = false, inactivityTimeout: Int = 30, chunked: Bool = false, trainingOptOut: Bool = true, completionHandler: (WatsonSpeechToTextResults?, WatsonSpeechToTextError?) -> Void) {
        // POST /v1/recognize
    }
    
    /**
    Send audio as multipart for speech recognition in sessionless mode.
    */
    private func recognize(model: String = en_us_broadbandModel, parts: [WatsonSpeechToTextPart], chunked: Bool = false, trainingOptOut: Bool = true, completionHandler: (WatsonSpeechToTextResults?, WatsonSpeechToTextError?) -> Void) {
        // POST /v1/recognize
    }

    
    /*******************************************************************
    * Generic Helper Functions: These functions abstract common patterns
    * that are *not* directly related to the service's functionality or
    * endpoints.
    *******************************************************************/
    
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
    
    /**
    An abstraction of a common pattern for handling asynchronous errors.
    */
    private func asynchronousError(function: String, message: String, code: Int?, completionHandler: (String?, NSError?) -> Void) {
        
        Log.sharedLogger.error("\(function): \(message)")
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
    
    /*******************************************************************
    * MVP Functions: These functions may or may not find their way
    * into the released framework. They are primarily intended for
    * the developer to gain familiarity with the service and to
    * rapidly prototype an MVP demo app.
    *******************************************************************/
    
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

    
}