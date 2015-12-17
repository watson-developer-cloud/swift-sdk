/**
 * Copyright IBM Corporation 2015
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

import UIKit
import AVFoundation

import WatsonSDK

extension SpeechRecognitionViewController: ChildProtocol {
    
    var childTitle: String! {
        
        return "Speech Recognition"
        
    }
    
}

class SpeechRecognitionViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var startStopRecordingButton: UIButton!
    @IBOutlet weak var playRecordingButton: UIButton!
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var transcriptionField: UITextView!
    
    
    var sttService : SpeechToText?
    var player: AVAudioPlayer? = nil
    var recorder: AVAudioRecorder!
    
    private let username = ""
    private let password = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // create file to store recordings
        let filePath = NSURL(fileURLWithPath: "\(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])/SpeechToTextRecording.wav")
        
        // set up session and recorder
        let session = AVAudioSession.sharedInstance()
        var settings = [String: AnyObject]()
        // settings[AVFormatIDKey] = NSNumber(unsignedInt: kAudioFormatMPEG4AAC)
        settings[AVSampleRateKey] = NSNumber(float: 44100.0)
        settings[AVNumberOfChannelsKey] = NSNumber(int: 1)
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            recorder = try AVAudioRecorder(URL: filePath, settings: settings)
        } catch {
            print("Error setting up session or recorder.")
        }
        
        // ensure recorder is set up
        guard let recorder = recorder else {
            print("Could not set up recorder.")
            return
        }
        
        // prepare recorder to record
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
        
        // disable play and transcribe buttons
        playRecordingButton.enabled = false
        transcribeButton.enabled = false
        
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                let username = dict["SpeechToTextUsername"]
                let password = dict["SpeechToTextPassword"]
                
                let basicAuth = BasicAuthenticationStrategy(
                    tokenURL: "https://stream.watsonplatform.net/authorization/api/v1/token",
                    serviceURL: "https://stream.watsonplatform.net/speech-to-text/api",
                    username: username!,
                    password: password!)
                
                sttService = SpeechToText(authStrategy: basicAuth)
                
            }
        }
        
        
        
    }
    
    @IBAction func startStopRecording() {
        
        guard let recorder = recorder else {
            print("Recorder not properly set up.")
            return
        }
        
        if let player = player {
            if (player.playing) {
                player.stop()
            }
        }
        
        if (!recorder.recording) {
            do {
                print("Starting recording...")
                let session = AVAudioSession.sharedInstance()
                try session.setActive(true)
                recorder.record()
                startStopRecordingButton.setTitle("Stop Recording", forState: .Normal)
                playRecordingButton.enabled = false
                transcribeButton.enabled = false
            } catch {
                print("Error setting session active.")
            }
        } else {
            do {
                print("Stopping recording...")
                recorder.stop()
                let session = AVAudioSession.sharedInstance()
                try session.setActive(false)
                startStopRecordingButton.setTitle("Start Recording", forState: .Normal)
                playRecordingButton.enabled = true
                transcribeButton.enabled = true
            } catch {
                print("Error setting session inactive.")
            }
        }

    }

    @IBAction func playRecording() {
        
        guard let recorder = recorder else {
            print("Recorder not properly set up")
            return
        }
        
        if (!recorder.recording) {
            do {
                player = try AVAudioPlayer(contentsOfURL: recorder.url)
                player?.play()
            } catch {
                print("Error creating audio player with recorded file.")
            }
        }
        
    }

    @IBAction func transcribe() {
        
        guard let recorder = recorder else {
            print("Recorder not properly set up.")
            return
        }
        
        print("Transcribing recording...")
        
        if let sttService = sttService {
            
            let data = NSData(contentsOfURL: recorder.url)
            
            if let data = data {
                sttService.transcribe(data , format: .WAV, oncompletion: {
                
                    response, error in
                
                        // print(response)
                    
                    
                    self.transcriptionField.text = response?.transcription()
                    
                })
            } else {
                Log.sharedLogger.error("Could not find data at \(recorder.url)")
            }
            
        }
        // let stt = WatsonSpeechToText(username: username, password: password)
//        sttService.transcribeFile(recorder.url) {
//            string, error in
//            dispatch_async(dispatch_get_main_queue()) {
//                if let transcription = string {
//                    self.transcriptionField.text = "\(transcription)"
//                } else if let error = error {
//                    self.transcriptionField.text = "\(error)"
//                } else {
//                    self.transcriptionField.text = "Error transcribing audio. No response from the server."
//                }
//            }
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

