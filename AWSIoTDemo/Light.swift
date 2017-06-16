//
//  LightState.swift
//  AWSIoTDemo
//
//  Created by Hanley, David on 19/05/2017.
//  Copyright © 2017 JP Morgan & Chase. All rights reserved.
//

import Foundation

enum LightState : String {
    case Off
    case On
}

struct Light {
    let name: String
    var state: LightState
    
    init(name: String, state: LightState = LightState.Off) {
        self.name = name
        self.state = state
    }
    
    mutating func set(state: LightState) {
        self.state = state
    }
    
    mutating func change() {
        if self.state == LightState.On {
            set(state: LightState.Off)
        }
        else {
            set(state: LightState.On)
        }
    }
}

struct Lights {
    static let sharedInstance = Lights()
    var lights = [Light]()
    
    init() {
        lights.append(Light(name: "RED"));
        lights.append(Light(name: "AMBER"));
        lights.append(Light(name: "GREEN"));
    }
    
    func change(light name: String) {
        for var light in lights {
            if light.name == name {
                light.change()
                break;
            }
        }
    }
    
    func set(light name: String, state: LightState) {
        for var light in lights {
            if light.name == name {
                light.set(state: state)
                break;
            }
        }
    }
    
    func allOff() {
        for var light in lights {
            light.set(state: LightState.Off)
        }
    }
    
    func allOn() {
        for var light in lights {
            light.set(state: LightState.On)
        }
    }
    
}
