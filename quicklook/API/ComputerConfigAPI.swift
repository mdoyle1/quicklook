//
//  ComputerConfigAPI.swift
//  quicklook
//
//  Created by Toxicspu on 5/6/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI


class ComputerConfigAPI{
    
    @ObservedObject var viewModel = Defaults()
    @EnvironmentObject var controlCenter: ControlCenter
    
    
    func getComputerConfig(completion: @escaping ([Responses.ConfigurationProfiles.ConfigurationProfile]) -> ()){
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/osxconfigurationprofiles"
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
            guard let configurations = try? JSONDecoder().decode(Responses.ConfigurationProfiles.self, from: data) else {
                print ("Sacko")
                return}
            print("Got Policies?")
            DispatchQueue.main.async {
                completion(configurations.computerConfigurations ?? [])
            }
            
            configurations.computerConfigurations?.forEach { config in
                print(config.name ?? "")
            }
        }.resume()
    }
    
    
    func configDetails (id:String,completion: @escaping (Responses.OsXConfigurationProfile) -> ()){
        
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/osxconfigurationprofiles/id/\(id)"
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
            
            guard let configuration = try! JSONDecoder().decode(Responses.OsXConfigurationProfile?.self, from: data) else {
                print ("Failed")
                //  print(String(data:data, encoding: .utf8))
                return}
            // print(String(data:data, encoding: .utf8))
            print("Got Policies.")
            print(configuration.os_x_configuration_profile?.general?.name ?? "")
            
            DispatchQueue.main.async {
                completion(configuration.self)
                let xml = configuration.os_x_configuration_profile?.general?.payloads ?? "Empty"
                let xmLdata:NSDictionary = xml.propertyList() as! NSDictionary
                // print(xmLdata)
                let payloadContent = xmLdata["PayloadContent"] as? NSArray
                let nestedContent = payloadContent?.object(at: 0) as! NSDictionary
                for item in nestedContent {
                    var currentItem:Any? = ""
                    if "\(item.value)" == "0" {currentItem = "false"}
                    else if "\(item.value)" == "1" {currentItem = "true"} else {currentItem = item.value}
                    print("\(item.key): \(currentItem ?? "")")
                    computerConfigPayloads.append(Responses.ConfigPayload(payload: "\(item.key): \(currentItem ?? "")"))
                }
            }
        }.resume()
        
    }
    
}
