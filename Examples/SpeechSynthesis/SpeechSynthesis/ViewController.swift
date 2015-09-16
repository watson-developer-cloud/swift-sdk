//
//  ViewController.swift
//  SpeechSynthesis
//
//  Created by Glenn Fisher on 9/16/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import UIKit

import AVFoundation
import WatsonTextToSpeech

class ViewController: UIViewController, NSURLSessionDelegate {
    
    //lazy var ttsService = WatsonTextToSpeechService(username: "user", password: "password")
    
    
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
        
        
        
        let fileURL = NSBundle.mainBundle().URLForResource("spain", withExtension: "wav")
        
        if let url = fileURL
        {
            let data = NSData(contentsOfURL: url)
            
            if let d = data {
                let pcm = createPCM( d )
                
                playAudioPCM(audioEngine, audioSegment: pcm)
            }
        } else
        {
            print("Could not find the audio file spain")
        }
        
        //ttsService.synthesizeSpeech(<#T##text: String##String#>, voice: <#T##Voice#>)("All the problems of the world could be settled easily if men were only willing to think.")
        
        
        // UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        print("Pressed")
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