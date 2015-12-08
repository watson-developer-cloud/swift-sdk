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
    @IBAction func goURLButtonPress() { presentResponseViewControllerWithRequestType(.URL) }
    @IBAction func goTextButtonPress() { presentResponseViewControllerWithRequestType(.Text) }
    
    private func presentResponseViewControllerWithRequestType(requestType: alcs.RequestType) {
        
        let sb = UIStoryboard(name: "AlchemyLanguageRequestViewController", bundle: nil)

        let requestVC = sb.instantiateViewControllerWithIdentifier("AlchemyLanguageRequestViewController") as! AlchemyLanguageRequestViewController
        requestVC.requestType = requestType
        
        self.presentViewController(requestVC, animated: true, completion: nil)
        
    }
    
    
    // iboutlets
    @IBOutlet weak var goURLButton: UIButton!
    @IBOutlet weak var goTextButton: UIButton!
    
    
    // properties
    // title animation
    var titleAnimation: SKView!
    
    
    // setup
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureButtons()
        
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
    
    
    
}
