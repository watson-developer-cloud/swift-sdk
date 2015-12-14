//
//  AlchemyLanguageResultsView.swift
//  WatsonSDK-DemoApplication
//
//  Created by Ruslan Ardashev on 12/14/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import Foundation
import UIKit

class AlchemyLanguageResultsView: UIView {
    
    @IBOutlet weak var entitiesLabel: UILabel!
    @IBOutlet weak var entitiesEntry0: UILabel!
    @IBOutlet weak var entitiesEntry1: UILabel!
    @IBOutlet weak var entitiesEntry2: UILabel!
    
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var sentimentEntry0: UILabel!
    @IBOutlet weak var sentimentEntry1: UILabel!
    
    @IBOutlet weak var keywordsLabel: UILabel!
    @IBOutlet weak var keywordsEntry0: UILabel!
    @IBOutlet weak var keywordsEntry1: UILabel!
    @IBOutlet weak var keywordsEntry2: UILabel!
    
    
    func void(){}
    
    private func hideLabels(labels: UILabel...) {
        
        let _ = labels.map( { $0.hidden = true } )
        
    }
    
    func setNumberEntities(int: Int) {
        
        switch int {
            
        case 0:
            hideLabels(entitiesEntry0, entitiesEntry1, entitiesEntry2)
            entitiesLabel.text = "No Entities Found"
            
        case 1:
            hideLabels(entitiesEntry1, entitiesEntry2)
            
        case 2:
            hideLabels(entitiesEntry2)
            
        default:
            void()
            
        }
        
    }
    
    func setEntityLabel(string: String, atIndex: Int) {
        
        switch atIndex {
        case 0: entitiesEntry0.text = string
        case 1: entitiesEntry1.text = string
        default: entitiesEntry2.text = string
        }
        
    }
    
    func setPositiveSentiment(withValue value: Double) {
        
        sentimentEntry0.text = "POSITIVE"
        sentimentEntry0.textColor = UIColor.greenColor()
        setSentimentValue(value)
        
    }
    
    func setNegativeSentiment(withValue value: Double) {
        
        sentimentEntry0.text = "NEGATIVE"
        sentimentEntry0.textColor = UIColor.redColor()
        setSentimentValue(value)
        
    }
    
    private func setSentimentValue(value: Double) {
        
        sentimentEntry1.text = "\(value)"
        
    }
    
    func setNumberKeywords(int: Int) {
        
        switch int {
            
        case 0:
            hideLabels(keywordsEntry0, keywordsEntry1, keywordsEntry2)
            keywordsLabel.text = "No Keywords Found"
            
        case 1:
            hideLabels(keywordsEntry1, keywordsEntry2)
            
        case 2:
            hideLabels(keywordsEntry2)
            
        default:
            void()
            
        }
        
    }
    
    func setKeywordLabel(string: String, atIndex: Int) {
        
        switch atIndex {
        case 0: keywordsEntry0.text = string
        case 1: keywordsEntry1.text = string
        default: keywordsEntry2.text = string
        }
        
    }
    
}
