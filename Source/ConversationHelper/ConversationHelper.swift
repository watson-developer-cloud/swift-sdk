/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation

/**
 Converse with the Watson Engagement Advisor (WEA) through text and voice. Operations on a ConversationHelper are implicitly async.

 Please visit the IBM website to learn more about Watson Engagement Advisor:
 http://www.ibm.com/smarterplanet/us/en/ibmwatson/engagement_advisor.html
 */

public class ConversationHelper : NSObject {

    private let conversationService: Conversation
    private let synthesizeService: ConversationSynthesizeService
    private let speechToTextService: ConversationSpeechToTextService

    /**
    Configures and starts a new ConversationHelper object.

    - parameter dialogService: The base URL of the Watson Engagement Advisor service.
    - parameter synthesizeService: The workspace identifier for the workspace to converse with.
    */
    init(conversationService: Conversation, speechToTextService: ConversationSpeechToTextService, synthesizeService: ConversationSynthesizeService) {
        self.conversationService = conversationService
        self.speechToTextService = speechToTextService
        self.synthesizeService   = synthesizeService
    }

    /**
     Sends a text message to the WEA service. This method can be used when the conversation is in a starting context or has an
     existng context.

     - parameter message:           Text message that's sent to WEA.
     - parameter context:           Context from a previous point in a ConversationHelper. This can be retrieved from the WEAResponse from a succesful completionHandler.
     - parameter completionHandler: Returns a WEAReponse on success and an NSError when there are issues
     */
    public func sendText(message: String, context: NSDictionary? = nil, completionHandler: (ConversationMessageResponse?, NSError?) -> Void) {

        /// must be a better way to convert but this works for now
        var multiArray: [String: String]? = [:]
        if (context != nil) {
            for key in (context?.allKeys)! {
                let value = context?.valueForKey(key as! String)
                multiArray![key as! String] = value as? String
            }
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
