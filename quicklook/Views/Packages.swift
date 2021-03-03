//
//  Packages.swift
//  quicklook
//
//  Created by Toxicspu on 4/6/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI

var packageID:Int = Int()
var packageName:String = ""

struct Packages: View {

     @EnvironmentObject var controlCenter: ControlCenter
    @Environment(\.presentationMode) var presentationMode
     @State var packages: [Responses.Packages.Response] = []
     @State private var searchTerm:String = ""
     @State private var showingAlert = false
    
    
    func removeItems(at offsets: IndexSet){
        if searchTerm != "" {
            let filteredPackages = packages.filter {
                self.searchTerm.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchTerm)}
            let itemIndex:Int = offsets.first!
            print(filteredPackages[itemIndex].name)
            print(filteredPackages[itemIndex].jamfId )
            print("Deleting "+filteredPackages[itemIndex].name)
            PackagesAPI().deletePackage(id: filteredPackages[itemIndex].jamfId.description)
            self.packages = filteredPackages
            self.packages.remove(atOffsets: offsets)
            PackagesAPI().getPackages { (packages) in
                self.packages = packages}
        } else {
            let itemIndex:Int = offsets.first!
            print(self.packages[itemIndex].name)
            print(self.packages[itemIndex].jamfId)
            print("Deleting "+self.packages[itemIndex].name)
            PackagesAPI().deletePackage(id: String(self.packages[itemIndex].jamfId))
            self.packages.remove(atOffsets: offsets)
        }
    }
    
 
     var body: some View {
        VStack{
        SearchBar(text:$searchTerm)
        
         List {
             ForEach(packages.filter {
                 self.searchTerm.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchTerm)
             }) { package in
                if self.controlCenter.pushPackage == true {
                    
                    Button(action: {
                    self.controlCenter.pushPackage == false
                       self.showingAlert = false
                       print(package)
                       packageID = package.jamfId
                       packageName = package.name
                       self.controlCenter.packageId = package.jamfId
                       self.controlCenter.packageName = package.name
                       print(self.controlCenter.packageId ?? "")
                       print(self.controlCenter.packageName)
                    self.presentationMode.wrappedValue.dismiss()
                    })
                    {Text(package.name)}
                }
                   
                else {
                 Button(action: {
                    self.showingAlert = true
                    print(package)
                    packageID = package.jamfId
                    packageName = package.name
                    self.controlCenter.packageId = package.jamfId
                    self.controlCenter.packageName = package.name
                    print(self.controlCenter.packageId ?? "")
                    print(self.controlCenter.packageName)
                 })
                 {Text(package.name)}
                }
                }.onDelete(perform: removeItems)}
            .alert(isPresented: $showingAlert) {
                      Alert(title: Text("\(self.controlCenter.packageName) has been selected! "), message: Text("Go search for a computer to push the package to @ Main Menu > Computers.  Once you've found a computer press the Push Package button."), dismissButton: .default(Text("Got it!")))
                  }
             .onAppear {PackagesAPI().getPackages { (packages) in
                 self.packages = packages
                 }
            }
        }.navigationBarTitle("Packages")
    }
}
 
 struct Packages_Previews: PreviewProvider {
     static var previews: some View {
         Packages()
     }
 

  }

