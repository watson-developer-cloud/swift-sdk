//
//  AlchemyVisionViewController.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/8/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit

extension AlchemyVisionViewController: ChildProtocol {
    
    var childTitle: String! {
        
        return "AlchemyVisionViewController"
        
    }
    
    var config: [String : String]! {
        
        return [
            
            "apiKey" : ""
            
        ]
        
    }
    
}


class AlchemyVisionViewController: UINavigationController { }
