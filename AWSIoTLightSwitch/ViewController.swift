//
//  ViewController.swift
//  AWSIoTDemo
//
//  Created by Hanley, David on 19/05/2017.
//  Copyright © 2017 JP Morgan & Chase. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var redSwitch: UISwitch!
    @IBOutlet weak var amberSwitch: UISwitch!
    @IBOutlet weak var greenSwitch: UISwitch!
    @IBOutlet weak var connectButton: UIBarButtonItem!
    
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    
    // MARK: Actions
    
    /// Send on/off message to AWS IoT
    @IBAction func redLightSwitchPressed(_ sender: Any) {
        Lights.sharedInstance.change(light: "RED")
    }
    
    /// Send on/off message to AWS IoT
    @IBAction func amberLightSwitchPressed(_ sender: UISwitch) {
        Lights.sharedInstance.change(light: "AMBER")
    }
    
    /// Send on/off message to AWS IoT
    @IBAction func greeLightSwitchPressed(_ sender: UISwitch) {
        Lights.sharedInstance.change(light: "GREEN")
    }
    
    /// Connect to AWS IoT
    @IBAction func connectButton(_ sender: Any) {
        if !AWS.isConnected() {
            AWS.connect()
            connectButton.title = "Disconnect"
        }
        else {
            AWS.disconnect()
            connectButton.title = "Connect"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setInitialLightState()
        
        // set button colour
        redSwitch.tintColor = UIColor.red
        redSwitch.onTintColor = UIColor.red
        amberSwitch.tintColor = UIColor.yellow
        amberSwitch.onTintColor = UIColor.yellow
        greenSwitch.tintColor = UIColor.green
        greenSwitch.onTintColor = UIColor.green
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Gets the initial state of the lights (from AWS shadow)
    /// Future feature - for now set all lights to Off
    func setInitialLightState() {
        // this should read from AWS
        Lights.sharedInstance.allOff()
    }


}

