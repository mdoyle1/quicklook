//
//  MobileDeviceAPI.swift
//  quicklook
//
//  Created by Toxicspu on 5/4/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI

class MobileDeviceAPI {
    
    @EnvironmentObject var controlCenter: ControlCenter
    @ObservedObject var viewModel = Defaults()
    
    func getDevice(id:String,completion: @escaping (Responses.MobileDevice) -> ()){
        
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/mobiledevices/id/"+"\(id.description)"
        print(url)
        // Request options
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let config = URLSessionConfiguration.default
        
        //API Authentication
        let userPasswordString = "\($viewModel.usernameStore.wrappedValue):\($viewModel.passwordStore.wrappedValue)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8))
            guard let mobileDevice = try! JSONDecoder().decode(Responses.MobileDevice?.self, from: data) else {
                print ("Failed")
                return}
            
            print("Got Computer.")
            print(mobileDevice)
            
            print(mobileDevice.mobileDevice?.general?.ipAddress ?? "")
            
            print(mobileDevice.mobileDevice?.general?.serialNumber ?? "")
            
            print(mobileDevice.mobileDevice?.general?.capacity ?? "")
            
            print(mobileDevice.mobileDevice?.general?.osVersion ?? "")
            
            print("")
            DispatchQueue.main.async {
                completion(mobileDevice.self)
            }
            
            
        }.resume()
    }
    
}
