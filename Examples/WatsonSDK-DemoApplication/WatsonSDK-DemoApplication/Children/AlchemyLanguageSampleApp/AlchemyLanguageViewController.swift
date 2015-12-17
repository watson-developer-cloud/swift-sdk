//
//  AlchemyLanguageViewController.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/7/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import WatsonSDK


// MARK: ChildProtocol
extension AlchemyLanguageViewController: ChildProtocol {
    
    var childTitle: String! {
        
        return "AlchemyLanguageViewController"
        
    }
    
}


// MARK: Convenience
extension AlchemyLanguageViewController {
    
    typealias alcs = AlchemyLanguageConstants
    
}


// MARK: AlchemyLanguageViewController
class AlchemyLanguageViewController: UIViewController {

    // ibactions
    @IBAction func goURLButtonPress() { presentResponseViewControllerWithRequestType(.URL, requestString: self.urlTextField.text) }
    @IBAction func goTextButtonPress() { presentResponseViewControllerWithRequestType(.Text, requestString: self.textTextView.text) }
    
    // iboutlets
    @IBOutlet weak var urlDemoLabel: UILabel!
    @IBOutlet weak var textDemoLabel: UILabel!
        
    @IBOutlet weak var goURLButton: UIButton!
    @IBOutlet weak var goTextButton: UIButton!
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var textTextView: UITextView!
    
    var requestVC: AlchemyLanguageRequestViewController!
    
    // title animation
    var titleAnimation: SKView!
    
    let animationDuration = NSTimeInterval(0.75)
    
    
    // setup
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureButtons()
        
        // TODO remove when ready to handle URLs
        func temporarilyRemoveURLCapabilities() {
            
            self.urlDemoLabel.hidden = true
            self.goURLButton.hidden = true
            self.urlTextField.hidden = true
            
        }
        
        temporarilyRemoveURLCapabilities()
        
    }
    
    private func configureButtons() {
        
        configureButton(self.goURLButton)
        configureButton(self.goTextButton)
        
    }
    
    private func configureButton(button: UIButton!) {
        
        let backgroundBlue = UIColor(rgba: "#89d6fb")
        let textNormalBlue = UIColor(rgba: "#02577a")
        let textPressedBlue = UIColor(rgba: "#01303f")
        
        button.setTitleColor(textNormalBlue, forState: .Normal)
        button.setTitleColor(textPressedBlue, forState: .Highlighted)
        
        let layer = button.layer
        
        layer.cornerRadius = 5.0
        layer.borderColor = backgroundBlue.CGColor
        layer.backgroundColor = backgroundBlue.CGColor
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        runAnimation()
        
    }
    
    private func runAnimation() {
        
        // TODO: animate in AlchemyLanguage at top
        
    }
    
    private func presentResponseViewControllerWithRequestType(requestType: alcs.RequestType, requestString: String!) {
        
        func verifyUrl (urlString: String?) -> Bool {
            if let urlString = urlString, let url = NSURL(string: urlString) {
                return UIApplication.sharedApplication().canOpenURL(url)
            }
            return false
        }
        
        if requestString != "" {
        
            // check url if url request
            if requestType == alcs.RequestType.URL {
                
                if !verifyUrl(requestString) {
                    print("ruslan: invalid url: \(requestString)")
                    return
                }
                
            }
            
            let sb = UIStoryboard(name: "AlchemyLanguageRequestViewController", bundle: nil)
            
            self.requestVC = sb.instantiateViewControllerWithIdentifier("AlchemyLanguageRequestViewController") as! AlchemyLanguageRequestViewController
            
            self.requestVC.dismisser = self
            self.requestVC.requestType = requestType
            self.requestVC.requestString = requestString
            self.requestVC.view.alpha = 0.0
            self.requestVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            
            self.presentViewController(requestVC, animated: false) {
                
                UIView.animateWithDuration(self.animationDuration) {
                    
                    self.requestVC.view.alpha = 1.0
                    
                }
                
            }
            
        } else {
            
            let alertController = UIAlertController(
                title: "Content Required",
                message:"Please enter an input string.",
                preferredStyle: .Alert
            )
            
            alertController.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alertController, animated: true){ }
            
        }
        
    }
    
}


extension AlchemyLanguageViewController: AlchemyLanguageDismissalProtocol {
    
    func dismissRequestVC() {
        
        self.requestVC.dismissViewControllerAnimated(true) {
            
            // on completion eliminate the reference and let ARC create a new one
            self.requestVC = nil
            
        }
        
    }
    
}
