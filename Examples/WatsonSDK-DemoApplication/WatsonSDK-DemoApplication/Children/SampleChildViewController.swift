//
//  SampleChildViewController.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/1/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit

class SampleChildViewController: ChildViewController {
    
    override var childTitle: String! {
    
        return "SampleChildViewController"
        
    }
    
    override var config: [String : String]! {
    
        return [
        
            "apiKey" : "",
            "bogusKey" : ""
            
        ]
    
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor()
        
    }
    
}
