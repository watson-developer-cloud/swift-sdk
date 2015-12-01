//
//  ViewController.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/1/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import UIKit

/**

 This is the base ViewController for the WatsonSDK Demo Application.

 Installing your sample app for your respective service is easy:
 
 1. Copy-paste your project, in one directory, into "Children"
 2. Have your root **UIViewController** inherit from **ChildViewController**
   * Implement "childTitle"
   * Implement "config" as a dictionary of keys you require and empty values
 3. Add an instance of your root view controller to the "children" array below
 4. Done!
 
 **ViewController** will automatically populate the selection and setting screens for you.
 
*/
class ViewController: UIViewController {

    // add your child view controller here
    let children: [ChildViewController] = [
    
        SampleChildViewController()
    
    ]
    
    // sizing
    private var screenBounds: CGRect { return UIScreen.mainScreen().bounds }
    var screenWidth: CGFloat { return screenBounds.width }
    var screenHeight: CGFloat { return screenBounds.height }
    
    // width
    var popoverWidth: CGFloat { return 1.0 * screenWidth }
    
    // height
    var barHeight: CGFloat { return 40.0 }
    var childScreenHeight : CGFloat { return screenHeight - barHeight }
    
    // mutable versions of copied dictionaries
    private var configDictionaries: [String : [String : String] ] = [ "" : [ "" : ""] ]
    
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
        
        configureFirstChildView()
        
    }
    
    private func configureBarView() {
        
        var _barView = self.barView
        
        _barView = NSBundle.mainBundle().loadNibNamed("BarView", owner: self, options: nil).first! as! BarView
        
        let barViewFrame = CGRect(
            x: 0.0,
            y: childScreenHeight,
            width: screenWidth,
            height: barHeight
        )
        
        _barView.delegate = self
        _barView.frame = barViewFrame
        
        self.view.addSubview(_barView)
        
    }
    
    // TODO: implement
    private func configureFirstChildView() {
    
        assert(children.first != nil, "ViewController: Children array cannot be empty!")
        
        let firstChild = children.first!
        
        presentChild(firstChild)
    
    }
    
    func presentChild(child: ChildViewController) {

        // make entry for data if not present, else configure selection screen with present data
        
        // configure currently selected in selection screen
        
        // configure settings popover based on current child
        
        
    }

}


extension ViewController: BarViewDelegate {
    
    func presentSelect() {
        
        print("TODO: Show select screen.")
        
    }
    
    func presentSettings() {
        
        print("TODO: Show settings screen.")
        
    }
    
}

