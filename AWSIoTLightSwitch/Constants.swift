//
//  Constants.swift
//  AWSIoTDemo
//
//  Created by Hanley, David on 19/06/2017.
//  Copyright © 2017 JP Morgan & Chase. All rights reserved.
//

import AWSCore

//WARNING: To run this sample correctly, you must set the following constants.
let AwsRegion = AWSRegionType.USEast1 // e.g. AWSRegionType.USEast1
let CognitoIdentityPoolId = "us-east-1:b7ca9711-36ac-4282-bfdb-f61438e61a11"  // "us-east-1:b7ca9711-36ac-4282-bfdb-f61438e61b79"
let CertificateSigningRequestCommonName = "IoTSampleSwift Application"
let CertificateSigningRequestCountryName = "Your Country"
let CertificateSigningRequestOrganizationName = "Your Organization"
let CertificateSigningRequestOrganizationalUnitName = "Your Organizational Unit"
let PolicyName = "IoTSamplePolicy"

let topicName = "lightCommands"
