//
//  ComputerCommandsAPI.swift
//  quicklook
//
//  Created by Toxicspu on 5/12/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI


class CommandAPI{
    
    @ObservedObject var viewModel = Defaults()
    @EnvironmentObject var controlCenter: ControlCenter
    
    
    func JSSCommand(commandType:String, command:String, deviceId:String){
        let sem = DispatchSemaphore.init(value: 0)
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/\(commandType)/command/\(command)/id/\(deviceId)"
        print(url)
        // Request options
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "POST"
        let config = URLSessionConfiguration.default
        
        //API Authentication
        let userPasswordString = "\($viewModel.usernameStore.wrappedValue):\($viewModel.passwordStore.wrappedValue)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            defer { sem.signal() }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Bad Credentials")
                    print(response ?? "")
                    return
            }
            print(httpResponse)
        }.resume()
        sem.wait()
    }
    
    
}
