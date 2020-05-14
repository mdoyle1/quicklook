//
//  MobileConfigAPI.swift
//  quicklook
//
//  Created by Toxicspu on 5/6/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI


class MobileConfigAPI{

@ObservedObject var viewModel = Defaults()
@EnvironmentObject var controlCenter: ControlCenter
   
   
    func getMobileConfig(completion: @escaping ([Responses.ConfigurationProfiles.ConfigurationProfile]) -> ()){
       let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/mobiledeviceconfigurationprofiles"
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
            completion(configurations.configurationProfiles ?? [])
           }
        
        configurations.configurationProfiles?.forEach { config in
            print(config.name ?? "")
        }
       }.resume()
   }
    
    
    
    func mobileConfigDetails (id:String,completion: @escaping (Responses.MobileConfigurationProfile) -> ()){
        mobileConfigPayloads = []
           let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/mobiledeviceconfigurationprofiles/id/\(id)"
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
            
            guard let configuration = try! JSONDecoder().decode(Responses.MobileConfigurationProfile?.self, from: data) else {
                print ("Failed")
               // print(String(data:data, encoding: .utf8))
                return}
           // print(String(data:data, encoding: .utf8))
            print("Got Policies.")
            print(configuration.configuration_profile?.general?.name ?? "")//
            
        
          

            
            DispatchQueue.main.async {
                completion(configuration.self)
                
                //Config Payload
                let xml = configuration.configuration_profile?.general?.payloads ?? "Empty"
                let xmLdata:NSDictionary = xml.propertyList() as! NSDictionary
               // print(xmLdata)
                let payloadContent = xmLdata["PayloadContent"] as? NSArray
                let nestedContent = payloadContent?.object(at: 0) as! NSDictionary
                for item in nestedContent {
                    var currentItem:Any? = ""
                    if "\(item.value)" == "0" {currentItem = "false"}
                    else if "\(item.value)" == "1" {currentItem = "true"} else {currentItem = item.value}
                    print("\(item.key): \(currentItem ?? "")")
                    mobileConfigPayloads.append(Responses.ConfigPayload(payload: "\(item.key): \(currentItem ?? "")")) 
                }
                
                //                          print("""
//                              Payload Type: \(xmLdata.object(forKey:"PayloadType") ?? "")\n
//                              Payload Organization: \(xmLdata.object(forKey:"PayloadOrganization") ?? "")\n
//                              Payload Display Name: \(xmLdata.object(forKey:"PayloadDisplayName") ?? "")\n
//                              PayLoad Description: \(xmLdata.object(forKey:"PayloadDescription") ?? "")\n
//                              PayLoad Enabled: \(xmLdata.object(forKey:"PayloadEnabled") ?? "")\n
//                              Payload Content: \(xmLdata.object(forKey:"PayloadContent") ?? "")\n
//                              """
//                          )
            }
        }.resume()
           
       }
    
    
    
    
}
