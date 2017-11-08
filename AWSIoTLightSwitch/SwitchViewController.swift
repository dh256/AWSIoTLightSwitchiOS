//
//  ViewController.swift
//  AWSIoTDemo
//
//  Created by Hanley, David on 19/05/2017.
//  Copyright © 2017 JP Morgan & Chase. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController {
    
    var connected = false
    
    // MARK: Outlets
    @IBOutlet weak var redSwitch: UISwitch!
    @IBOutlet weak var amberSwitch: UISwitch!
    @IBOutlet weak var greenSwitch: UISwitch!
    @IBOutlet weak var connectButton: UIBarButtonItem!
    
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    
    // MARK: Actions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if connected {
            AWS.disconnect()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
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
            enableSwitches(enable: true)
        }
        else {
            AWS.disconnect()
            connectButton.title = "Connect"
            enableSwitches(enable: false)
        }
    }
    
    func enableSwitches(enable: Bool) {
        redSwitch.isEnabled = enable
        greenSwitch.isEnabled = enable
        amberSwitch.isEnabled = enable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setInitialLightState()
        enableSwitches(enable: connected)
        
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

