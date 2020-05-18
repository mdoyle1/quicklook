//
//  TokenAPI.swift
//  quicklook
//
//  Created by developer on 5/15/20.
//  Copyright © 2020 Toxicspu. All rights reserved.
//

import Foundation
import SwiftUI

class TokenAPI {
    
    func getToken(connect:ControlCenter, defaults:Defaults,  completion: @escaping () -> ()){
        print(defaults.$defaultURL)
        connect.getTokenTimer = true
        connect.loginAttempts = false
        print("Attempting Get Token...")
        
        let credentialData = "\(defaults.usernameStore):\(defaults.passwordStore)".data(using: String.Encoding.utf8)!
        let base64EncodedCredentials = credentialData.base64EncodedString()
        guard let url = URL(string: "\(defaults.defaultURL)/uapi/auth/tokens") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let config = URLSessionConfiguration.default
        let authString = "Basic \(base64EncodedCredentials)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            guard let data = data else { return }
            guard let dataAsString = String(data: data, encoding: .utf8)else {return}
            print(dataAsString)
            
            guard let response = try? JSONDecoder().decode(Responses.Token.self, from: data) else {
                print("Not Available")
                DispatchQueue.main.async {
                    connect.badPassword = true
                    connect.isPressed = false
                    connect.loading = false
                    connect.getTokenTimer = false
                }
                return
            }
            
            let queue = DispatchQueue(label:response.token)
            queue.asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    token = response.token.description
                    
                    print("Successful Token:")
                    print(token ?? "")
                    saveCredentialAlert = true
                    connect.loginToggle = false
                    connect.mainMenuToggle = true
                    connect.loading = false
                    connect.getTokenTimer = false
                    connect.logout = false
                    completion()
                }
            }
        }.resume()
        
    }
}
