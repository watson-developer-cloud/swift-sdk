//
//  ViewController.swift
//  SpeechSynthesis
//
//  Created by Robert Dickerson on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import UIKit

import AVFoundation
import WatsonTextToSpeech

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
    
    lazy var player : AVAudioPlayer = AVAudioPlayer()
    lazy var audioEngine : AVAudioEngine = AVAudioEngine()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // var error: NSError?
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func handlePress(sender: AnyObject) {
        
        
        let ttsService = WatsonTextToSpeechService(username: "76b77f2f-a0ea-49a7-ad34-53b5636326ec",
            password: "ggzipaZ7L3o0")
        let voice = ttsService.getDefaultVoice()
        
        let toSay = speechTextView.text
        
        if (toSay != "") {
            voice.say(toSay)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

extension ViewController {
    
    func playLocalFile(name : String)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let fileURL = NSBundle.mainBundle().URLForResource("spain2", withExtension: "wav")
        
        do {
            
            player = try AVAudioPlayer(contentsOfURL: fileURL!)
            
            
            
            print("Duration is \(player.duration)")
            
            player.prepareToPlay()
            player.numberOfLoops = -1
            player.play()
            
            
            
        } catch let error as NSError {
            
            print(error.localizedDescription)
            
        }
    }
    
}