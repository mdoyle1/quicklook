//
//  Menu.swift
//  quicklook
//
//  Created by developer on 5/15/20.
//  Copyright © 2020 Toxicspu. All rights reserved.
//

import SwiftUI

struct Menu: View {
    @EnvironmentObject var controlCenter: ControlCenter
    @ObservedObject var viewModel = Defaults()
    @State var alert = saved.bool(forKey: "credAlert")
    
    var body: some View {
        
        NavigationView{
            
            List{
                //SCRIPTS
                NavigationLink(destination:Scripts())
                {Text("Scripts").modifier(ButtonFormat())}
                
                //PACKAGES
                NavigationLink(destination: Packages())
                {Text("Packages").modifier(ButtonFormat())}
                
                
                //COMPUTERS
                NavigationLink(destination:ComputerMatch())
                {Text("Computers").modifier(ButtonFormat())}
                
                //DEVICES
                NavigationLink(destination:DeviceMatch())
                {Text("Devices").modifier(ButtonFormat())}
                
                //COMPUTER POLICIES
                NavigationLink(destination:Policies())
                {Text("Policies").modifier(ButtonFormat())}
                
                //MOBILE CONFIGURATIONS
                NavigationLink(destination:MobileConfig())
                {Text("iOS Configurations").modifier(ButtonFormat())}
                
                //COMPUTER CONFIGURATIONS
                NavigationLink(destination:ComputerConfig())
                {Text("macOS Configurations").modifier(ButtonFormat())}
                
            }.navigationBarTitle(Text("Main Menu"))
                .navigationBarItems(leading:Text("quicklook jcs").font(.headline).bold(), trailing: Button(action:{
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    saved.set(false, forKey: "savedCredentials")
                    saved.set(true, forKey:"credAlert")
                    self.controlCenter.logout = true
                    self.controlCenter.loginAttempts = false
                }){Text("logout")})
        }.navigationViewStyle(StackNavigationViewStyle())
            .alert(isPresented: $alert) {
                Alert(title: Text("Save Credentials?"), message: Text("Would you like to save your credentials?"), primaryButton: .default (Text("Save")) {
                    print("Credentials Saved")
                    saved.set(true, forKey: "savedCredentials")
                    saved.set(false, forKey: "credAlert")
                    print(saved)
                    }, secondaryButton:
                    .default(Text("Forget")){
                        
                        let domain = Bundle.main.bundleIdentifier!
                        UserDefaults.standard.removePersistentDomain(forName: domain)
                        UserDefaults.standard.synchronize()
                        saved.set(false, forKey: "savedCredentials")
                        saved.set(true, forKey: "credAlert")
                    })
        }
    }
}


