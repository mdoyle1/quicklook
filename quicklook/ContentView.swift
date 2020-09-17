//
//  ContentView.swift
//  quicklook
//
//  Created by Toxicspu on 3/25/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI
//HELPFULL LINKS

//https://medium.com/better-programming/how-to-create-and-customize-a-textfield-in-swiftui-9e0d2a320416
//https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
//https://troz.net/post/2019/swiftui-data-flow/
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-delete-rows-from-a-list

struct ContentView: View {
    @EnvironmentObject var controlCenter: ControlCenter
    @ObservedObject var viewModel = Defaults()
    var body: some View {
        VStack{
            //Login Menu
            if saved.bool(forKey: "savedCredentials") {
                Main().onAppear{
                    TokenAPI().getToken(connect:self.controlCenter, defaults: self.viewModel,completion: {print("complete")})
                }
            }else {
            
            if self.controlCenter.loginToggle{
                Login()
            }
            
            //Main Menu
            if self.controlCenter.mainMenuToggle{
                Main()
            }
            }
        }.onAppear{
            print(saved)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ControlCenter())
    }
}
