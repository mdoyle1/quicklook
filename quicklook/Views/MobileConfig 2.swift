//
//  MobileConfigView.swift
//  quicklook
//
//  Created by Toxcispu on 5/6/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI

struct MobileConfig: View {
    @EnvironmentObject var controlCenter: ControlCenter
    @State var configurations: [Responses.ConfigurationProfiles.ConfigurationProfile] = []
    @State private var firstLoader:Bool = true
    
    
    
    var body: some View {
        List {
            ForEach(configurations) { config in
                NavigationLink(destination: MobileConfigDetailView().onAppear{
                    self.controlCenter.iosConfigId = String(config.jamfId?.description ?? "")
                    self.controlCenter.iosConfigName = config.name ?? ""})
                {Button(action: {})
                {Text(config.name ?? "")}.font(.body)}
            }.navigationBarTitle("iOS Configuration Profile").font(.title)
        }.onAppear {if self.firstLoader { MobileConfigAPI().getMobileConfig { (configurations) in
            self.configurations = configurations
            self.firstLoader = false
            }
            }
        }
    }
}


struct MobileConfigDetailView: View {
    @EnvironmentObject var controlCenter:ControlCenter
    @State var iosConfig:Responses.MobileConfigurationProfile?
    @State var allDevices:String = "true"
    @GestureState var scale: CGFloat = 1.0
    var body: some View {
        ScrollView{
            HStack{
                VStack(alignment: .leading){
                    
                    Text(iosConfig?.configuration_profile?.general?.name ?? "").font(.largeTitle).padding(.bottom, 10)
                    
                    
                    //MARK: - SCOPE
                    Group{
                        VStack(alignment:.leading){
                            
                            //POLICY SCOPE
                            Text("Scope").font(.title).bold().underline().padding(.bottom, 10)
                            
                            HStack{
                                Text("All Devices: ").bold().font(.headline)
                                Text(iosConfig?.configuration_profile?.scope?.all_mobile_devices?.description ?? "searching...").font(.subheadline)
                            }.padding(.bottom,10)
                            
                            //IF ALL COMPUTERS = TRUE NO NEED TO SHOW BASIC SCOPE
                            if self.allDevices != "true" {
                                Text("Devices:").bold().font(.headline)
                                VStack(alignment:.leading){
                                    if iosConfig?.configuration_profile?.scope?.mobile_devices?.count == 0 {
                                        Text("No Devices").font(.subheadline)
                                    } else {
                                        ForEach(iosConfig?.configuration_profile?.scope?.mobile_devices ?? []) { device in
                                            Text(String(device.name ?? "")).font(.subheadline)
                                        }
                                    }
                                }.padding(.bottom,10)
                                
                                Text("Device Groups: ").bold().font(.headline)
                                VStack(alignment:.leading){
                                    if iosConfig?.configuration_profile?.scope?.mobile_device_groups?.count == 0 {
                                        Text("Not Scoped to a Group").font(.subheadline)
                                    } else {
                                        ForEach(iosConfig?.configuration_profile?.scope?.mobile_device_groups ?? []) {group in
                                            Text(String(group.name ?? "")).font(.subheadline)}}
                                }.padding(.bottom,10)
                                
                                //BUILDINGS IN SCOPE
                                
                                Text("Buildings: ").font(.headline)
                                
                                VStack(alignment:.leading){
                                    if iosConfig?.configuration_profile?.scope?.buildings?.count == 0 {
                                        Text("Not Scoped to any Buildings").font(.subheadline)
                                    } else {
                                        ForEach(iosConfig?.configuration_profile?.scope?.buildings ?? []) {building in
                                            Text(String(building.name ?? "")).font(.subheadline)}}
                                }.padding(.bottom,10)
                                
                                //DEPARTMENTS IN SCOPE
                                
                                Text("Departments: ").font(.headline)
                                
                                VStack(alignment:.leading){
                                    if iosConfig?.configuration_profile?.scope?.departments?.count == 0 {
                                        Text("Not Scoped to any Departments").font(.subheadline)
                                    } else {
                                        ForEach(iosConfig?.configuration_profile?.scope?.departments ?? []) {department in
                                            Text(String(department.name ?? "")).font(.subheadline)}}
                                }.padding(.bottom,10)}
                            
                        }.padding(.all, 10).background(Color(.gray).opacity(1)).cornerRadius(10)
                    }.padding(.bottom, 10)
                    
                    
                    
                    //MARK: - SCOPE LIMITATIONS
                    Group{
                        //USERS
                        VStack(alignment:.leading){
                            Text("Scope Limitations").font(.title).bold().underline().padding(.bottom,10)
                            
                            Text("Users: ").font(.headline)
                            if iosConfig?.configuration_profile?.scope?.limitations?.users?.count == 0 {
                                Text("Not Limited to any Users").font(.subheadline).padding(.bottom,10)} else {
                                VStack(alignment:.leading){
                                    ForEach(iosConfig?.configuration_profile?.scope?.limitations?.users ?? []) {user in
                                        Text(String(user.name ?? "")).font(.subheadline)}
                                }.padding(.bottom,10)
                            }
                            
                            
                            //USER GROUPS
                            Text("User Groups: ").font(.headline)
                            if iosConfig?.configuration_profile?.scope?.limitations?.userGroups?.count == 0 {
                                Text("Not Limited to any User Groups").font(.subheadline).padding(.bottom,10)
                            } else {
                                VStack(alignment:.leading){
                                    ForEach(iosConfig?.configuration_profile?.scope?.limitations?.userGroups ?? []) {userGroup in
                                        Text(String(userGroup.name ?? "")).font(.subheadline)}}.padding(.bottom,10)}
                            
                            //NETWORK SEGMENTS
                            Text("Network Segments: ").font(.headline)
                            if iosConfig?.configuration_profile?.scope?.limitations?.network_segments?.count == 0 {
                                Text("Not Limited to Network Segments").font(.subheadline).padding(.bottom,10)
                            } else {
                                VStack(alignment:.leading){
                                    ForEach(iosConfig?.configuration_profile?.scope?.limitations?.network_segments ?? []) {segment in
                                        Text(String(segment.name ?? "")).font(.subheadline)}}.padding(.bottom,10)}
                            
                            
                            //IBEACONS
                            Text("iBeacons: ").font(.headline)
                            if iosConfig?.configuration_profile?.scope?.limitations?.ibeacons?.count == 0 {
                                Text("Not Limited iBeacons").font(.subheadline).padding(.bottom,10)
                            } else {
                                VStack(alignment:.leading){
                                    ForEach(iosConfig?.configuration_profile?.scope?.limitations?.ibeacons ?? []) {beacon in
                                        Text(String(beacon.name ?? "")).font(.subheadline)}}.padding(.bottom,10)}
                            
                        } .padding(.all, 10).background(Color(.gray).opacity(0.75)).cornerRadius(10)
                    }.padding(.bottom, 10)
                    
                    
                    
                    //MARK: - SCOPE EXCLUSIONS
                    Group{
                        VStack(alignment:.leading){
                            Text("Scope Exclusions").font(.title).bold().underline().padding(.bottom,10)
                            
                            VStack(alignment:.leading){
                                Text("Devices: ").font(.headline)
                                if iosConfig?.configuration_profile?.scope?.exclusions?.mobile_devices?.count == 0 {
                                    Text("No Devices Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(iosConfig?.configuration_profile?.scope?.exclusions?.mobile_devices ?? []) {computer in
                                        Text(String(computer.name ?? "")).font(.subheadline) }.padding(.bottom,10)
                                }
                                
                                Text("Device Groups: ").font(.headline)
                                if iosConfig?.configuration_profile?.scope?.exclusions?.mobile_device_groups?.count == 0 {
                                    Text("No Device Groups Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(iosConfig?.configuration_profile?.scope?.exclusions?.mobile_device_groups ?? []) {group in
                                        Text(group.name ?? "No Device Groups Excluded").font(.subheadline)}.padding(.bottom,10)
                                }
                                
                                Text("Buildings: ").font(.headline)
                                if iosConfig?.configuration_profile?.scope?.exclusions?.buildings?.count == 0 {
                                    Text("No Buildings Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(iosConfig?.configuration_profile?.scope?.exclusions?.buildings ?? []) {building in
                                        Text(building.name ?? "No Buildings Excluded")}.padding(.bottom,10)
                                }
                                
                                Text("Departments: ").font(.headline)
                                if iosConfig?.configuration_profile?.scope?.exclusions?.departments?.count == 0 {
                                    Text("No Departments Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(iosConfig?.configuration_profile?.scope?.exclusions?.departments ?? []) {departments in
                                        Text(departments.name ?? "No Departments Excluded")}.padding(.bottom,10)
                                }
                                
                                Text("Users: ").font(.headline)
                                if iosConfig?.configuration_profile?.scope?.exclusions?.jss_users?.count == 0 {
                                    Text("No Users Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(iosConfig?.configuration_profile?.scope?.exclusions?.users ?? []) {users in
                                        Text(users.name ?? "No Users Excluded")}.padding(.bottom,10)
                                    
                                }
                            }
                            
                            Group {
                                VStack(alignment:.leading){
                                    Text("Network Segments: ").font(.headline)
                                    if iosConfig?.configuration_profile?.scope?.exclusions?.networkSegments?.count == 0 {
                                        Text("Network Segments Excluded").font(.subheadline).padding(.bottom,10)
                                    } else {
                                        ForEach(iosConfig?.configuration_profile?.scope?.exclusions?.networkSegments ?? []) {segments in
                                            Text(segments.name ?? "Network Segments Excluded")}.padding(.bottom,10)
                                    }
                                    
                                }.padding(.bottom,10)
                            }
                        }.padding(.all, 10).background(Color(.gray).opacity(0.5)).cornerRadius(10)
                        
                    }.padding(.bottom, 10)
                    
                    //MARK: - CONFIGURATION PAYLOAD
                    Group{
                        VStack(alignment:.leading){
                            Text("Configuration Payload").font(.title).bold().underline().padding(.bottom, 10)
                            ForEach(mobileConfigPayloads) { item in
                                Text("\(item.payload ?? "")").font(.body)
                            }
                        }.padding(.all, 10).background(Color(.systemPink).opacity(0.3)).cornerRadius(10)
                    }.padding(.bottom, 10)
                    Spacer()
                }.padding(.leading, 14)
                Spacer()
            }.onAppear{
                
                //ON APPEAR THE MOBILE CONFIG API IS RUN TO GET DEVICE DETAILS
                //ITS COMPLETION HANDLER RETURNS THE IOS CONFIG DETAILS TO A LOCAL VARIABLE
                MobileConfigAPI().mobileConfigDetails(id: self.controlCenter.iosConfigId) { (iosConfig) in
                    self.iosConfig = iosConfig
                    self.allDevices = iosConfig.configuration_profile?.scope?.all_mobile_devices?.description ?? "false"
                    print(iosConfig)}
            }
            
            
        }.navigationBarTitle("iOS Configuration Profile").font(.title)
        
    }
    
    
}


