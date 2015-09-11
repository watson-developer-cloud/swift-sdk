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

    
    var speech = [SpeechSample]()
    let pendingOperations = PendingOperations()
    
    var player : AVAudioPlayer?
    var audioEngine : AVAudioEngine?
    
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
        
        if (audioEngine==nil) { audioEngine = AVAudioEngine()}
        
        let fileURL = NSBundle.mainBundle().URLForResource("spain", withExtension: "wav")
        
        if let url = fileURL
        {
            let data = NSData(contentsOfURL: url)
            
            if let d = data {
                let pcm = createPCM( d )
                playAudioPCM(audioEngine!, data: pcm.samples)
            }
        }
        
       
        
        let speechRequest = SpeechSample(text: "The rain in Spain stays mainly in the plain.")
        self.speech.append(speechRequest)
        
        let downloader = SpeechDownloader(speechSample: speechRequest )
        
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                //self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                
            })
        }
        
        // Uncomment this to make the network call
        // pendingOperations.downloadQueue.addOperation(downloader)

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
            
            if let p = player {
                
                print("Duration is \(p.duration)")
                
                p.prepareToPlay()
                p.numberOfLoops = -1
                p.play()
                
            }
            
        } catch let error as NSError {
            
            print(error.localizedDescription)
        
        }
    }
    
}