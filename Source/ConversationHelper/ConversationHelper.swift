/************************************************************************/
/*                                                                      */
/* IBM Confidential                                                     */
/* OCO Source Materials                                                 */
/*                                                                      */
/* (C) Copyright IBM Corp. 2015, 2016                                   */
/*                                                                      */
/* The source code for this program is not published or otherwise       */
/* divested of its trade secrets, irrespective of what has been         */
/* deposited with the U.S. Copyright Office.                            */
/*                                                                      */
/************************************************************************/

import Foundation

/**
 Converse with the Watson Engagement Advisor (WEA) through text and voice. Operations on a ConversationHelper are implicitly async.

 Please visit the IBM website to learn more about Watson Engagement Advisor:
 http://www.ibm.com/smarterplanet/us/en/ibmwatson/engagement_advisor.html
 */

public class ConversationHelper : NSObject {
    /*private let serviceURL: String
    private let workspaceID: String
    private let session: NSURLSession*/
    private let dialogService: DialogService
    private let synthesizeService: ConversationSynthesizeService
    private let speechToTextService: ConversationSpeechToTextService

     /**
     Configures and starts a new ConversationHelper object.
     
     - parameter serviceURL: The base URL of the Watson Engagement Advisor service.
     - parameter workspaceID: The workspace identifier for the workspace to converse with.
     - parameter username: The username to use for HTTP basic authentication.
     - parameter password: The password to use for HTTP basic authentication.
     
     - returns: <#return value description#>
     */
    /*public init(serviceURL: String, workspaceID: String, username: String, password: String, ttsUser: String, ttsPassword: String) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let auth = BasicAuthentication(username: username, password: password)
        let session = NSURLSession(configuration: config, delegate: auth, delegateQueue: nil)
        self.serviceURL = serviceURL
        self.workspaceID = workspaceID
        self.session = session
        
        dialogService = DialogService(serviceURL: serviceURL, workspaceID: workspaceID, username: username, password: password)
        synthesizeService = SynthesizeService(username: ttsUser, password: ttsPassword)
    }*/
     /**
     Configures and starts a new ConversationHelper object.
     
     - parameter dialogService: The base URL of the Watson Engagement Advisor service.
     - parameter synthesizeService: The workspace identifier for the workspace to converse with.
     
     - returns: <#return value description#>
     */
    init(dialogService: DialogService, speechToTextService: ConversationSpeechToTextService, synthesizeService: ConversationSynthesizeService) {
        self.dialogService = dialogService
        self.speechToTextService = speechToTextService
        self.synthesizeService = synthesizeService
    }

    /**
     Sends a text message to the WEA service. This method can be used when the conversation is in a starting context or has an
     existng context.
     
     - parameter message:           Text message that's sent to WEA.
     - parameter context:           Context from a previous point in a ConversationHelper. This can be retrieved from the WEAResponse from a succesful completionHandler.
     - parameter completionHandler: Returns a WEAReponse on success and an NSError when there are issues
     */
    public func sendText(message: String, context: NSDictionary? = nil, completionHandler: (ConversationHelperResponse?, NSError?) -> Void) {
        
        /// must be a better way to convert but this works for now
        var multiArray: [String: String]? = [:]
        if (context != nil) {
            for key in (context?.allKeys)! {
                let value = context?.valueForKey(key as! String)
                multiArray![key as! String] = value as? String
            }
        }
        
        dialogService.sendText(message, context: multiArray) { response, error in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            let weaResponse = ConversationHelperResponse(dialogResponse: response!)
            completionHandler(weaResponse, error)
        }
    }
    
    /**
     Sends a voice file to the SpeechToText service.
     
     - parameter file:              Audio file to send to the SpeechToText service
     - parameter settings:          The settings for the SpeechToText service
     - parameter failureHandler:    Returns an NSError when there is an issue
     - parameter completionHandler: Returns a [SpeechToTextResult]
     */
    public func sendVoiceDiscrete(file: NSURL, settings: SpeechToTextOptions, failureHandler: (NSError -> Void)?, successHandler: NSArray -> Void) {
        
        speechToTextService.transcribeDiscreteAudio(file, settings: settings, failureHandler:  failureHandler) { transcription in
            let wrappedArray = NSMutableArray()
            for item in transcription {
                let wrapper = self.convertSpeechToTextResult(item)
                wrappedArray.addObject(wrapper)
            }
            successHandler(wrappedArray)
        }
    }
    
    /**
     Sends a voice file to the SpeechToText service.
     
     - parameter settings:          The settings for the SpeechToText service
     - parameter failureHandler:    Returns an NSError when there is an issue
     - parameter completionHandler: Returns a [SpeechToTextResult]
     */
    public func sendVoiceContinuous(settings: SpeechToTextOptions, failureHandler: (NSError -> Void)?, successHandler: NSArray -> Void) {
        speechToTextService.transcribeContinuousAudio(settings, failureHandler: failureHandler) { transcription in
            let wrappedArray = NSMutableArray()
            for item in transcription {
                let wrapper = self.convertSpeechToTextResult(item)
                wrappedArray.addObject(wrapper)
            }
            successHandler(wrappedArray)
        }
    }
    
    /**
     Sends a text message to the TextToSpeech service.
     
     - parameter message:           Text message that's sent to TextToSpeech.
     - parameter completionHandler: Returns a WEAReponse on success and an NSError when there are issues
     */
    public func synthesizeText(message: String, completionHandler: (NSData?, NSError?) -> Void) {
        synthesizeService.synthesizeText(message) { data, error in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            completionHandler(data, error)
        }
    }
    
    // ------------------- Converter functions to map Swift object to ObjectiveC
    
    /**
        Converts the full SpeechToTextResult object and returns to main caller

    */
    private func convertSpeechToTextResult(result: SpeechToTextResult)->ConversationSpeechToTextResultWrapper {
        let wrappedTranscription = NSMutableArray()
        let wrappedSingleTranscription              = ConversationSpeechToTextResultWrapper()
        wrappedSingleTranscription.final            = result.final
        wrappedSingleTranscription.alternatives     = self.convertSTTAlternatives(result.alternatives)
        if let keyResults = result.keywordResults {
            for index in keyResults {
                let convertedKeywordResults  = self.convertSTTSpeechToTextKeywordResult(index.1)
                wrappedSingleTranscription.keywordResults[index.0] =  convertedKeywordResults
            }
        }
        if let wordAlternatives = result.wordAlternatives {
            wrappedSingleTranscription.wordAlternatives = self.convertSTTWordAlterativeResults(wordAlternatives)
        }
        wrappedTranscription.addObject(wrappedSingleTranscription)
        return wrappedSingleTranscription
    }
    
    /**
        Converts the SpeechToText result item to a objective c wrapper version
        TODO: Some of this logic can move to the model init
     */
    private func convertSTTWordAlterativeResults(results: [SpeechToTextWordAlternativeResults]) -> NSArray {
        let nsArray = NSMutableArray()
        
        for resultItem in results {
            let wrapper = ConversationSpeechToTextWordAlternativeResultsWrapper()
            wrapper.startTime = resultItem.startTime
            wrapper.endTime = resultItem.endTime
            if(resultItem.alternatives != nil) {
                wrapper.alternatives = convertSTTWordAlterativeResult(resultItem.alternatives)
            }
            nsArray.addObject(wrapper)
        }
        return nsArray
    }
    
    /**
        Converts the SpeechToText result item to a objective c wrapper version
        TODO: Some of this logic can move to the model init
     */
    private func convertSTTWordAlterativeResult(results: [SpeechToTextWordAlternativeResult]) -> NSArray {
        let nsArray = NSMutableArray()
        for resultItem in results {
            let wrapper = ConversationSpeechToTextWordAlternativeResultWrapper()
            wrapper.word = resultItem.word
            wrapper.confidence = resultItem.confidence
            nsArray.addObject(wrapper)
        }
        return nsArray
    }
    
    /**
        Converts the SpeechToText result item to a objective c wrapper version
     */
    private func convertSTTAlternatives(results: [SpeechToTextTranscription]) -> NSMutableArray {
        let nsArray = NSMutableArray()
        for resultItem in results {
            nsArray.addObject(ConversationSpeechToTextTranscriptionWrapper(sttTranscription: resultItem))
        }
        return nsArray
    }

    /**
        Converts the SpeechToText result item to a objective c wrapper version
        TODO: Some of this logic can move to the model init
     */
    private func convertSTTSpeechToTextKeywordResult(results: [SpeechToTextKeywordResult])->NSArray{
        let nsArray = NSMutableArray()
        for resultItem in results {
            let wrapper = ConversationSpeechToTextKeywordResultWrapper()
            wrapper.confidence = resultItem.confidence
            wrapper.endTime = resultItem.endTime
            wrapper.normalizedText = resultItem.normalizedText
            wrapper.startTime = resultItem.startTime
            nsArray.addObject(wrapper)
        }
        return nsArray
    }
}

