//
//  ComputerDetails.swift
//  quicklook
//
//  Created by Toxicspu on 4/24/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI

struct Computer: View {
    @EnvironmentObject var controlCenter: ControlCenter
    //COMPUTER IS ON RESPONSES LINE 470
    @State var computer: Responses.Computer?
    @State var policies: PoliciesAPI?
    let pasteboard = UIPasteboard.general
    @State private var showingAlert:Bool = false
    @State private var showScriptAlert:Bool = false
    var mappedPrinters:[Responses.ComputerDetail.MappedPrinter] = []
    @State private var packageWasPushed:Bool = false
    @State private var scriptWasPushed:Bool = false
    
    func initShareData(){
        sharedSubject = "***COMPUTER INFORMATION***"
        
        sharedItem = """
        "***COMPUTER INFORMATION***"
        COMPUTER NAME: \(computer?.computer?.general.name  ?? "")
        MAC OS VERSION: \(computer?.computer?.hardware.osVersion ?? "")
        ASSET TAG: \(computer?.computer?.general.name ?? "Item not tagged")
        SERIAL NUMBER: \(computer?.computer?.general.serialNumber  ?? "")
        PRIMARY MAC: \(computer?.computer?.general.mac_address ?? "")
        LAST CHECKIN: \(computer?.computer?.general.lastContactTime ?? "")
        LAST REPORTED IP: \(computer?.computer?.general.last_reported_ip ?? "")
        """
    }
    
    
    var body: some View {
        
      
        ScrollView{
            VStack(alignment: .leading){
                HStack{
                    VStack(alignment:.leading){
                Group {
                        NavigationLink(destination:ComputerCommandView())
                        {Text("Computer Commands").modifier(ButtonFormat())}
                        
                        //MARK: - PUSH PACKAGE
                        
                        HStack(alignment: .center){
                            Button(action:{ self.showingAlert = true}){
                                Text("Push Package").modifier(ButtonFormat())}
                                .alert(isPresented:self.$showingAlert) {
                                    if self.controlCenter.packageName == "" {
                                        return Alert(title: Text("Goto Main Menu > Packages and select a package to push!"), dismissButton: .default(Text("Got it!")))
                                    } else {
                                        return Alert(title: Text("Push Package\n \(self.controlCenter.packageName)?\n Are you sure?"), message: Text("Select 'Push Package' to continue.  A policy will be created with the current date, time and your username.  This can easily be deleted from the Main Menu > Policies section of Quicklook jcs "), primaryButton: .destructive(Text("Push Package")) {
                                            self.packageWasPushed = true
                                            PoliciesAPI().pushPackage(control: self.controlCenter, packageName: self.controlCenter.packageName, packageID: self.controlCenter.packageId ?? 0, computerID: self.computer?.computer?.general.jamfID ?? Int(), computerName: self.computer?.computer?.general.name ?? "", computerUDID: self.computer?.computer?.general.udid ?? "")
                                            print("Push Package \(self.controlCenter.packageName) to \(self.controlCenter.computerName)")
                                            }, secondaryButton: .cancel())}
                            }.environmentObject(controlCenter)
                            if self.packageWasPushed == false {
                                Image(systemName: "hand.thumbsup.fill").foregroundColor(.clear)
                            } else {
                                if self.packageWasPushed {
                                    if self.controlCenter.pushResponse == true {
                                        Image(systemName: "hand.thumbsup.fill").foregroundColor(.green)
                                    }else {
                                        Image(systemName: "hand.thumbsdown.fill").foregroundColor(.red)}
                                }
                            }
                        }
                            
                        //MARK: - PUSH SCRIPT
                  
                            HStack(alignment: .center){
                                Button(action:{ self.showScriptAlert = true}){
                                    Text("Push Script").modifier(ButtonFormat())}
                                    .alert(isPresented:self.$showScriptAlert) {
                                        if self.controlCenter.scriptName == "" {
                                            return Alert(title: Text("Goto Main Menu > Scripts and select a script to push!"), dismissButton: .default(Text("Got it!")))
                                        } else {
                                            return Alert(title: Text("Push Script\n \(self.controlCenter.scriptName)?\n Are you sure?"), message: Text("Select 'Push Script' to continue.  A policy will be created with the current date, time and your username.  This can easily be deleted from the Main Menu > Policies section of Quicklook jcs "), primaryButton: .destructive(Text("Push Script")) {
                                                self.scriptWasPushed = true
                                                PoliciesAPI().pushScript(control: self.controlCenter, scriptName: self.controlCenter.scriptName, scriptID: self.controlCenter.scriptId ?? "", computerID: self.computer?.computer?.general.jamfID ?? 0, computerName: self.computer?.computer?.general.name ?? "", computerUDID: self.computer?.computer?.general.udid ?? "")
                                                print("Push Script \(self.controlCenter.scriptName) to \(self.controlCenter.computerName)")
                                                }, secondaryButton: .cancel())}
                                }.environmentObject(controlCenter)
                                if self.scriptWasPushed == false {
                                    Image(systemName: "hand.thumbsup.fill").foregroundColor(.clear)
                                } else {
                                    if self.scriptWasPushed {
                                        if self.controlCenter.pushResponse == true {
                                            Image(systemName: "hand.thumbsup.fill").foregroundColor(.green)
                                        }else {
                                            Image(systemName: "hand.thumbsdown.fill").foregroundColor(.red)}
                                    }
                                }
                            }
                        }
                            .padding(.all, 5)
                            
                        
                        //ALLOW COPY TO PASTEBOARD FOR CERTAIN ITEMS
                        VStack(alignment:.leading){
                            Group{
                                HStack{ Text("Name: ").bold()
                                    Button(action: {self.pasteboard.string = self.computer?.computer?.general.name})
                                    {Text(computer?.computer?.general.name ?? "searching...")}}
                                
                                HStack { Text("MacOS Version: ").bold()
                                    Text(computer?.computer?.hardware.osVersion ?? "searching...")
                                }
                                
                                HStack{Text("IP: ").bold()
                                    Button(action: {self.pasteboard.string = self.computer?.computer?.general.ip_address })
                                     {Text(computer?.computer?.general.ip_address ?? "searching...")}}
                                
                                HStack{Text("Last Reported IP: ").bold()
                                    Button(action: {self.pasteboard.string = self.computer?.computer?.general.last_reported_ip })
                                    {Text(computer?.computer?.general.last_reported_ip ?? "searching...")}}
                                
                                HStack{Text("Serial: ").bold()
                                    Button(action: {self.pasteboard.string = self.computer?.computer?.general.serialNumber })
                                    {Text(computer?.computer?.general.serialNumber ?? "searching...")}}
                                
                                HStack{ Text("Asset Tag: ").bold()
                                     Button(action: {self.pasteboard.string = self.computer?.computer?.general.assetTag})
                                     {Text(computer?.computer?.general.assetTag ?? "searching...")}}
                                
                                HStack{ Text("Supervised: ").bold()
                                    Text(String(computer?.computer?.general.supervised?.description ?? "Unknown"))}
                                
                                VStack(alignment:.leading){Text("Last Contact Time:").bold()
                                    Text(String(computer?.computer?.general.lastContactTime ?? "Unknown"))}
                                
                                HStack{ Text("Primary MAC:").bold()
                                    Button(action: {self.pasteboard.string = self.computer?.computer?.general.mac_address})
                                    {Text(computer?.computer?.general.mac_address ?? "searching...")}}
                                
                                HStack{Text("Secondary MAC: ").bold()
                                     Button(action: {self.pasteboard.string = self.computer?.computer?.general.alt_mac_address})
                                     {Text(computer?.computer?.general.alt_mac_address ?? "searching...")}}
                            }.padding(.bottom, 10)
                            Group {
                                VStack(alignment: .leading){Text("Mapped Printers:").bold()
                                    
                                    ForEach (computer?.computer?.hardware.mappedPrinters ?? [], id: \.self){ printer in
                                        Text(printer.name ?? "")
                                    }
                            }
                        }
                        }.padding(.all, 10).background(Color(.gray).opacity(0.25)).cornerRadius(10).padding(.all, 5)
                    
                    }.padding(.leading, 12)
                    Spacer()
                }
                Spacer()
             
            }.onAppear {
                ComputerAPI().getComputer (id: self.controlCenter.computerId) { (computer) in
                    self.computer = computer
                    self.controlCenter.computer = computer
                    print(computer)
                   
                        
                    
                }
            }
        }.navigationBarTitle("Computer Details")
        .navigationBarItems(trailing:Button(action: {self.initShareData()
            Share().showView()}){Image(systemName:"square.and.arrow.up")})
    }
    
    struct ComputerCommandView: View {
        @EnvironmentObject var controlCenter: ControlCenter
        @State private var showingAlert:Bool = false
        struct ComputerCommands:Identifiable {
            var id = UUID()
            var key:String
            var value:String
            
        }
        
        
        var computerCommands:[ComputerCommands] = [
           // ComputerCommands(key:"DeviceLock",value:"Device Lock"),
           // ComputerCommands(key:"EraseDevice",value:"Erase Device"),
            ComputerCommands(key:"UnmanageDevice",value:"Unmanage Device"),
            ComputerCommands(key:"BlankPush",value:"Blank Push"),
           // ComputerCommands(key:"UnlockUserAccount",value:"Unlock User Account"),
            ComputerCommands(key:"SettingsEnableBluetooth",value:"Enable Bluetooth"),
            ComputerCommands(key:"SettingsDisableBluetooth",value:"Disable Bluetooth"),
            ComputerCommands(key:"EnableRemoteDesktop",value:"Enable Remote Desktop"),
            ComputerCommands(key:"DisableRemoteDesktop",value:"Disable Remote Desktop"),
           // ComputerCommands(key:"ScheduleOSUpdate", value:"macOS Update")
        ]
        
        var body: some View {
            List(computerCommands) { item in
                Button(action:{self.showingAlert = true})
                {Text(item.value).modifier(ButtonFormat())
                    .alert(isPresented:self.$showingAlert) {
                        Alert(title: Text("\(item.value)?\n Are you sure?"), message: Text("Computer: \(self.controlCenter.computerName.description)"), primaryButton: .destructive(Text("Run Command")) {
                            CommandAPI().JSSCommand(commandType:"computercommands", command:item.key, deviceId: self.controlCenter.computerId)
                            print("Running Command \(item.key) on id:\(self.controlCenter.computerId)")
                            }, secondaryButton: .cancel())
                    }
                }.navigationBarTitle("Computer Commands")
                
            }
        }
    }
}


