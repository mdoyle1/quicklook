//
//  GetComputers.swift
//  quicklook
//
//  Created by developer on 4/8/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI

//https://jsoneditoronline.org


class MatchAPI {
    
    
    @ObservedObject var viewModel = Defaults()
    
    
    func getComputer(defaults: Defaults, search:String, completion: @escaping ([Responses.Computers.Response]) -> ()){
        let url = "\(defaults.defaultURL)"+"/JSSResource/computers/match/"+"\(search)"
        // Request options
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let config = URLSessionConfiguration.default
        
        //API Authentication
        let userPasswordString = "\(defaults.usernameStore):\(defaults.passwordStore)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            guard let data = data else { return }
            
            guard let computers = try? JSONDecoder().decode(Responses.Computers.self, from: data) else {
                print ("Failed")
                return}
            
            print("Got Computers.")
            
            DispatchQueue.main.async {
                completion(computers.computers)
                for computer in computers.computers
                {
                    print(computer.name)
                    print(computer.asset_tag ?? "")
                    print(computer.serial_number)
                    print(computer.mac_address)
                    print(computer.ip_address ?? "")
                    print(computer.last_reported_ip ?? "")
                    print("")
                }
            }
        }.resume()
    }
    
    
    func getDevice(search:String, completion: @escaping ([Responses.MobileDeviceMatch.MobileDevices]) -> ()){
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/mobiledevices/match/"+"\(search)"
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
            
            guard let mobiledevice = try? JSONDecoder().decode(Responses.MobileDeviceMatch.self, from: data) else {
                print ("Failed")
                return}
            
            print("Got Computers.")
            
            DispatchQueue.main.async {
                completion(mobiledevice.mobileDevices ?? [])
                for device in mobiledevice.mobileDevices ?? []
                {
                    print(device.name ?? "")
                    print(device.building ?? "")
                    print(device.serialNumber ?? "")
                    print(device.macAddress ?? "")
                    print(device.wifiMACAddress ?? "")
                    print("")
                }
            }
        }.resume()
    }
    
}
