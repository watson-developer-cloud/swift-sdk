//
//  ViewController.swift
//  TextSpeech
//
//  Created by Robert Dickerson on 9/3/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import UIKit

import AVFoundation
import TextToSpeech

class ViewController: UIViewController, NSURLSessionDelegate {

    lazy var ttsService : WatsonTextToSpeech = WatsonTextToSpeech()
    
    
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
        
        ttsService.synthesize("All the problems of the world could be settled easily if men were only willing to think.")
        
       
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