//
//  ScriptsAPI.swift
//  quicklook
//
//  Created by Toxicspu on 4/13/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI

class ScriptsAPI {
    
    
    func getScripts(defaults: Defaults, completion: @escaping ([Responses.Scripts.Results]) -> ()){
        print("Get Scripts")
        let url = "\(defaults.defaultURL)"+"/uapi/v1/scripts?page=0&page-size=500&sort=name%3Aasc"
        // Request options
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            
            guard let data = data else {
                print("Jenkum")
                return}
          
            print(String(decoding: data, as: UTF8.self))
            do{ let scripts = try JSONDecoder().decode(Responses.Scripts.self, from: data)
               // print(scripts)
                 completion(scripts.results)
                return
            }
            catch {
                print("Nados")
                print(error)
                return}

        }.resume()
    }
    
    
    
    func deleteScript (defaults: Defaults, id: String) {
        let url = defaults.defaultURL+"/uapi/v1/scripts/"+"\(id)"
        print(url)
        print(token ?? "")
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "DELETE"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Bad Credentials")
                    return
            }
            print(httpResponse.statusCode)
            print("Just Deleted Script")
        
        }.resume()
        
    }
    
    
    func downloadScript(defaults:Defaults, id: String, control:ControlCenter){
            control.loading = true
           let url = defaults.defaultURL+"/uapi/v1/scripts/"+"\(id)"+"/download"
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
                control.scriptContents = (String(data:data, encoding: .utf8) ?? "No Details")
                control.loading = false
               }
           }.resume()
       }
    
}
