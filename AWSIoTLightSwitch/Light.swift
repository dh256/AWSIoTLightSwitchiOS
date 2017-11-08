//
//  LightState.swift
//  AWSIoTDemo
//
//  Created by Hanley, David on 19/05/2017.
//  Copyright © 2017 JP Morgan & Chase. All rights reserved.
//

import Foundation
import SwiftyJSON

enum LightState : Int {
    case Off=0
    case On=1
}

class Light {
    let name: String
    var state: LightState
    
    init(name: String, state: LightState = LightState.Off) {
        self.name = name
        self.state = state
    }
    
    func set(state: LightState, updateAWS: Bool = false) {
        self.state = state
        if updateAWS {
            let jsonString = "{\"name\": \"\(name)\",\"state\": \(self.state.rawValue),\"fromdevice\": \"\(UID.sharedInstance.get())\"}"
            AWS.publish(string: jsonString)
        }
    }
    
    func change(updateAWS: Bool = false) {
        if self.state == LightState.On {
            set(state: LightState.Off, updateAWS: updateAWS)
        }
        else {
            set(state: LightState.On, updateAWS: updateAWS)
        }
    }
}

class Lights {
    static var sharedInstance = Lights()
    var lights = [Light]()
    
    init() {
        lights.append(Light(name: "RED"));
        lights.append(Light(name: "AMBER"));
        lights.append(Light(name: "GREEN"));
    }
    
    func change(light name: String) {
        for light in lights {
            if light.name == name {
                light.change(updateAWS: true)
                break;
            }
        }
    }
    
    func set(light name: String, state: LightState) {
        for light in lights {
            if light.name == name {
                light.set(state: state)
                break;
            }
        }
    }
    
    func allOff() {
        for light in lights {
            light.set(state: LightState.Off, updateAWS: false)
        }
    }
    
    func allOn() {
        for light in lights {
            light.set(state: LightState.On, updateAWS: false)
        }
    }
}
