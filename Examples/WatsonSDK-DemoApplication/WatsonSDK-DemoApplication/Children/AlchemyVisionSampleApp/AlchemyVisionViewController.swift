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
    
}


class AlchemyVisionViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor(rgba: "#01303f")
        self.navigationBar.tintColor = UIColor(rgba: "#02a9f7")
    }
    
}
