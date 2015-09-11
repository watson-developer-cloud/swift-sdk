//
//  ViewController.swift
//  SpeechToText
//
//  Created by Glenn Fisher on 9/5/15.
//  Copyright (c) 2015 MIL. All rights reserved.
//

import UIKit

var sessionID = ""

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testWatsonSpeechToText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** Test Watson Speech to Text service with sample .flac file. */
    func testWatsonSpeechToText() {
        
        let fileURL = NSBundle.mainBundle().URLForResource("test-audio", withExtension: "flac")
        let stt = WatsonSpeechToText(username: "***REMOVED***", password: "***REMOVED***") // todo: remove credentials
        stt.transcribeFile(fileURL!) { transcription, error in
            if let transcription = transcription {
                // textField.text = transcription
                print(transcription)
            } else if let error = error {
                print(error)
            } else {
                print("Unexpected result. What happened?")
            }
        }

    }

}

