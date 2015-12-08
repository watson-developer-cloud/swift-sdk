//
//  SampleChildViewController.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/1/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit


extension SampleChildViewController : ChildProtocol {
    
    var childTitle: String! {
        
        return "SampleChildViewController"
        
    }
    
}


class SampleChildViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor()
        
    }
    
}
