//
//  ResultStatusModel.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/30/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

/**
*  This model displays the status return value and the status info.  It will give a quick indication of the status SUCCESS or ERROR based
on what the ALchemy service gives out.
*/
public struct ResultModel {
    
    let status: String
    let statusInfo: String
    let data: String
    
    init(status: String, statusInfo: String, data: String) {
        
        self.status = status
        self.statusInfo = statusInfo
        self.data = data
    }
    
}
