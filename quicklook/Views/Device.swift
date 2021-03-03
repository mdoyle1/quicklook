//
//  Device.swift
//  quicklook
//
//  Created by Toxicspu on 5/4/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI

struct Device: View {
    @EnvironmentObject var controlCenter: ControlCenter
    @State var mobileDevice: Responses.MobileDevice?
    var jamfID:String
    var jamfName:String
    var defaults:Defaults = Defaults()
 
    @State var shareItem:String?
    @State var showingAlert:Bool = false
    var popupView:Share?
     let tel = "tel://"
    let pasteboard = UIPasteboard.general
    
    func initShareData(){
        sharedSubject = "***DEVICE INFORMATION***"
        
        sharedItem = """
        "***DEVICE INFORMATION***"
        Device Name: \(mobileDevice?.mobileDevice?.general?.name ?? "")
        Asset Tag: \(mobileDevice?.mobileDevice?.general?.assetTag ?? "Item not tagged")
        Serial Number: \(mobileDevice?.mobileDevice?.general?.serialNumber ?? "")
        OS Version: \(mobileDevice?.mobileDevice?.general?.osVersion ?? "")"
        Last Reported IP: \(mobileDevice?.mobileDevice?.general?.ipAddress ?? "")
        Last Inventory Update: \(mobileDevice?.mobileDevice?.general?.lastInventoryUpdate ?? "")
        Storage Capacity: \(String(mobileDevice?.mobileDevice?.general?.capacity ?? 0))mb
        Storage Available: \(String(mobileDevice?.mobileDevice?.general?.availableMB ?? 0))mb
        Primary MAC: \(mobileDevice?.mobileDevice?.general?.wifiMACAddress ?? "")
        Mobile Phone: \(mobileDevice?.mobileDevice?.network?.phoneNumber ?? "N/A")
        IMEI: \(mobileDevice?.mobileDevice?.network?.imei ?? "N/A")
        ICCID: \(mobileDevice?.mobileDevice?.network?.iccid ?? "N/A")
        """
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                HStack{
                    VStack(alignment:.leading){
                        
                        NavigationLink(destination:MobileCommandView())
                        {Text("Mobile Commands").modifier(ButtonFormat())}.padding(.bottom, 10)
                        VStack(alignment:.leading){
                        Group{
                            VStack(alignment:.leading){
                                
                                Text("Device Name: ").bold()
                                Text(mobileDevice?.mobileDevice?.general?.name ?? "searching...")}.padding(.bottom, 10)
                           
                            VStack(alignment:.leading){
                                
                                Text("Last iCloud Backup: ").bold()
                                Text("\(NSDate(timeIntervalSince1970: TimeInterval(mobileDevice?.mobileDevice?.general?.lastCloudBackupDateEpoch ?? 0)/1000))")}
                                .padding(.bottom, 10)
                            
                            HStack{ Text("JAMF ID: ").bold()
                                if #available(iOS 14.0, *) {
                                    Link("\(mobileDevice?.mobileDevice?.general?.id ?? 0)", destination: URL(string: "\(defaults.defaultURL)/mobileDevices.html?id="+"\(mobileDevice?.mobileDevice?.general?.id ?? 0)")!)
                                } else {
                                    Text(String(mobileDevice?.mobileDevice?.general?.id ?? 0))}
                                }   .padding(.bottom, 10)
                            }
                            HStack{
                                Text("Asset Tag: ").bold()
                                if mobileDevice?.mobileDevice?.general?.assetTag == "" {Text("Device not tagged")
                                }else{Text(mobileDevice?.mobileDevice?.general?.assetTag ?? "searching...")}}
                            
                            VStack(alignment:.leading){ Text("Serial: ").bold()
                                Text(mobileDevice?.mobileDevice?.general?.serialNumber ?? "searching...")}
                        }
                            Group {
                            HStack{ Text("Last Reported IP: ").bold()
                                Text(mobileDevice?.mobileDevice?.general?.ipAddress ?? "searching...")}
                            
                            VStack(alignment:.leading){ Text("Last Inventory Update: ").bold()
                                Text(mobileDevice?.mobileDevice?.general?.lastInventoryUpdate ?? "searching...")}
                            
                            HStack{ Text("Storage Capacity: ").bold()
                                Text(String(mobileDevice?.mobileDevice?.general?.capacity ?? 0)+"mb")}
                            
                            HStack{ Text("Storage Available: ").bold()
                                Text(String(mobileDevice?.mobileDevice?.general?.availableMB ?? 0)+"mb")}
                            
                            HStack{ Text("Primary MAC:").bold()
                                Button(action: {self.pasteboard.string = self.mobileDevice?.mobileDevice?.general?.wifiMACAddress ?? ""})
                                {Text(mobileDevice?.mobileDevice?.general?.wifiMACAddress ?? "searching...")}}
                            
                            HStack{Text("OS Version: ").bold()
                                Text(mobileDevice?.mobileDevice?.general?.osVersion ?? "searching...")}
                            
                            VStack(alignment:.leading){ Text("Assigned User: ").bold()
                                Text(mobileDevice?.mobileDevice?.location?.username ?? "searching...")}
                            
                            }.padding(.bottom, 10)
                            
                        Group{
                            VStack(alignment: .leading){
                                Text("Office Phone: ")
                                Button(action:{
                                    
                                    let formattedString = self.tel+(self.mobileDevice?.mobileDevice?.location?.phone?.replacingOccurrences(of: "-", with: "") ?? "")
                                    print(formattedString)
                                    guard let url = URL(string: formattedString) else {
                                        print("Shit")
                                        return }
                                    UIApplication.shared.open(url)
                                })
                                {Text(mobileDevice?.mobileDevice?.location?.phone ?? "searching...")}
                                
                                Text("Mobile Phone: ")
                                Button(action:{
                                    let formattedString = self.tel+(self.mobileDevice?.mobileDevice?.network?.phoneNumber!.replacingOccurrences(of: "-", with: "") ?? "")
                                    print(formattedString)
                                    guard let url = URL(string: formattedString) else {
                                        print("Shit")
                                        return }
                                    UIApplication.shared.open(url)
                                }){
                                    Text(mobileDevice?.mobileDevice?.network?.phoneNumber ?? "searching...")}
                                
                                Text("IMEI: ")
                                  Button(action: {self.pasteboard.string = self.mobileDevice?.mobileDevice?.network?.imei  ?? ""})
                                  {Text(mobileDevice?.mobileDevice?.network?.imei ?? "searching...")}
                                
                                Text("ICCID: ")
                                 Button(action: {self.pasteboard.string = self.mobileDevice?.mobileDevice?.network?.iccid  ?? ""})
                                 {Text(mobileDevice?.mobileDevice?.network?.iccid ?? "searching...")}
                            }
                            
                            }.padding(.bottom, 10)
                        }.padding(.all, 10).background(Color(.gray).opacity(0.25)).cornerRadius(10)
                        
                        
                  
                    }.padding(.leading, 15)
                    
                    Spacer()
                }
                Spacer()
                
            
        }.navigationBarTitle("Device Details")
        .navigationBarItems(trailing: Button(action: {
                                                self.initShareData()
                                                Share().showView()}){Image(systemName:"square.and.arrow.up").font(.body).padding(.all, 10)})
        .onAppear {
            print(self.controlCenter.deviceId)
            MobileDeviceAPI().getDevice (id: self.jamfID) { (mobileDevice) in
                self.mobileDevice = mobileDevice
                self.controlCenter.mobileDevice = mobileDevice
                print(mobileDevice)
            }
        }
    }
    
    struct MobileCommandView: View {
        @EnvironmentObject var controlCenter: ControlCenter
        @State var showingAlert:Bool = false
        @State var currentItem:MobileCommands = MobileCommands(key: "", value: "")
        struct MobileCommands:Identifiable {
            var id = UUID()
            var key:String
            var value:String
            
        }
        var mobileCommands:[MobileCommands] = [
            MobileCommands(key:"RestartDevice",value:"Restart Device"),
            MobileCommands(key:"ShutDownDevice",value:"Shutdown Device"),
            MobileCommands(key:"BlankPush",value:"Blank Push"),
            MobileCommands(key:"UpdateInventory",value:"Update Inventory"),
            MobileCommands(key:"ClearPasscode",value:"Clear Passcode"),
            MobileCommands(key:"UnmanageDevice",value:"Unmanage Device"),
            MobileCommands(key:"ClearRestrictionsPassword",value:"Clear Restrictions Password"),
            MobileCommands(key:"SettingsEnableBluetooth",value:"Enable Bluetooth"),
            MobileCommands(key:"SettingsDisableBluetooth",value:"Disable Bluetooth"),
            MobileCommands(key:"SettingsEnablePersonalHotspot",value:"Enable Hotspot"),
            MobileCommands(key:"SettingsDisablePersonalHotspot", value:"Disable Hotspot"),
            MobileCommands(key:"SettingsEnableDataRoaming",value:"Enable Data Roaming"),
            MobileCommands(key:"SettingsEnableVoiceRoaming",value:"Enable Voice Roaming"),
            MobileCommands(key:"SettingsDisableDataRoaming",value:"Disable Data Roaming"),
            MobileCommands(key:"SettingsDisableVoiceRoaming",value:"Disable Voice Roaming"),
            MobileCommands(key:"EnableLostMode",value:"Enable Lost Mode"),
            MobileCommands(key:"DisableLostMode",value:"Disable Lost Mode"),
            MobileCommands(key:"DeviceLocation",value:"Device Location"),
            MobileCommands(key:"PlayLostModeSound",value:"Play Lost Mode Sound"),
            MobileCommands(key:"ScheduleOSUpdate/2",value:"Force iOS Update"),
            MobileCommands(key:"ScheduleOSUpdate/1",value:"Download iOS Update")
        ]
        
        var body: some View {
            List(mobileCommands.sorted(by:{$0.key < $1.key})) { item in
                Button(action:{
                    self.showingAlert = true
                    currentItem = item
                })
                {Text(item.value).modifier(ButtonFormat())
                    .alert(isPresented:self.$showingAlert) {
                        Alert(title: Text("\(self.currentItem.value)?\n Are you sure?"), message: Text("Mobile Device: \(self.controlCenter.deviceName.description)"), primaryButton: .destructive(Text("Run Command")) {
                            CommandAPI().JSSCommand(commandType:"mobiledevicecommands", command:self.currentItem.key, deviceId: self.controlCenter.deviceId )
                            print("Deleting...")
                            }, secondaryButton: .cancel())
                    }
                }.navigationBarTitle("Mobile Commands")
                
            }
        }
    }
}






//SSResource/mobiledevicecommands/command/ScheduleOSUpdate/2/id/13 -X POST
