//
//  ComputerConfigView.swift
//  quicklook
//
//  Created by Toxicspu on 5/6/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI

struct ComputerConfig: View {
    @EnvironmentObject var controlCenter: ControlCenter
    @State var configurations: [Responses.ConfigurationProfiles.ConfigurationProfile] = []
    @State private var firstLoader:Bool = true
    
    
    var body: some View {
        List {
            ForEach(configurations) { config in
                NavigationLink(destination: ComputerConfigDetailView(jamfID: String(config.jamfId?.description ?? "")).onAppear{
                    //STORE THE JAMF ID IN A SHARED VARIABLE FOR THE API CALL
                    self.controlCenter.osxConfigId = String(config.jamfId?.description ?? "")
                    self.controlCenter.osxConfigName = config.name ?? ""})
                {Button(action: {})
                {Text(config.name ?? "")}.font(.body)
                }
            }.navigationBarTitle("macOS Configuration Profile").font(.title)
        }.onAppear {if self.firstLoader { ComputerConfigAPI().getComputerConfig { (configurations) in
            self.configurations = configurations
            self.firstLoader = false
            //FIRST LOADER IS USED SO THE API ISN'T CALLED EVERY TIME THE THE VIEW IS ACCESSED
            }
            }
        }
    }
}

struct ComputerConfigDetailView: View {
    @EnvironmentObject var controlCenter: ControlCenter
    @State var osxConfig:Responses.OsXConfigurationProfile?
    @State var allDevices:String = "true"
    var jamfID:String
    var body: some View {
        ScrollView{
            HStack{
                VStack(alignment: .leading){
                    Text(osxConfig?.os_x_configuration_profile?.general?.name ?? "").font(.largeTitle).padding(.bottom, 10)
                    
                    
                    //MARK: - SCOPE
                    Group{
                        VStack(alignment:.leading){
                            
                            //POLICY SCOPE
                            Text("Scope").font(.title).bold().underline().padding(.bottom, 10)
                            
                            HStack{
                                Text("All Devices: ").bold().font(.headline)
                                Text(osxConfig?.os_x_configuration_profile?.scope?.allComputers?.description ?? "searching...").font(.subheadline)
                            }.padding(.bottom,10)
                            
                            //IF ALL COMPUTERS = TRUE NO NEED TO SHOW BASIC SCOPE
                            if self.allDevices != "true" {
                                Text("Devices:").bold().font(.headline)
                                VStack(alignment:.leading){
                                    if osxConfig?.os_x_configuration_profile?.scope?.computers?.count == 0 {
                                        Text("No Devices").font(.subheadline)
                                    } else {
                                        ForEach(osxConfig?.os_x_configuration_profile?.scope?.computers ?? []) { device in
                                            Text(String(device.name ?? "")).font(.subheadline)
                                        }
                                    }
                                }.padding(.bottom,10)
                                
                                Text("Device Groups: ").bold().font(.headline)
                                VStack(alignment:.leading){
                                    if osxConfig?.os_x_configuration_profile?.scope?.computerGroups?.count == 0 {
                                        Text("Not Scoped to a Group").font(.subheadline)
                                    } else {
                                        ForEach(osxConfig?.os_x_configuration_profile?.scope?.computerGroups ?? []) {group in
                                            Text(String(group.name ?? "")).font(.subheadline)}}
                                }.padding(.bottom,10)
                                
                                //BUILDINGS IN SCOPE
                                
                                Text("Buildings: ").font(.headline)
                                
                                VStack(alignment:.leading){
                                    if osxConfig?.os_x_configuration_profile?.scope?.buildings?.count == 0 {
                                        Text("Not Scoped to any Buildings").font(.subheadline)
                                    } else {
                                        ForEach(osxConfig?.os_x_configuration_profile?.scope?.buildings ?? []) {building in
                                            Text(String(building.name ?? "")).font(.subheadline)}}
                                }.padding(.bottom,10)
                                
                                //DEPARTMENTS IN SCOPE
                                
                                Text("Departments: ").font(.headline)
                                
                                VStack(alignment:.leading){
                                    if osxConfig?.os_x_configuration_profile?.scope?.departments?.count == 0 {
                                        Text("Not Scoped to any Departments").font(.subheadline)
                                    } else {
                                        ForEach(osxConfig?.os_x_configuration_profile?.scope?.departments ?? []) {department in
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
                            if osxConfig?.os_x_configuration_profile?.scope?.limitations?.users?.count == 0 {
                                Text("Not Limited to any Users").font(.subheadline).padding(.bottom,10)} else {
                                VStack(alignment:.leading){
                                    ForEach(osxConfig?.os_x_configuration_profile?.scope?.limitations?.users ?? []) {user in
                                        Text(String(user.name ?? "")).font(.subheadline)}
                                }.padding(.bottom,10)
                            }
                            
                            
                            //USER GROUPS
                            Text("User Groups: ").font(.headline)
                            if osxConfig?.os_x_configuration_profile?.scope?.limitations?.userGroups?.count == 0 {
                                Text("Not Limited to any User Groups").font(.subheadline).padding(.bottom,10)
                            } else {
                                VStack(alignment:.leading){
                                    ForEach(osxConfig?.os_x_configuration_profile?.scope?.limitations?.userGroups ?? []) {userGroup in
                                        Text(String(userGroup.name ?? "")).font(.subheadline)}}.padding(.bottom,10)}
                            
                            //NETWORK SEGMENTS
                            Text("Network Segments: ").font(.headline)
                            if osxConfig?.os_x_configuration_profile?.scope?.limitations?.network_segments?.count == 0 {
                                Text("Not Limited to Network Segments").font(.subheadline).padding(.bottom,10)
                            } else {
                                VStack(alignment:.leading){
                                    ForEach(osxConfig?.os_x_configuration_profile?.scope?.limitations?.network_segments ?? []) {segment in
                                        Text(String(segment.name ?? "")).font(.subheadline)}}.padding(.bottom,10)}
                            
                            
                            //IBEACONS
                            Text("iBeacons: ").font(.headline)
                            if osxConfig?.os_x_configuration_profile?.scope?.limitations?.ibeacons?.count == 0 {
                                Text("Not Limited iBeacons").font(.subheadline).padding(.bottom,10)
                            } else {
                                VStack(alignment:.leading){
                                    ForEach(osxConfig?.os_x_configuration_profile?.scope?.limitations?.ibeacons ?? []) {beacon in
                                        Text(String(beacon.name ?? "")).font(.subheadline)}}.padding(.bottom,10)}
                            
                        } .padding(.all, 10).background(Color(.gray).opacity(0.75)).cornerRadius(10)
                    }.padding(.bottom, 10)
                    
                    //MARK: - SCOPE EXCLUSIONS
                    Group{
                        VStack(alignment:.leading){
                            Text("Scope Exclusions").font(.title).bold().underline().padding(.bottom,10)
                            
                            VStack(alignment:.leading){
                                Text("Computers: ").font(.headline)
                                if osxConfig?.os_x_configuration_profile?.scope?.exclusions?.computers?.count == 0 {
                                    Text("No Computers Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(osxConfig?.os_x_configuration_profile?.scope?.exclusions?.computers ?? []) {computer in
                                        Text(String(computer.name ?? "")).font(.subheadline) }.padding(.bottom,10)
                                }
                                
                                Text("Device Groups: ").font(.headline)
                                if osxConfig?.os_x_configuration_profile?.scope?.exclusions?.computerGroups?.count == 0 {
                                    Text("No Device Groups Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(osxConfig?.os_x_configuration_profile?.scope?.exclusions?.computerGroups ?? []) {group in
                                        Text(group.name ?? "No Device Groups Excluded").font(.subheadline)}.padding(.bottom,10)
                                }
                                
                                Text("Buildings: ").font(.headline)
                                if osxConfig?.os_x_configuration_profile?.scope?.exclusions?.buildings?.count == 0 {
                                    Text("No Buildings Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(osxConfig?.os_x_configuration_profile?.scope?.exclusions?.buildings ?? []) {building in
                                        Text(building.name ?? "No Buildings Excluded")}.padding(.bottom,10)
                                }
                                
                                Text("Departments: ").font(.headline)
                                if osxConfig?.os_x_configuration_profile?.scope?.exclusions?.departments?.count == 0 {
                                    Text("No Departments Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(osxConfig?.os_x_configuration_profile?.scope?.exclusions?.departments ?? []) {departments in
                                        Text(departments.name ?? "No Departments Excluded")}.padding(.bottom,10)
                                }
                                
                                Text("Users: ").font(.headline)
                                if osxConfig?.os_x_configuration_profile?.scope?.exclusions?.jss_users?.count == 0 {
                                    Text("No Users Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(osxConfig?.os_x_configuration_profile?.scope?.exclusions?.users ?? []) {users in
                                        Text(users.name ?? "No Users Excluded")}.padding(.bottom,10)
                                    
                                }
                            }
                            
                            Group {
                                VStack(alignment:.leading){
                                    Text("Network Segments: ").font(.headline)
                                    if osxConfig?.os_x_configuration_profile?.scope?.exclusions?.networkSegments?.count == 0 {
                                        Text("Network Segments Excluded").font(.subheadline).padding(.bottom,10)
                                    } else {
                                        ForEach(osxConfig?.os_x_configuration_profile?.scope?.exclusions?.networkSegments ?? []) {segments in
                                            Text(segments.name ?? "Network Segments Excluded")}.padding(.bottom,10)
                                    }
                                    
                                }.padding(.bottom,10)
                            }
                        }.padding(.all, 10).background(Color(.gray).opacity(0.5)).cornerRadius(10)
                        
                    }.padding(.bottom, 10)
                    
                    Group{
                        VStack(alignment:.leading){
                            Text("Configuration Payload").font(.title).bold().underline().padding(.bottom, 10)
                            ForEach(computerConfigPayloads) { item in
                                Text("\(item.payload ?? "")").font(.body)
                            }
                        }.padding(.all, 10).background(Color(.systemPink).opacity(0.3)).cornerRadius(10)
                    }.padding(.bottom, 10)
                    Spacer()
                }.padding(.leading, 14)
                Spacer()
            } .onAppear{
                ComputerConfigAPI().configDetails(id: jamfID) { (osxConfig) in
                    self.osxConfig = osxConfig
                    self.allDevices = osxConfig.os_x_configuration_profile?.scope?.allComputers?.description ?? "false"
                    print(osxConfig)
                }
                
                
            }
            
        }.navigationBarTitle("macOS Configuration Profile").font(.title)
    }
}
