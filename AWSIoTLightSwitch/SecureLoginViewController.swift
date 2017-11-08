//
//  SecureLoginViewController.swift
//  AWSIoTLightSwitch
//
//  Created by Hanley, David on 08/11/2017.
//  Copyright © 2017 JP Morgan & Chase. All rights reserved.
//

import UIKit
import LocalAuthentication

class SecureLoginViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        displayLogin()
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
    }

    func displayLogin() {
         let myContext = LAContext()
        let myLocalizedReasonString = "Authentication required to access light switch"  // there's a Info.plist property NSFaceIDUsageDescription that may override this? TBC.
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    if success {
                        // User authenticated successfully, take appropriate action
                        print("Authenticated successfully")
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "showSwitches", sender: nil)
                        }
                        
                    } else {
                        // User did not authenticate successfully, look at error and take appropriate action
                        if evaluateError != nil {
                            print("Error during authentication: \(evaluateError!.localizedDescription)")
                            let myAlert = UIAlertController(title: "Alert", message: "Authentication error", preferredStyle: .alert)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                        else {
                            print("Failed authentication. Try again ...")
                            let myAlert = UIAlertController(title: "Alert", message: "Authentication failed", preferredStyle: .alert)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                print("Cannot evaluate LA policy: \(authError!.localizedDescription)")
            }
        } else {
            // Fallback on earlier versions
            print("Upgrade your version of iOS to the latest!")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
