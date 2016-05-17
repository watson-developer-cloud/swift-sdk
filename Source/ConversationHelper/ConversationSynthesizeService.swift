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

// Class that bridges to the Watson TextToSpeech service
class ConversationSynthesizeService {

    private let tts: TextToSpeech
    private let session: NSURLSession

    init(username: String, password: String) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.tts = TextToSpeech(username: username, password: password)
        let session = NSURLSession(configuration: config)
        self.session = session

    }


    /**
     Send the given text message to Watson Engagement Advisor and receive an audio file of it.

     - parameter message: The text message to send. Watson Engagement Advisor will synthesize this message.
     - parameter completionHandler: A function that will be executed with the response returned
     from the Watson Engagement Advisor, or an error if an error occured.
     */
    func synthesizeText(message: String, completionHandler: (NSData?, NSError?) -> Void) {
        tts.synthesize(message, completionHandler: {data, error in

            guard error == nil else {
                completionHandler(nil, error)
                return
            }

            if let data = data {
                print(String(data: data, encoding: NSUTF8StringEncoding))
                completionHandler(data, error)
            }
        })


    }
}
