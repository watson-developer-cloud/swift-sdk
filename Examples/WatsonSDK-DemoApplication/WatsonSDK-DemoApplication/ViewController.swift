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
    var childViewHeight : CGFloat { return screenHeight - barHeight }
    
    // child size
    var childViewFrame: CGRect {
        
        return CGRect(
            x: 0.0,
            y: 0.0,
            width: screenWidth,
            height: childViewHeight
        )

    }
   
    // mutable versions of copied dictionaries
    private var configDictionaries: [String : [String : String] ] = [ "" : [ "" : ""] ]
    
    // ui components
    private var barView: BarView!
    private var currentChildView: UIView?
    private var currentChildViewController: UIViewController?
    // select screen
    private var selectScreenPopup: UIView?
    // settings screen
    private var settingsScreenPopup: UIView?

    // animations
    private var popupDuration: NSTimeInterval = 1.0
    
    
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
            y: childViewHeight,
            width: screenWidth,
            height: barHeight
        )
        
        _barView.delegate = self
        _barView.frame = barViewFrame
        _barView.layer.zPosition = 4.0
        
        self.view.addSubview(_barView)
        
    }
    
    private func configureFirstChildView() {
    
        assert(children.first != nil, "ViewController: Children array cannot be empty!")
        
        let firstChild = children.first!
        
        presentChild(firstChild)
    
    }
    
    func presentChild(child: ChildViewController) {

        
        removeCurrentChild()            // remove old child if present
        
        self.currentChildView = child.view
        self.currentChildView!.layer.zPosition = 2.0
        
        self.currentChildViewController = child
        
        
        
        child.view.frame = childViewFrame
        self.addChildViewController(child)
        self.view.addSubview(child.view)
        
                                        // make entry for data if not present, else configure selection screen with present data
        
        
                                        // configure currently selected in selection screen
        
                                        // configure settings popover based on current child
        
        
    }
    
    private func removeCurrentChild() {
        
        self.currentChildView?.removeFromSuperview()
        self.currentChildViewController?.removeFromParentViewController()
        
    }
    
}


extension ViewController: BarViewDelegate {
    
    func presentSelect() {
        
        // instantiate if nil
        if self.selectScreenPopup == nil {
            
            let selectScreenPopupFrame = CGRect(
                x: 0.0,
                y: screenHeight,
                width: screenWidth,
                height: childViewHeight
            )
            
            self.selectScreenPopup = UIView(frame: selectScreenPopupFrame)
            self.selectScreenPopup!.layer.zPosition = 3.0
            self.selectScreenPopup!.backgroundColor = UIColor.purpleColor()
            
            self.view.addSubview(self.selectScreenPopup!)
            
        }
        
        presentPopoverScreen(self.selectScreenPopup!)
        
    }
    
    func presentSettings() {
        
        // instantiate if nil
        if self.settingsScreenPopup == nil {
            
            let settingsScreenPopupFrame = CGRect(
                x: 0.0,
                y: screenHeight,
                width: screenWidth,
                height: childViewHeight / 2.0
            )
            
            self.settingsScreenPopup = UIView(frame: settingsScreenPopupFrame)
            self.settingsScreenPopup!.layer.zPosition = 3.0
            self.settingsScreenPopup!.backgroundColor = UIColor.yellowColor()
            
            self.view.addSubview(self.settingsScreenPopup!)
            
        }
        
        presentPopoverScreen(self.settingsScreenPopup!)
        
    }
    
    /**
     
     tag 0 --> hidden
     tag 1 --> present
     
     */
    private func presentPopoverScreen(viewToPresent: UIView) {
        
        let dy = viewToPresent.frame.height + self.barHeight
        
        if viewToPresent.tag == 0 {
            
            UIView.animateWithDuration(popupDuration) {
                
                viewToPresent.frame.offsetInPlace(dx: 0.0, dy: -dy)
                
            }
            
           viewToPresent.tag = 1
            
        } else {
            
            UIView.animateWithDuration(popupDuration) {
                
                viewToPresent.frame.offsetInPlace(dx: 0.0, dy: dy)
                
            }
            
            viewToPresent.tag = 0
            
        }
        
    }
    
}

