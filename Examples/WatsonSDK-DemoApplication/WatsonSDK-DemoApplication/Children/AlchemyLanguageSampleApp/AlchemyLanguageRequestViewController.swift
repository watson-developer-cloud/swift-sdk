//
//  AlchemyLanguageRequestViewController.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/8/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit
import WatsonSDK

class AlchemyLanguageRequestViewController: UIViewController {
    
    @IBAction func closeButtonPress() {
        
        self.dismisser.dismissRequestVC()
        
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    var activityIndicatorView: UIActivityIndicatorView!
    var resultsView: AlchemyLanguageResultsView!
    
    var _requestType: AlchemyLanguageConstants.RequestType!
    var requestType: AlchemyLanguageConstants.RequestType! {
        get { assert(_requestType != nil, "Set AlchemyLanguageRequestViewController requestType before displaying."); return _requestType }
        set { _requestType = newValue }
    }
    
    var _requestString: String!
    var requestString: String! {
        get { assert(_requestString != nil, "Set AlchemyLanguageRequestViewController requestString before displaying."); return _requestString }
        set { _requestString = newValue }
    }
    
    var _dismisser: AlchemyLanguageDismissalProtocol!
    var dismisser: AlchemyLanguageDismissalProtocol! {
        get { assert(_dismisser != nil, "Set AlchemyLanguageRequestViewController dismisser before displaying."); return _dismisser }
        set { _dismisser = newValue }
    }
    
    // sizing
    var screenBounds: CGRect { return UIScreen.mainScreen().bounds }
    var screenWidth: CGFloat { return screenBounds.size.width }
    var screenHeight: CGFloat { return screenBounds.size.height }
    
    var activeOriginY: CGFloat { return closeButton.frame.origin.y + closeButton.frame.size.height }
    var activeHeight: CGFloat { return screenHeight - activeOriginY }
    
    // area of screen to use below X button
    var activeFrame: CGRect {
        
        return CGRect(
            x: 0.0,
            y: activeOriginY,
            width: screenWidth,
            height: activeHeight
        )
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // activity indicator
        self.activityIndicatorView = UIActivityIndicatorView(frame: CGRect(
            origin: CGPointZero,
            size: CGSize(
                width: 50.0,
                height: 50.0
            )
        ))
        
        self.activityIndicatorView.center = self.view.center
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.startAnimating()
        
        print(self.activityIndicatorView)
        print(self.activityIndicatorView.frame)
        
        // api key
        var apiKey: String?
        
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                apiKey = dict["AlchemyAPIKey"]
            }
        }
        
        if let apiKey = apiKey {
         
            self.resultsView = NSBundle.mainBundle().loadNibNamed("AlchemyLanguageResultsView", owner: self, options: nil).first as! AlchemyLanguageResultsView
            self.resultsView.frame = self.activeFrame
            
            // start request
            let token = TokenAuthenticationStrategy(token: apiKey)
            let alchemyLanguage = AlchemyLanguage(tokenAuthenticationStrategy: token)
            let asynchronousDispatchGroup = dispatch_group_create()
            var entitiesSuccess = false
            var sentimentSuccess = false
            var keywordsSuccess = false
            
            dispatch_group_enter(asynchronousDispatchGroup)
            alchemyLanguage.getEntities(requestType: self.requestType,
                html: nil,
                url: nil,
                text: self.requestString) {
                    
                    error, entities in
                    
                    // code
                    if let entities = entities.entities {
                        
                        self.resultsView.setNumberEntities(entities.count)
                        
                        switch entities.count {
                            
                        case 0: func void(){}; void()
                            
                        case 1:
                            if let label = entities[0].text { self.resultsView.setEntityLabel(label, atIndex: 0) }
                            
                        case 2:
                            if let label = entities[0].text { self.resultsView.setEntityLabel(label, atIndex: 0) }
                            if let label = entities[1].text { self.resultsView.setEntityLabel(label, atIndex: 1) }
                            
                        default:
                            if let label = entities[0].text { self.resultsView.setEntityLabel(label, atIndex: 0) }
                            if let label = entities[1].text { self.resultsView.setEntityLabel(label, atIndex: 1) }
                            if let label = entities[2].text { self.resultsView.setEntityLabel(label, atIndex: 2) }
                            
                        }
                        
                        entitiesSuccess = true
                        
                    }
                    
                    dispatch_group_leave(asynchronousDispatchGroup)
                    
            }
            
            dispatch_group_enter(asynchronousDispatchGroup)
            alchemyLanguage.getSentiment(requestType: self.requestType,
                html: nil,
                url: self.requestString,
                text: self.requestString) {
                    
                    error, sentimentResponse in
                    
                    if let sentiment = sentimentResponse.docSentiment, let score = sentiment.score {
                        
                        if let positive = sentiment.type {
                            
                            switch positive {
                            case "positive": self.resultsView.setPositiveSentiment(withValue: score)
                            case "negative": self.resultsView.setNegativeSentiment(withValue: score)
                            default: func void(){}; void()
                            }
                            
                        }

                        sentimentSuccess = true
                        
                    } else {
                        
                        self.resultsView.setNoSentimentFound()
                        
                    }
                    
                    dispatch_group_leave(asynchronousDispatchGroup)
                    
            }
            
            dispatch_group_enter(asynchronousDispatchGroup)
            alchemyLanguage.getRankedKeywords(requestType: self.requestType,
                html: nil,
                url: self.requestString,
                text: self.requestString) {
                    
                    error, keywords in
                    
                    if let keywords = keywords.keywords {
                    
                        // done here and in the else as well because AL API sometimes returns a valid, empty array, and sometimes no array at all
                        self.resultsView.setNumberKeywords(keywords.count)
                        
                        switch keywords.count {
                            
                        case 0: func void(){}; void()
                            
                        case 1:
                            if let label = keywords[0].text { self.resultsView.setKeywordLabel(label, atIndex: 0) }
                            
                        case 2:
                            if let label = keywords[0].text { self.resultsView.setKeywordLabel(label, atIndex: 0) }
                            if let label = keywords[1].text { self.resultsView.setKeywordLabel(label, atIndex: 1) }
                            
                        default:
                            if let label = keywords[0].text { self.resultsView.setKeywordLabel(label, atIndex: 0) }
                            if let label = keywords[1].text { self.resultsView.setKeywordLabel(label, atIndex: 1) }
                            if let label = keywords[2].text { self.resultsView.setKeywordLabel(label, atIndex: 2) }
                            
                        }
                        
                        keywordsSuccess = true
                        
                    } else {
                        
                        self.resultsView.setNumberKeywords(0)
                        
                    }
                    
                    dispatch_group_leave(asynchronousDispatchGroup)
                    
            }
            
            dispatch_group_notify(asynchronousDispatchGroup, dispatch_get_main_queue()) {
                
                self.activityIndicatorView.removeFromSuperview()
                self.view.addSubview(self.resultsView)
                
                let completeFailure = ((entitiesSuccess || sentimentSuccess || keywordsSuccess) == false)
                if completeFailure {
                    
                    self.displayError()
                    
                }
                
            }
            
        } else {
            
            displayError()
            
        }
        
    }
    
    private func displayError() {
        
        if self.activityIndicatorView != nil {

            self.activityIndicatorView.hidesWhenStopped = false
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.color = UIColor.redColor()
            
        }
        
        let alertController = UIAlertController(
            title: "Network Error Occurred",
            message:"Please try again.",
            preferredStyle: .Alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alertController, animated: true){ }
        
    }
    
}
