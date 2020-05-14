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
    
    func initShareData(){
        sharedSubject = "***COMPUTER INFORMATION***"
        
        sharedItem = """
        "***COMPUTER INFORMATION***"
        COMPUTER NAME: \(computer?.computer?.general.name  ?? "")
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
                        NavigationLink(destination:ComputerCommandView())
                        {Text("Computer Commands").modifier(ButtonFormat())}
                        VStack(alignment:.leading){
                            Group{
                                HStack{ Text("Name: ").bold()
                                    Text(computer?.computer?.general.name ?? "searching...")}
                                
                                HStack{Text("IP: ").bold()
                                    Text(computer?.computer?.general.ip_address ?? "searching...")}
                                
                                HStack{ Text("Last Reported IP: ").bold()
                                    Text(computer?.computer?.general.last_reported_ip ?? "searching...")}
                                
                                HStack{ Text("Serial: ").bold()
                                    Text(computer?.computer?.general.serialNumber ?? "searching...")}
                                
                                HStack{ Text("Asset Tag: ").bold()
                                    Text(computer?.computer?.general.assetTag ?? "searching...")}
                                
                                HStack{ Text("Supervised: ").bold()
                                    Text(String(computer?.computer?.general.supervised?.description ?? "Unknown"))}
                                
                                HStack{ Text("Last Contact Time: ").bold()
                                    Text(String(computer?.computer?.general.lastContactTime ?? "Unknown"))}
                                
                                HStack{ Text("Primary MAC:").bold()
                                    Text(computer?.computer?.general.mac_address ?? "searching...")}
                                
                                HStack{Text("Secondary MAC: ").bold()
                                    Text(computer?.computer?.general.alt_mac_address ?? "searching...")}
                                
                            }
                        }.padding(.all, 10).background(Color(.red).opacity(0.25)).cornerRadius(10)
                        
                        VStack(alignment: .center) {
                            Button(action: {self.initShareData()
                                Share().showView()}){Image(systemName:"square.and.arrow.up")
                                    .font(.largeTitle)
                                    .padding(.all, 10)
                                    
                            }
                            
                        }
                    }.padding(.leading, 15)
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
    }
    
    struct ComputerCommandView: View {
        @EnvironmentObject var controlCenter: ControlCenter
        @State var showingAlert:Bool = false
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


