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

class ControlCenter: ObservableObject {
    
    var username: String = ""
    var password: String = ""
    
    @EnvironmentObject var loginViewModel:ControlCenter
    @ObservedObject var viewModel = Defaults()
    @Published var loginToggle = true
    @Published var mainMenuToggle = false
    @Published var loading = true
    
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
    
    func downloadScript(id: String){
        self.loading = true
        let url = $viewModel.defaultURL.wrappedValue+"/uapi/v1/scripts/"+"\(id)"+"/download"
        print(url)
        print(token ?? "")
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                self.scriptContents = (String(data:data, encoding: .utf8) ?? "No Details")
                self.loading = false
            }
        }.resume()
    }
    
    
    
}



