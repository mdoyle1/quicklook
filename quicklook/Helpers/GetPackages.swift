//
//  GetPackages.swift
//  JAMFiOS
//
//  Created by developer on 4/8/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI

class GetPackages: ObservableObject {
    
@ObservedObject var viewModel = Defaults()

    
    func getPackages(completion: @escaping ([Responses.Packages.Response]) -> ()){
    let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/packages"
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
        guard let packages = try? JSONDecoder().decode(Responses.Packages.self, from: data) else {
            print ("Sacko")
            return}
        print("Got Packages?")
        
        DispatchQueue.main.async {
            completion(packages.packages)
            }
        }.resume()
    }
    
    
    
    func deletePackage (id: String) {
       let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/packages/id/"+"\(id)"
       print($viewModel.usernameStore.wrappedValue)
       print($viewModel.passwordStore.wrappedValue)
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
        print(config.httpAdditionalHeaders)
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
              print("Bad Credentials")
               print(response)
              return
          }
               print("Just Deleted Package")
            
           DispatchQueue.main.async {
   
                   }
              }.resume()
          }
    
    
    
    
    
}
