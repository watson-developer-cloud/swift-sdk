//
//  ViewController.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/1/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // sizing
    private var screenBounds: CGRect { return UIScreen.mainScreen().bounds }
    var screenWidth: CGFloat { return screenBounds.width }
    var screenHeight: CGFloat { return screenBounds.height }
    
    // width
    var popoverWidth: CGFloat { return 1.0 * screenWidth }
    
    // height
    var barHeight: CGFloat { return 40.0 }
    var childScreenHeight : CGFloat { return screenHeight - barHeight }
    
    // ui components
    private var barView: BarView!
    private var childViewContainer: UIView!
    
    var childViewController: UIViewController? {
        
        didSet {
            
            
            
        }
        
    }

    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureBarView()
        
        configureChildView()
        
    }
    
    private func configureBarView() {
        
        self.barView = NSBundle.mainBundle().loadNibNamed("BarView", owner: self, options: nil).first! as! BarView
        
        let barViewFrame = CGRect(
            x: 0.0,
            y: childScreenHeight,
            width: screenWidth,
            height: barHeight
        )
        
        self.barView.frame = barViewFrame
        
        self.view.addSubview(self.barView)
        
    }
    
    // TODO: implement
    private func configureChildView() {}

}

