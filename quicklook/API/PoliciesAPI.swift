//
//  PoliciesAPI.swift
//  quicklook
//
//  Created by Toxicspu on 4/14/20.
//  Copyright © 2020 developer. All rights reserved.
//

//https://stackoverflow.com/questions/38952420/swift-wait-until-datataskwithrequest-has-finished-to-call-the-return

import Foundation
import SwiftUI


class PoliciesAPI {
    
    @ObservedObject var viewModel = Defaults()
    @EnvironmentObject var controlCenter: ControlCenter
    
    
    func getPolicies(completion: @escaping ([Responses.Policies.Response]) -> ()){
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/policies"
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
            guard let policies = try? JSONDecoder().decode(Responses.Policies.self, from: data) else {
                print ("Sacko")
                return}
            print("Got Policies?")
            DispatchQueue.main.async {
                completion(policies.policies)
                
            }
        }.resume()
    }
    
    
    func policyDetails (id:String,completion: @escaping (Responses.PolicyCodable) -> ()){
        
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/policies/id/\(id)"
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
            
            guard let policy = try! JSONDecoder().decode(Responses.PolicyCodable?.self, from: data) else {
                print ("Failed")
                print(String(data:data, encoding: .utf8))
                return}
            print("Got Policies.")
            print(policy.policy.general?.jamfId)
            // print(policy.policy.scope)
            DispatchQueue.main.async {
                completion(policy.self)
            }
        }.resume()
        
    }
    
    
    func deletePolicy (id: String, completion:()->()) {
        
        let sem = DispatchSemaphore.init(value: 0)
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/policies/id/"+"\(id)"
        print(url)
        
        // Request options
        
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "DELETE"
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
            defer { sem.signal() }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Bad Credentials")
                    return
            }
            
            print("Just Deleted Policy")
        }.resume()
        sem.wait()
        completion()
    }
    
    
    
    func updatePolicy(policyToggle:Bool, deviceId:String){
        let sem = DispatchSemaphore.init(value: 0)
        var xml:String
        if policyToggle == false {
            xml = "<policy><general><enabled>true</enabled></general></policy>" }
        else { xml = "<policy><general><enabled>false</enabled></general></policy>" }
        
        let xmldata = xml.data(using: .utf8)
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/policies/id/\(deviceId)"
        print(url)
        // Request options
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "PUT"
        request.httpBody = xmldata
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
                    print(response)
                    return
            }
        }.resume()
        sem.wait()
    }
}
