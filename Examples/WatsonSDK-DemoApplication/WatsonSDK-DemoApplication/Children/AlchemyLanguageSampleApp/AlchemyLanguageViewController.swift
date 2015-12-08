//
//  AlchemyLanguageViewController.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/7/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit


extension AlchemyLanguageViewController: ChildProtocol {
    
    var childTitle: String! {
        
        return "AlchemyLanguageViewController"
        
    }
    
    var config: [String : String]! {
        
        return ["apiKey" : ""]
        
    }
    
}

class AlchemyLanguageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad(); self.view.backgroundColor = UIColor.cyanColor()
    }
    
}
