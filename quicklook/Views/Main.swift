//
//  MainMenu.swift
//  quicklook
//
//  Created by Toxcispu on 3/31/20.
//  Copyright © 2020 developer. All rights reserved.
//

//https://troz.net/post/2019/swiftui-data-flow/

import SwiftUI
import UIKit

struct Main: View {
    @EnvironmentObject var controlCenter: ControlCenter
    @ObservedObject var viewModel = Defaults()
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
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
            }.navigationBarTitle("quicklook jcs")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}


