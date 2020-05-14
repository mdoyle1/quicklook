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
    @State var shareItem:String?
    @State var showingAlert:Bool = false
    var popupView:Share?

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
                        {Text("Mobile Commands").modifier(ButtonFormat())}
                        VStack(alignment:.leading){
                        Group{
                            VStack(alignment:.leading){ Text("Device Name: ").bold()
                                Text(mobileDevice?.mobileDevice?.general?.name ?? "searching...")}.padding(.bottom, 10)
                            
                            HStack{
                                Text("Asset Tag: ").bold()
                                if mobileDevice?.mobileDevice?.general?.assetTag == "" {Text("Device not tagged")
                                }else{Text(mobileDevice?.mobileDevice?.general?.assetTag ?? "searching...")}}.padding(.bottom, 10)
                            
                            VStack(alignment:.leading){ Text("Serial: ").bold()
                                Text(mobileDevice?.mobileDevice?.general?.serialNumber ?? "searching...")}.padding(.bottom, 10)
                            
                            HStack{ Text("Last Reported IP: ").bold()
                                Text(mobileDevice?.mobileDevice?.general?.ipAddress ?? "searching...")}.padding(.bottom, 10)
                            
                            VStack(alignment:.leading){ Text("Last Inventory Update: ").bold()
                                Text(mobileDevice?.mobileDevice?.general?.lastInventoryUpdate ?? "searching...")}.padding(.bottom, 10)
                            
                            HStack{ Text("Storage Capacity: ").bold()
                                Text(String(mobileDevice?.mobileDevice?.general?.capacity ?? 0)+"mb")}.padding(.bottom, 10)
                            
                            HStack{ Text("Storage Available: ").bold()
                                Text(String(mobileDevice?.mobileDevice?.general?.availableMB ?? 0)+"mb")}.padding(.bottom, 10)
                            
                            HStack{ Text("Primary MAC:").bold()
                                Text(mobileDevice?.mobileDevice?.general?.wifiMACAddress ?? "searching...")}.padding(.bottom, 10)
                            
                            HStack{Text("OS Version: ").bold()
                                Text(mobileDevice?.mobileDevice?.general?.osVersion ?? "searching...")}.padding(.bottom, 10)
                            
                            VStack(alignment:.leading){ Text("Assigned User: ").bold()
                                Text(mobileDevice?.mobileDevice?.location?.username ?? "searching...")}.padding(.bottom, 10)}
                        Group{
                            VStack(alignment: .leading){
                                Text("Office Phone: ")
                                Text(mobileDevice?.mobileDevice?.location?.phone ?? "searching...").padding(.bottom, 10)
                                
                                Text("Mobile Phone: ")
                                Text(mobileDevice?.mobileDevice?.network?.phoneNumber ?? "searching...").padding(.bottom, 10)
                                
                                Text("IMEI: ")
                                Text(mobileDevice?.mobileDevice?.network?.imei ?? "searching...").padding(.bottom, 10)
                                
                                Text("ICCID: ")
                                Text(mobileDevice?.mobileDevice?.network?.iccid ?? "searching...").padding(.bottom, 10)
                            }
                            
                            }
                        }.padding(.all, 10).background(Color(.blue).opacity(0.25)).cornerRadius(10)
                        
                        
                        VStack(alignment:.center) {
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
                print(self.controlCenter.deviceId)
                MobileDeviceAPI().getDevice (id: self.controlCenter.deviceId) { (mobileDevice) in
                    self.mobileDevice = mobileDevice
                    self.controlCenter.mobileDevice = mobileDevice
                    print(mobileDevice)
                }
            }
        }.navigationBarTitle("Device Details")
    }
    
    struct MobileCommandView: View {
        @EnvironmentObject var controlCenter: ControlCenter
        @State var showingAlert:Bool = false
        struct MobileCommands:Identifiable {
            var id = UUID()
            var key:String
            var value:String
            
        }
        var mobileCommands:[MobileCommands] = [
            MobileCommands(key:"RestartDevice",value:"Restart Device"),
            MobileCommands(key:"ShutDownDevice",value:"Shutdown Device"),
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
            List(mobileCommands) { item in
                Button(action:{self.showingAlert = true})
                {Text(item.value).modifier(ButtonFormat())
                    .alert(isPresented:self.$showingAlert) {
                        Alert(title: Text("\(item.value)?\n Are you sure?"), message: Text("Mobile Device: \(self.controlCenter.deviceName.description)"), primaryButton: .destructive(Text("Run Command")) {
                            CommandAPI().JSSCommand(commandType:"mobiledevicecommands", command:item.key, deviceId: self.controlCenter.deviceId )
                            print("Deleting...")
                            }, secondaryButton: .cancel())
                    }
                }.navigationBarTitle("Mobile Commands")
                
            }
        }
    }
}






//SSResource/mobiledevicecommands/command/ScheduleOSUpdate/2/id/13 -X POST
