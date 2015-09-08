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
        let stt = WatsonSpeechToText(username: "004db54a-c5e0-472b-a6eb-7b106fd31370", password: "o55eeuCST9YU") // todo: remove credentials
        stt.transcribeFile(fileURL!) { transcription, error in
            if let transcription = transcription {
                // textField.text = transcription
                println(transcription)
            } else if let error = error {
                println(error)
            } else {
                println("Unexpected result. What happened?")
            }
        }

    }

}

