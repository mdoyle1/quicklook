//
//  Packages.swift
//  quicklook
//
//  Created by Toxicspu on 4/6/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI


struct Packages: View {

     @EnvironmentObject var controlCenter: ControlCenter
     @State var packages: [Responses.Packages.Response] = []
    @State private var searchTerm:String = ""
 
     func removeItems(at offsets: IndexSet){
         //Get the index of the item your about to delete!
         let itemIndex:Int = offsets.first!
         print(self.packages[itemIndex].name)
         print(self.packages[itemIndex].jamfId)
         print("Deleting "+self.packages[itemIndex].name)
         PackagesAPI().deletePackage(id: String(self.packages[itemIndex].jamfId))
         self.packages.remove(atOffsets: offsets)
            }
 
 
     var body: some View {
        VStack{
        SearchBar(text:$searchTerm)
        
         List {
            
             ForEach(packages.filter {
                 self.searchTerm.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchTerm)
             }) { package in
                 Button(action: {print(package)})
                 {Text(package.name)}}.onDelete(perform: removeItems)}
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

