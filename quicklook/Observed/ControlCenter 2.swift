//
//  ControlCenter.swift
//  quicklook
//
//  Created by Toxcispu on 3/25/20.
//  Copyright © 2020 developer. All rights reserved.
//

//https://www.youtube.com/watch?v=1en4JyW3XSI


import SwiftUI
import Combine

var token:String?
var mobileConfigPayloads:[Responses.ConfigPayload] = []
var computerConfigPayloads:[Responses.ConfigPayload] = []
var saveCredentialAlert = false


let savedCredentials = "saved"
let showCredentialAlert = "credAlert"
var saved = UserDefaults.standard


class ControlCenter: ObservableObject {
    //var password: String = ""
    
   
   
    
     
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var jamfurl = ""
    @Published var loginToggle = true
    @Published var mainMenuToggle = false
    @Published var clearCreds = true
    @Published var logout = false

    //LOGIN ERROR CHECKING
    @Published var badPassword:Bool = false
    @Published var loading: Bool = false
    @Published var isPressed: Bool = false
    @Published var enterCredentials: Bool = false
    @Published var getTokenTimer:Bool = false
    @Published var loginAttempts:Bool = false
    
    //Scripts
    @Published var scriptsJson:Responses.Scripts?
    @Published var scriptView = true
    @Published var scriptId:String?
    @Published var scriptContents = ""
    @Published var scriptName = ""
    
    //Packages
    @Published var packagesJson:Responses.Packages?
    @Published var packageId = ""
    @Published var packageName = ""
    @Published var dismiss = true
    @Published var packages: [Responses.Packages.Response] = []
    @Published var package: Responses.Packages.Response?
    
    //POLICIES
    @Published var policyId = ""
    @Published var policyName = ""
    @Published var policy: Responses.PolicyCodable?
    @Published var showAlert = false
    @Published var publishedIndex:Int?
    @Published var policyEnabled:Bool?
    
    
    //COMPUTER
    @Published var computerId = ""
    @Published var computerName = ""
    @Published var computer: Responses.Computer?
    @Published var osxConfigId = ""
    @Published var osxConfigName = ""
    
    //DEVICE
    @Published var deviceId = ""
    @Published var deviceName = ""
    @Published var mobileDevice: Responses.MobileDevice?
    @Published var shareDevice:[String]?
    @Published var iosConfigId = ""
    @Published var iosConfigName = ""
    
    //SCOPE
    @Published var allComputers: Responses.PolicyCodable?
    
    
    //MOBILE CONFIGURATION PROFILE
    
   
    
    
    
}



