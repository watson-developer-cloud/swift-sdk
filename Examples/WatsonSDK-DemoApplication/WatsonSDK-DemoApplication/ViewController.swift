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
    
    private var childrenTitles: [String] {

        if _childrenTitles == nil { _childrenTitles = children.map( {$0.childTitle!} ) }
        return _childrenTitles
        
    }
    
    private var _childrenTitles: [String]!
   
    // mutable versions of copied dictionaries
    private var configDictionaries: [String : [String : String] ] = [ "" : [ "" : ""] ]
    
    // ui components
    private var barView: BarView!
    private var currentChildView: UIView?
    private var currentChildViewController: UIViewController?
    // select screen
    private var selectView: UIView!
    private var selectTableView: UITableView!
    // settings screen
    private var settingsView: UIView!
    private var settingsScreenTableView: UITableView!

    // animations
    private var popupDuration: NSTimeInterval = 1.0
    
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureView()
        configureBarView()
        configureSelectView()
        configureSettingsView()
        configureFirstChildView()
        
    }
    
    private func configureView() {
        
        self.view.backgroundColor = UIColor.blackColor()
        
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
    
    private func configureSelectView() {
        
        let selectScreenPopupFrame = CGRect(
            x: 0.0,
            y: screenHeight,
            width: screenWidth,
            height: childViewHeight
        )
        
        self.selectView = UIView(frame: selectScreenPopupFrame)
        self.selectView.layer.zPosition = 3.0
        self.selectView.backgroundColor = UIColor.purpleColor()
        
        let selectTableViewFrame = CGRect(
            origin: CGPointZero,
            size: selectScreenPopupFrame.size
        )
        
        self.selectTableView = UITableView(frame: selectTableViewFrame, style: .Plain)
        self.selectTableView.delegate = self
        self.selectTableView.dataSource = self
        self.selectTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.selectTableView.layer.zPosition = 4.0
        self.selectTableView.backgroundView = nil
        self.selectTableView.backgroundColor = UIColor.clearColor()
        
        self.selectView.addSubview(self.selectTableView)
        self.view.addSubview(self.selectView)
        
    }
    
    private func configureSettingsView() {
        
        let settingsScreenPopupFrame = CGRect(
            x: 0.0,
            y: screenHeight,
            width: screenWidth,
            height: childViewHeight / 2.0
        )
        
        self.settingsView = UIView(frame: settingsScreenPopupFrame)
        self.settingsView.layer.zPosition = 3.0
        self.settingsView.backgroundColor = UIColor.yellowColor()
        
        self.view.addSubview(self.settingsView)
        
    }
    
    private func configureFirstChildView() {
    
        assert(children.first != nil, "ViewController: Children array cannot be empty!")
        presentChild(children.first!)
    
    }
    
    /** 
     
     use this method when selecting various services from the selection popover 
     
     [1] removes current child if present
     [2] configures new child view with size, vc, z position
     [3] remove old settings table view if present
     [4] reconfigures settings view to appropriately reflect
     [5] highlight the appropriate selection screen item to avoid double selection
     
     */
    func presentChild(child: ChildViewController) {
   
        removeCurrentChild()
        configureNewChildView(child)
        removeOldSettingsTableViewIfPresent()
        configureSettingsViewWithNewChild(child)
        highlightAppropriateSelectionScreenItem(child)
        
    }
    
    private func removeCurrentChild() {
        
        self.currentChildView?.removeFromSuperview()
        self.currentChildView = nil
        
        self.currentChildViewController?.removeFromParentViewController()
        self.currentChildViewController = nil
        
    }
    
    private func configureNewChildView(child: ChildViewController) {
        
        self.currentChildViewController = child
        self.currentChildView = child.view
        
        self.currentChildView!.layer.zPosition = 2.0
        
        child.view.frame = childViewFrame
        self.addChildViewController(child)
        self.view.addSubview(child.view)
        
    }
    
    private func removeOldSettingsTableViewIfPresent() {
        
        if self.settingsScreenTableView != nil {
            
            self.settingsScreenTableView.removeFromSuperview()
            self.settingsScreenTableView = nil
            
        }
        
    }
    
    private func configureSettingsViewWithNewChild(child: ChildViewController) {
        
        // get key value pairs from child view controller
        // populate current dictionary, first level dictionary based on childViewController title
        // TODO: think of the case when two child view controller titles match / conflict
        
    }
    
    private func highlightAppropriateSelectionScreenItem(child: ChildViewController) {
        
        // TODO: implement
        
    }
    
}


// MARK: BarViewDelegate
extension ViewController: BarViewDelegate {
    
    func presentSelect() {
        
        presentPopoverScreen(self.selectView!)
        self.view.bringSubviewToFront(self.selectView)
        self.selectTableView.flashScrollIndicators()
        
    }
    
    func presentSettings() {
        
        presentPopoverScreen(self.settingsView)
        self.view.bringSubviewToFront(self.settingsView)
        
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


// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // respond differently based on the tableview
        switch tableView {
            
        /** 
         
         if already selected item, do not present again, otherwise 
            
         [1] get title
         [2]
            
        */
        case self.selectTableView:
            self.selectTableView.deselectRowAtIndexPath(indexPath, animated: true)
            presentChild(children[indexPath.row])
            presentPopoverScreen(self.selectView!)
            return
            
        case self.settingsScreenTableView: func nothing(){}; nothing()  // don't do anything here
            
        default: return
            
        }
        
    }

}


// MARK: BarViewDelegate
extension ViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // respond differently based on the tableview
        switch tableView {
            
        case self.selectTableView:
            
            return children.count
            
        case self.settingsScreenTableView:
            
            if let title = self.currentChildViewController?.title,
                let configEntriesForCurrentChildVC = self.configDictionaries[title] {
                    
                    return configEntriesForCurrentChildVC.count
                    
            } else {
                
                return 0
                
            }
            
        default: return 0
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // respond differently based on the tableview
        switch tableView {
            
        case self.selectTableView:
            
            let cell = self.selectTableView.dequeueReusableCellWithIdentifier("cell")!
            cell.backgroundColor = UIColor.clearColor()
            cell.textLabel?.text = childrenTitles[indexPath.row]
            return cell
            
        case self.settingsScreenTableView:
            
            return UITableViewCell()
            
        default: return UITableViewCell()
            
        }
        
    }

}
