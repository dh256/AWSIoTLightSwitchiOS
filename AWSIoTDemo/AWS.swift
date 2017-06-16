//
//  AWS.swift
//  AWSIoTDemo
//
//  Created by Hanley, David on 16/06/2017.
//  Copyright © 2017 JP Morgan & Chase. All rights reserved.
//

import Foundation
import AWSCore
import AWSIoT

/// Encapsulate AWS operations
class AWS {
    
    static let sharedInstance = AWS()
    
    var iotDataManager: AWSIoTDataManager!;
    var iotData: AWSIoTData!
    var iotManager: AWSIoTManager!;
    var iot: AWSIoT!
    
    /// Connect to AWS IoT using certficate method
    /// Note: This example does not support Web Sockets method
    static func connect() {
        
    }
    
    static func disconnect() {
        
    }
}
