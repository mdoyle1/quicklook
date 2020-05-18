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
        VStack{
            if self.controlCenter.logout == false {
            Menu()
        }else {
            Login()
            }
        }
    }
}


struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}


