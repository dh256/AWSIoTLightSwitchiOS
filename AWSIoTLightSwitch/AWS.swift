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
    static var connected: Bool = false
    
    static var iotDataManager: AWSIoTDataManager = AWSIoTDataManager.default()
    static var iotData: AWSIoTData = AWSIoTData.default()
    static var iotManager: AWSIoTManager = AWSIoTManager.default()
    static var iot: AWSIoT = AWSIoT.default()
    
    
    
    /// Connect to AWS IoT using certficate method
    /// Note: This example does not support Web Sockets method
    static func connect() {
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AwsRegion, identityPoolId: CognitoIdentityPoolId)
        
        let configuration = AWSServiceConfiguration(region: AwsRegion, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let defaults = UserDefaults.standard
        var certificateId = defaults.string( forKey: "certificateId")
        
        if (certificateId == nil)
        {
            DispatchQueue.main.async {
                print("No identity available, searching bundle...")
            }
            
            //
            // No certificate ID has been stored in the user defaults; check to see if any .p12 files
            // exist in the bundle.
            //
            let myBundle = Bundle.main
            let myCerts = myBundle.paths(forResourcesOfType: "p12" as String, inDirectory:nil)
            let uuid = UUID().uuidString;
            
            if (myCerts.count > 0) {
                //
                // At least one PKCS12 file exists in the bundle.  Attempt to load the first one
                // into the keychain (the others are ignored), and set the certificate ID in the
                // user defaults as the filename.  If the PKCS12 file requires a passphrase,
                // you'll need to provide that here; this code is written to expect that the
                // PKCS12 file will not have a passphrase.
                //
                if let data = try? Data(contentsOf: URL(fileURLWithPath: myCerts[0])) {
                    DispatchQueue.main.async {
                        print("found identity \(myCerts[0]), importing...")
                    }
                    if AWSIoTManager.importIdentity( fromPKCS12Data: data, passPhrase:"awsiot", certificateId:myCerts[0]) {
                        //
                        // Set the certificate ID and ARN values to indicate that we have imported
                        // our identity from the PKCS12 file in the bundle.
                        //
                        defaults.set(myCerts[0], forKey:"certificateId")
                        defaults.set("from-bundle", forKey:"certificateArn")
                        DispatchQueue.main.async {
                            print("Using certificate: \(myCerts[0]))")
                            AWS.iotDataManager.connect( withClientId: uuid, cleanSession:true, certificateId:myCerts[0], statusCallback: mqttEventCallback)
                        }
                    }
                }
            }
            certificateId = defaults.string( forKey: "certificateId")
            if (certificateId == nil) {
                DispatchQueue.main.async {
                    print("No identity found in bundle, creating one...")
                }
                //
                // Now create and store the certificate ID in NSUserDefaults
                //
                let csrDictionary = [ "commonName":CertificateSigningRequestCommonName, "countryName":CertificateSigningRequestCountryName, "organizationName":CertificateSigningRequestOrganizationName, "organizationalUnitName":CertificateSigningRequestOrganizationalUnitName ]
                
                AWS.iotManager.createKeysAndCertificate(fromCsr: csrDictionary, callback: {  (response ) -> Void in
                    if (response != nil)
                    {
                        defaults.set(response?.certificateId, forKey:"certificateId")
                        defaults.set(response?.certificateArn, forKey:"certificateArn")
                        certificateId = response?.certificateId
                        print("response: [\(response)]")
                        
                        let attachPrincipalPolicyRequest = AWSIoTAttachPrincipalPolicyRequest()
                        attachPrincipalPolicyRequest?.policyName = PolicyName
                        attachPrincipalPolicyRequest?.principal = response?.certificateArn
                        //
                        // Attach the policy to the certificate
                        //
                        self.iot.attachPrincipalPolicy(attachPrincipalPolicyRequest!).continueWith (block: { (task) -> AnyObject? in
                            if let error = task.error {
                                print("failed: [\(error)]")
                            }
                            print("result: [\(task.result)]")
                            //
                            // Connect to the AWS IoT platform
                            //
                            if (task.error == nil)
                            {
                                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                                    print("Using certificate: \(certificateId!)")
                                    self.iotDataManager.connect( withClientId: uuid, cleanSession:true, certificateId:certificateId!, statusCallback: mqttEventCallback)
                                    
                                })
                            }
                            return nil
                        })
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            print("Unable to create keys and/or certificate, check values in Constants.swift")
                        }
                    }
                } )
            }
        }
        else
        {
            // get a unique client id
            let uuid = UID.sharedInstance.get()
            
            //
            // Connect to the AWS IoT service
            //
            iotDataManager.connect( withClientId: uuid, cleanSession:true, certificateId:certificateId!, statusCallback: AWS.mqttEventCallback)
        }

        
    }
    
    /// Disconnect from AWS
    static func disconnect() {
        AWS.iotDataManager.disconnect();
    }
    
    /// Determines whether AWS is connected
    static func isConnected() -> Bool {
        return connected
    }
    
    static func publish(string: String) {
        if AWS.isConnected() {
            AWS.iotDataManager.publishString(string, onTopic: topicName, qoS: .messageDeliveryAttemptedAtMostOnce)
        }
        else {
            print("Not connected to AWWS IoT")
        }
    }
    
    /// Callback function for MQTT events
    static private func mqttEventCallback( _ status: AWSIoTMQTTStatus )
    {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            print("connection status = \(status.rawValue)")
            switch(status)
            {
                case .connecting:
                    print("Connecting")
                
                case .connected:
                    print("Connected")
                    AWS.connected = true
                    print("Using certificate: \(defaults.string( forKey: "certificateId")!)")
                    
                case .disconnected:
                    print("Disconnected")
                    AWS.connected = false
                    
                case .connectionRefused:
                    print("Connection Refused")
                    
                case .connectionError:
                    print("Connection Error")
                    
                case .protocolError:
                    print("Protocol Error")
                    
                default:
                    print("unknown state: \(status.rawValue)")

            }
            //NotificationCenter.default.post( name: Notification.Name(rawValue: "connectionStatusChanged"), object: self )
        }
        
    }

    
}
