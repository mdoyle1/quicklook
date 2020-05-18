//
//  Defaults.swift
//  quicklook
//
//  Created by Toxicspu on 3/25/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI
import Combine



class Defaults : ObservableObject {
    private static let userDefaultURL = "defaultURL"
    private static let userDefaultUserName = "userName"
    private static let userDefaultPassword = "password"
   
    
    @Published var defaultURL = UserDefaults.standard.string(forKey: Defaults.userDefaultURL) ?? ""
    @Published var usernameStore = UserDefaults.standard.string(forKey: Defaults.userDefaultUserName) ?? ""
    @Published var passwordStore = UserDefaults.standard.string(forKey: Defaults.userDefaultPassword) ?? ""
   
    
   
    
    
    func clearCredentials(){
        defaultURL = ""
        usernameStore = ""
        passwordStore = ""
       // saved = false
    }
    
    private var canc: AnyCancellable!
    private var usercanc: AnyCancellable!
    private var passcanc: AnyCancellable!
 
    
    init() {
        canc = $defaultURL.debounce(for: 0.2, scheduler: DispatchQueue.main).sink { newText in
            UserDefaults.standard.set(newText, forKey: Defaults.userDefaultURL)}
        usercanc = $usernameStore.debounce(for: 0.2, scheduler: DispatchQueue.main).sink { newText in
            UserDefaults.standard.set(newText, forKey: Defaults.userDefaultUserName)}
        passcanc = $passwordStore.debounce(for: 0.2, scheduler: DispatchQueue.main).sink { newText in
            UserDefaults.standard.set(newText, forKey: Defaults.userDefaultPassword)}
       
    }

    deinit {
        canc.cancel()
        usercanc.cancel()
        passcanc.cancel()
      
    }
}

