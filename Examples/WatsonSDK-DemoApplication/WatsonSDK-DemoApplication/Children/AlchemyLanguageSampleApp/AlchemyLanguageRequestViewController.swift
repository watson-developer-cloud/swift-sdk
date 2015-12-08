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
    
    @IBAction func closeButton() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    var _requestType: AlchemyLanguageConstants.RequestType!
    var requestType: AlchemyLanguageConstants.RequestType! {
        get { assert(_requestType != nil, "Set AlchemyLanguageRequestViewController requestType before displaying."); return _requestType }
        set { _requestType = newValue }
    }
    
    
}
