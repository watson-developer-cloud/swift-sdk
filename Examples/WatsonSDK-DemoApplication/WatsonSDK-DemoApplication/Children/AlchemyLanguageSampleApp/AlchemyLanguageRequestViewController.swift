//
//  AlchemyLanguageRequestViewController.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/8/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit
import WatsonSDK

class AlchemyLanguageRequestViewController: UIViewController {
    
    @IBAction func closeButtonPress() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    var _requestType: AlchemyLanguageConstants.RequestType!
    var requestType: AlchemyLanguageConstants.RequestType! {
        get { assert(_requestType != nil, "Set AlchemyLanguageRequestViewController requestType before displaying."); return _requestType }
        set { _requestType = newValue }
    }
    
    var _requestString: String!
    var requestString: String! {
        get { assert(_requestString != nil, "Set AlchemyLanguageRequestViewController requestString before displaying."); return _requestString }
        set { _requestString = newValue }
    }
    
    // sizing
    var screenBounds: CGRect { return UIScreen.mainScreen().bounds }
    var screenWidth: CGFloat { return screenBounds.size.width }
    var screenHeight: CGFloat { return screenBounds.size.height }
    
    var activeOriginY: CGFloat { return closeButton.frame.origin.y + closeButton.frame.size.height }
    var activeHeight: CGFloat { return screenHeight - activeOriginY }
    
    // area of screen to use below X button
    var activeFrame: CGRect {
        
        return CGRect(
            x: 0.0,
            y: activeOriginY,
            width: screenWidth,
            height: activeHeight
        )
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // activity indicator
        self.activityIndicatorView = UIActivityIndicatorView(frame: CGRect(
            origin: CGPointZero,
            size: CGSize(
                width: 50.0,
                height: 50.0
            )
        ))
        
        self.activityIndicatorView.center = self.view.center
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.startAnimating()
        
        print(self.activityIndicatorView)
        print(self.activityIndicatorView.frame)
        
        // api key
        var apiKey: String?
        
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                apiKey = dict["AlchemyAPIKey"]
            }
        }
        
        if let apiKey = apiKey {
            
        } else {
            
            displayError()
            
        }
        
        // start request
        let alchemyLanguage = AlchemyLanguage(apiKey: "")
        
            // on completion
        
            // if success
                // play animation where green / stop
                // parse objects
                // fade out indicator
                // add objects hidden, fade in objects
        
            // if failure
                // red indicator
                // alert with failure, try again
        
    }
    
    private func displayError() {
        
        if self.activityIndicatorView != nil {

            self.activityIndicatorView.hidesWhenStopped = false
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.color = UIColor.redColor()
            
        }
        
        let alertController = UIAlertController(
            title: "Network Error Occurred",
            message:"Please try again.",
            preferredStyle: .Alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alertController, animated: true){ }
        
    }
    
}
