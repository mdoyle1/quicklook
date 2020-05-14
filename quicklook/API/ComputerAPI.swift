//
//  ComputerAPI.swift
//  quicklook
//
//  Created by Toxicspu on 4/24/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI

class ComputerAPI {
    @EnvironmentObject var controlCenter: ControlCenter
    @ObservedObject var viewModel = Defaults()
    
    func getComputer(id:String,completion: @escaping (Responses.Computer) -> ()){
        
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/computers/id/"+"\(id)"
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
            guard let computer = try? JSONDecoder().decode(Responses.Computer.self, from: data) else {
                print ("Failed")
                return}
            
            print("Got Computer.")
            print(computer)
            
            print(computer.computer?.general.ip_address ?? "")
            
            print(computer.computer?.general.last_reported_ip ?? "")
            
            print(computer.computer?.general.mac_address ?? "")
            
            print(computer.computer?.general.alt_mac_address ?? "")
            
            print("")
            DispatchQueue.main.async {
                completion(computer.self)
            }
            
            
        }.resume()
    }
}
