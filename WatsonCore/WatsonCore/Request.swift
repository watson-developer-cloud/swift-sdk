//
//  Request.swift
//  WatsonCore
//
//  Created by Karl Weinmeister on 10/27/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import Alamofire

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
}