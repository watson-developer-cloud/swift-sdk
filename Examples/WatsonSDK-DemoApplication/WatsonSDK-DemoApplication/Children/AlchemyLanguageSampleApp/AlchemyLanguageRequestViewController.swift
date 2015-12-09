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
    
    @IBOutlet weak var entitiesLabel: UILabel!
    @IBOutlet weak var entitiesEntry0: UILabel!
    @IBOutlet weak var entitiesEntry1: UILabel!
    @IBOutlet weak var entitiesEntry2: UILabel!
    
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var sentimentEntry0: UILabel!
    @IBOutlet weak var sentimentEntry1: UILabel!
    
    @IBOutlet weak var keywordsLabel: UILabel!
    @IBOutlet weak var keywordsEntry0: UILabel!
    @IBOutlet weak var keywordsEntry1: UILabel!
    @IBOutlet weak var keywordsEntry2: UILabel!
    
    
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
        
        
        
    }
    
}
