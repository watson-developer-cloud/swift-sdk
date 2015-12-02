//
//  ChildProtocol.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/1/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit

/** Intended for child **UIViewController**s to implement. */
protocol ChildProtocol: class {
    
    var childTitle: String! { get }
    var config: [String : String]! { get }
    
    // sizing
    // viewFrame is implemented for you
    var viewFrame: CGRect { get }
    
    /** 
    
    within the vc's frame to avoid overlaying the bar at bottom 
    
    **can instead** see the .viewFrame above to implement custom view / viewcontroller hierarchies
    
    */
    func displayFullscreenChildViewController(child: UIViewController)
    
}
