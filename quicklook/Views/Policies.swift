//
//  Policies.swift
//  quicklook
//
//  Created by Toxicspu on 4/14/20.
//  Copyright © 2020 developer. All rights reserved.
//
//https://stackoverflow.com/questions/56706188/how-does-one-enable-selections-in-swiftuis-list?noredirect=1&lq=1
//https://www.ioscreator.com/tutorials/swiftui-delete-multiple-rows-list-tutorial

import Foundation
import SwiftUI

struct Policies: View {
    
    @EnvironmentObject var controlCenter: ControlCenter
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var policies: [Responses.Policies.Response] = []
    @State var policiesToDelete: [Responses.Policies.Response] = []
    @State private var secondLoader:Bool = true
    @State var selection = Set<UUID>()
    @State var editMode = EditMode.inactive
    @State private var searchTerm:String = ""
    
    
    
    //REMOVE ITEMS FUNCTION
    func removeItems(at offsets: IndexSet){
        //Get the index of the item your about to delete!
        if searchTerm != "" {
            let filteredPolicies = policies.filter {
                self.searchTerm.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchTerm)}
            let itemIndex:Int = offsets.first!
            print(filteredPolicies[itemIndex].name)
            print(filteredPolicies[itemIndex].jamfId ?? 0)
            print("Deleting "+filteredPolicies[itemIndex].name)
            PoliciesAPI().deletePolicy(id: filteredPolicies[itemIndex].jamfId?.description ?? "", completion:{})
            self.policies = filteredPolicies
            self.policies.remove(atOffsets: offsets)
            PoliciesAPI().getPolicies { (policies) in
                self.policies = policies}
        } else {
            let itemIndex:Int = offsets.first!
            print(self.policies[itemIndex].name)
            print(self.policies[itemIndex].jamfId ?? 0)
            print("Deleting "+self.policies[itemIndex].name)
            PoliciesAPI().deletePolicy(id: self.policies[itemIndex].jamfId?.description ?? "", completion:{})
            self.policies.remove(atOffsets: offsets)
            
        }
    }
    
    //NAVIGATION BAR EDIT AND DELETE BUTTONS
    private var editButton: some View {
        if editMode == .inactive {return Button(action: {self.editMode = .active
            self.selection = Set<UUID>()
            print(self.selection)}) {Text("Edit")}}
        else {return Button(action: {self.editMode = .inactive
            self.selection = Set<UUID>()
            print(self.selection)}) {Text("Done")}}
    }
    
    private var deleteButton: some View {
        if editMode == .inactive {return Button(action: {})
        {Image(systemName: "")
        }.foregroundColor(.red)
            .font(.system(size: 40))
            .frame(width: 32.0, height: 32.0)
            .padding(.all, 8)}
        else {return Button(action: {
            self.policiesToDelete = self.policies
            self.deletePolicies()}) {
                Image(systemName:"trash.circle")
        }.foregroundColor(.red)
            .font(.system(size: 30))
            .frame(width: 40.0, height: 40.0)
            .padding(.all, 8)
        }
    }
    
    //DELETE MULTIPLE POLICIES
    func deletePolicies() {
        let semaphore = DispatchSemaphore(value: 1)
        print(self.selection)
        self.selection.forEach { id in
            if let index = self.policiesToDelete.lastIndex(where: { $0.id == id })  {
                DispatchQueue.global().async {
                    self.policies.remove(at: index)
                    semaphore.wait()
                    PoliciesAPI().deletePolicy(id: String("\(self.controlCenter.policyId)"), completion: {
                        print(self.policiesToDelete[index].id)
                        print("Deleting: \(self.controlCenter.policyName)")
                        print("ID: \(self.controlCenter.policyId)")
                        print("")})
                    semaphore.signal()
                }
            }
            self.selection = Set<UUID>()
        }
    }
    
    
    
    var body: some View {
        VStack{
            SearchBar(text:$searchTerm)
            
            List(selection:$selection) {
                ForEach(policies.filter {
                    self.searchTerm.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchTerm)})
                {policy in
                    NavigationLink(destination: PolicyView(policyID: policy.jamfId ?? 0).onAppear{
                        self.controlCenter.policyId = policy.jamfId
                        self.controlCenter.policyName = policy.name
                        })
                    {Button(action: {})
                    {Text(policy.name)}}
                    
                }.onDelete(perform: removeItems)
                
            }.onAppear {if self.secondLoader { PoliciesAPI().getPolicies { (policies) in
                self.policies = policies
                self.secondLoader = false}
                }
            }
        }.navigationBarTitle("Policies")
//            .navigationBarItems(trailing:
//                HStack {
//                  //  deleteButton
//                    editButton
//                }).environment(\.editMode, self.$editMode)
        
    }
}


//INDIVIDUAL POLICY VIEW
struct PolicyView: View {
    @EnvironmentObject var controlCenter: ControlCenter
    @State var policy: Responses.PolicyCodable?
    @State var enabled:Bool?
    @State var policySwitch:String?
    @State var allComputers:String?
    @State var serching:String = "searching..."
    @State var enableDissableColor:Color?
    var policyID:Int
    
    
    var body: some View{
        ScrollView {
            HStack{
                VStack(alignment: .leading, spacing: 8){
                    Group{
                        //POLICY NAME
                        Text(policy?.policy.general?.name ?? "searching...").font(.largeTitle)
                        
                        //ENABLED?
                        HStack{
                            if self.enabled == true {
                                HStack{
                                    VStack(alignment:.leading){
                                        Text("Policy Status: ").font(.headline)
                                        Text("Enabled!").font(.footnote).italic()
                                    }
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 30, height: 30)
                                    
                                }
                            }else if self.enabled == false {
                                HStack{
                                    VStack(alignment:.leading){
                                        Text("Policy Status: ").font(.headline)
                                        Text("Disabled!").font(.footnote).italic()
                                    }
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 30, height: 30)
                                }
                            } else { Text("searching...") }
                        }.padding(.bottom, 10)
                        
                        
                        //ENABLE / DISSABLE BUTTON
                        Group{
                            Button(action: {
                                PoliciesAPI().updatePolicy(policyToggle: self.policy?.policy.general?.enabled ?? false, deviceId: self.policy?.policy.general?.jamfId?.description ?? "")
                                //print(self.enabled)
                                if self.enabled == false {
                                    self.enabled = true
                                    self.policySwitch = "Disable"
                                    self.enableDissableColor = Color(.red)
                                }
                                else {
                                    self.enabled = false
                                    self.policySwitch = "Enable"
                                    self.enableDissableColor = Color(.systemGreen)
                                }}) {Text(self.policySwitch?.description ?? "")
                                    .font(.headline).foregroundColor(Color.white).bold()
                                    .padding(.all, 10).background(self.enableDissableColor).cornerRadius(360.0)}.padding(.bottom, 10)
                            
                        }
                        
                        //EXECUTION FREQUENCY
                        VStack(alignment:.leading){
                            Text("Execution Frequency: ").font(.headline)
                            Text("\(policy?.policy.general?.frequency ?? "searching....")").font(.subheadline)
                        }.padding(.bottom, 10)
                        
                        //POLICY ID
                        VStack(alignment:.leading){
                            Text("Policy ID:").font(.headline)
                            Text("\(policy?.policy.general?.jamfId?.description ?? "searching....")").font(.subheadline)
                        }.padding(.bottom, 10)
                        
                        //CUSTOM TRIGGER
                        VStack(alignment:.leading){
                            Text("Custom Trigger:").font(.headline)
                            if policy?.policy.general?.triggerOther == "" {
                                Text("No Custom Trigger Applied").font(.subheadline)
                            }else {
                                Text("\(policy?.policy.general?.triggerOther ?? "searching....")").font(.subheadline)
                            }
                        }.padding(.bottom, 10).font(.subheadline)
                        
                    }
                    
                    //MARK: - SCOPE
                    //COMPUTERS IN SCOPE
                    Group{
                        
                        VStack(alignment:.leading){
                            VStack(alignment:.leading){
                                
                                
                                //POLICY SCOPE
                                Text("Scope").font(.title).bold().underline().padding(.bottom, 10)
                                
                                Text("All Computers: ").font(.headline)
                                Text(policy?.policy.scope?.allComputers?.description ?? "searching...").font(.subheadline).padding(.bottom,10)}
                            
                            
                            //IF ALL COMPUTERS = TRUE  NO NEED TO SHOW BASIC SCOPE
                            if self.allComputers != "true" {
                                Text("Computers:").bold().font(.headline)
                                
                                VStack(alignment:.leading){
                                    if policy?.policy.scope?.computers?.count == 0 {
                                        Text("No Computers").font(.subheadline).padding(.bottom,10)
                                    } else {
                                        ForEach(policy?.policy.scope?.computers ?? []) { computer in
                                            Text(String(computer.name ?? ""))}}
                                    
                                    
                                }.padding(.bottom,10)
                                
                                
                                //MARK: - BASIC SCOPE
                                
                                Text("Computer Groups: ").font(.headline)
                                
                                VStack(alignment:.leading){
                                    if policy?.policy.scope?.computerGroups?.count == 0 {
                                        Text("Not Scoped to a Group").font(.subheadline)
                                    } else {
                                        ForEach(policy?.policy.scope?.computerGroups ?? []) {group in
                                            Text(String(group.name ?? "")).font(.subheadline)}}
                                }.padding(.bottom,10)
                                
                                //BUILDINGS IN SCOPE
                                
                                Text("Buildings: ").font(.headline)
                                
                                VStack(alignment:.leading){
                                    if policy?.policy.scope?.buildings?.count == 0 {
                                        Text("Not Scoped to any Buildings").font(.subheadline)
                                    } else {
                                        ForEach(policy?.policy.scope?.buildings ?? []) {building in
                                            Text(String(building.name ?? "")).font(.subheadline)}}
                                }.padding(.bottom,10)
                                
                                //DEPARTMENTS IN SCOPE
                                
                                Text("Departments: ").font(.headline)
                                
                                VStack(alignment:.leading){
                                    if policy?.policy.scope?.departments?.count == 0 {
                                        Text("Not Scoped to any Departments").font(.subheadline)
                                    } else {
                                        ForEach(policy?.policy.scope?.departments ?? []) {department in
                                            Text(String(department.name ?? "")).font(.subheadline)}}
                                }.padding(.bottom,10)}
                        }.padding(.all, 10).background(Color(.gray).opacity(1)).cornerRadius(10)
                        
                    }
                    
                    //MARK: - SCOPE LIMITATIONS
                    Group{
                        //USERS
                        VStack(alignment:.leading){
                            Text("Scope Limitations").font(.title).bold().underline().padding(.bottom,10)
                            
                            Text("Users: ").font(.headline)
                            if policy?.policy.scope?.limitations?.users?.count == 0 {
                                Text("Not Limited to any Users").font(.subheadline).padding(.bottom,10)} else {
                                VStack(alignment:.leading){
                                    ForEach(policy?.policy.scope?.limitations?.users ?? []) {user in
                                        Text(String(user.name ?? "")).font(.subheadline)}
                                }.padding(.bottom,10)
                            }
                            
                            
                            //USER GROUPS
                            Text("User Groups: ").font(.headline)
                            if policy?.policy.scope?.limitations?.userGroups?.count == 0 {
                                Text("Not Limited to any User Groups").font(.subheadline).padding(.bottom,10)
                            } else {
                                VStack(alignment:.leading){
                                    ForEach(policy?.policy.scope?.limitations?.userGroups ?? []) {userGroup in
                                        Text(String(userGroup.name ?? "")).font(.subheadline)}}.padding(.bottom,10)}
                            
                            //NETWORK SEGMENTS
                            Text("Network Segments: ").font(.headline)
                            if policy?.policy.scope?.limitations?.network_segments?.count == 0 {
                                Text("Not Limited to Network Segments").font(.subheadline).padding(.bottom,10)
                            } else {
                                VStack(alignment:.leading){
                                    ForEach(policy?.policy.scope?.limitations?.network_segments ?? []) {segment in
                                        Text(String(segment.name ?? "")).font(.subheadline)}}.padding(.bottom,10)}
                            
                            
                            //IBEACONS
                            Text("iBeacons: ").font(.headline)
                            if policy?.policy.scope?.limitations?.ibeacons?.count == 0 {
                                Text("Not Limited iBeacons:").font(.subheadline).padding(.bottom,10)
                            } else {
                                VStack(alignment:.leading){
                                    ForEach(policy?.policy.scope?.limitations?.ibeacons ?? []) {beacon in
                                        Text(String(beacon.name ?? "")).font(.subheadline)}}.padding(.bottom,10)}
                            
                        } .padding(.all, 10).background(Color(.gray).opacity(0.75)).cornerRadius(10)
                    }
                    
                    
                    
                    //MARK: - SCOPE EXCLUSIONS
                    Group{
                        VStack(alignment:.leading){
                            Text("Scope Exclusions").font(.title).bold().underline().padding(.bottom,10)
                            
                            VStack(alignment:.leading){
                                Text("Computers: ").font(.headline)
                                if policy?.policy.scope?.exclusions?.computers?.count == 0 {
                                    Text("No Computers Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(policy?.policy.scope?.exclusions?.computers ?? []) {computer in
                                        Text(String(computer.name ?? "")).font(.subheadline) }.padding(.bottom,10)
                                }
                                
                                Text("Computer Groups: ").font(.headline)
                                if policy?.policy.scope?.exclusions?.computerGroups?.count == 0 {
                                    Text("No Computer Groups Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(policy?.policy.scope?.exclusions?.computerGroups ?? []) {group in
                                        Text(group.name ?? "No Computer Groups Excluded")}.padding(.bottom,10)
                                }
                                
                                Text("Buildings: ").font(.headline)
                                if policy?.policy.scope?.exclusions?.buildings?.count == 0 {
                                    Text("No Buildings Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(policy?.policy.scope?.exclusions?.buildings ?? []) {building in
                                        Text(building.name ?? "No Buildings Excluded")}.padding(.bottom,10)
                                }
                                
                                Text("Departments: ").font(.headline)
                                if policy?.policy.scope?.exclusions?.departments?.count == 0 {
                                    Text("No Departments Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(policy?.policy.scope?.exclusions?.departments ?? []) {departments in
                                        Text(departments.name ?? "No Departments Excluded")}.padding(.bottom,10)
                                }
                                
                                Text("Users: ").font(.headline)
                                if policy?.policy.scope?.exclusions?.users?.count == 0 {
                                    Text("No Users Excluded").font(.subheadline).padding(.bottom,10)
                                } else {
                                    ForEach(policy?.policy.scope?.exclusions?.users ?? []) {users in
                                        Text(users.name ?? "No Users Excluded")}.padding(.bottom,10)
                                }
                            }
                            
                            Group {
                                VStack(alignment:.leading){
                                    Text("Network Segments: ").font(.headline)
                                    if policy?.policy.scope?.exclusions?.networkSegments?.count == 0 {
                                        Text("Network Segments Excluded").font(.subheadline).padding(.bottom,10)
                                    } else {
                                        ForEach(policy?.policy.scope?.exclusions?.networkSegments ?? []) {segments in
                                            Text(segments.name ?? "Network Segments Excluded")}.padding(.bottom,10)
                                    }
                                }
                            }.padding(.bottom,10)
                        }.padding(.all, 10).background(Color(.gray).opacity(0.5)).cornerRadius(10)
                    }
                    
                    
                    
                    //MARK: -  PRINTERS
                    Group{
                        VStack(alignment:.leading){
                            Text("Printers: ").font(.headline)
                            if printerArray.count == 0 {Text("No Printers Added").font(.subheadline)}
                            else{  ForEach(printerArray) { printer in
                                Text(printer.name ?? "No Printers Added").font(.subheadline)}
                            }
                        }.padding(.all, 10).background(Color(.systemPink).opacity(0.5)).cornerRadius(10)
                    }
                    
                    //MARK: - SCRIPTS
                    Group{
                        VStack(alignment:.leading){
                            Text("Scripts:").bold().font(.headline)
                            if controlCenter.policy?.policy.scripts?.count == 0 {
                                Text("No Scripts Applied").font(.subheadline)
                            } else {
                                ForEach(controlCenter.policy?.policy.scripts ?? []) {script in
                                    Text(String(script.name ?? "")).font(.subheadline)}}
                        }.padding(.all,10).background(Color(.systemGreen).opacity(0.5)).cornerRadius(10)
                    }
                    
                    
                    //MARK: - PACKAGES APPLIED
                    Group {
                        VStack(alignment:.leading){
                            Text("Packages:").bold().font(.headline)
                            if controlCenter.policy?.policy.package_configuration?.packages.count == 0 {
                                Text("No Packages Applied").font(.subheadline)
                            } else {
                                ForEach(controlCenter.policy?.policy.package_configuration?.packages ?? []) { package in
                                    Text(String(package.name ?? ""))
                                }
                            }
                        }.padding(.all,10).background(Color(.systemBlue).opacity(0.5)).cornerRadius(10)
                    }
                    
                    
                    //RUN COMMAND
                    Group {
                        VStack(alignment:.leading){
                            Text("Run Command:").bold().font(.headline)
                            if controlCenter.policy?.policy.files_processes?.run_command  == "" {
                                Text("No Commands Run").font(.subheadline)
                            }else {
                                Text(controlCenter.policy?.policy.files_processes?.run_command ?? "No Commands Run").font(.subheadline)
                            }
                        }.padding(.all,10).background(Color(.systemYellow).opacity(0.5)).cornerRadius(10)
                    }
                    
                    
                    Spacer()
                    
                    
                }.padding(.leading, 14)
                Spacer() }
                .onAppear{
                    PoliciesAPI().policyDetails (id: policyID ) { (policy) in
                        self.policy = policy
                        self.controlCenter.policy = policy
                        self.enabled = policy.policy.general?.enabled
                        self.allComputers = policy.policy.scope?.allComputers?.description
                        if self.enabled == false {
                            self.policySwitch = "Enable"
                            self.enableDissableColor = Color(.green)
                        } else { self.policySwitch = "Disable"
                            self.enableDissableColor = Color(.red)
                        }
                        print(policy)
                    }
                    
            }.navigationBarTitle("Policies")
        }
    }
    
    
    
}




