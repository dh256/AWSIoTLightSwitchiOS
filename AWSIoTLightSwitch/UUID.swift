//
//  UUID.swift
//  AWSIoTLightSwitch
//
//  Created by David Hanley on 07/11/2017.
//  Copyright © 2017 JP Morgan & Chase. All rights reserved.
//

import Foundation

class UID {
    static let sharedInstance = UID()
    
    func get() -> String {
        var uid = UserDefaults.standard.string(forKey: "UID")
        if uid == nil {
            uid = UUID().uuidString
            UserDefaults.standard.set(uid, forKey: "UID")
        }
        return uid!
    }
}
