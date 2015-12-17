//
//  BarView.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/1/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit

class BarView: UIView {
    
    var delegate: BarViewDelegate!
    
    
    @IBAction func selectPress() {
        
        assert(delegate != nil, "BarViewDelegate needs to be set.")
        delegate.presentSelect()
        
    }
    
    @IBAction func settingsPress() {

        assert(delegate != nil, "BarViewDelegate needs to be set.")
        delegate.presentSettings()
        
    }
    
}
