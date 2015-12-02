//
//  ChildViewController.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/1/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit

class ChildViewController: UIViewController { }

extension ChildViewController: ChildProtocol {
    
    var childTitle: String! {
     
        fatalError("ChildViewController \(self.dynamicType) must override the title property.")
        
    }
    
    var config: [String : String]! {
    
        fatalError("ChildViewController \(self.dynamicType) must override the title property.")
    
    }
    
}
