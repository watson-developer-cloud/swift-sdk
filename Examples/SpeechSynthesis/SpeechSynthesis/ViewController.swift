//
//  ViewController.swift
//  SpeechSynthesis
//
//  Created by Robert Dickerson on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import UIKit

import AVFoundation
import WatsonSDK

class ViewController: UIViewController, NSURLSessionDelegate {
    
    // lazy var ttsService = WatsonTextToSpeechService(username: "user", password: "password")
    
    var i = 0;
    
    let sayings:[String] = ["All the problems of the world could be settled easily if men were only willing to think.",
        "When you come to a fork in the road, take it.",
        "You can observe a lot by just watching.",
        "It ain't over till it's over.",
        "No one goes there nowadays, it's too crowded.",
        "Always go to other people's funerals, otherwise they won't come to yours.",
        "A nickel ain't worth a dime anymore.",
        "Baseball is 90 percent mental and the other half is physical",
        "In theory there is no difference between theory and practice. In practice, there is.",
        "I never said most of the things I said.",
        "Little League baseball is a very good thing because it keeps the parents off the streets."
    ]
    
    @IBOutlet weak var speechTextView: UITextView!
    @IBAction func swipeGesureRecognizer(sender: AnyObject) {
        print("Swiped!")
        i++;
        speechTextView.text = sayings[i%sayings.count]
    }
    

    let ttsService = TextToSpeech()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ttsService.setUsernameAndPassword(
            "***REMOVED***",
            password: "***REMOVED***")
        
        // var error: NSError?
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func handlePress(sender: AnyObject) {
        
        
        
        
        // let voice = ttsService.getDefaultVoice()
        
        let toSay = speechTextView.text
        
        if (toSay != "") {
            ttsService.synthesize(toSay, oncompletion: {
                
                data, error in
                
                if let data = data {
                
                    do {
                        let player = try AVAudioPlayer(data: data)
                        player.prepareToPlay()
                        player.play()
                    } catch {
                        
                    }
                        
                }
                
            })
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

