//
//  Scripts.swift
//  quicklook
//
//  Created by Toxicspu on 4/6/20.
//  Copyright © 2020 developer. All rights reserved.
//https://www.youtube.com/watch?v=IHx53KJnL-o

import Foundation
import SwiftUI


struct Scripts: View {
    @EnvironmentObject var controlCenter: ControlCenter
    @State var scripts: [Responses.Scripts.Results] = []
    @State private var firstLoader:Bool = true
    @State private var searchTerm:String = ""
    
    
    func removeItems(at offsets: IndexSet){
        //Get the index of the item your about to delete!
        let itemIndex:Int = offsets.first!
        print(self.scripts[itemIndex].name)
        print(self.scripts[itemIndex].jamfId)
        print("Deleting "+self.scripts[itemIndex].name)
        ScriptsAPI().deleteScript(id: String(self.scripts[itemIndex].jamfId))
        self.scripts.remove(atOffsets: offsets)
    }
    
    
    var body: some View {
        
        VStack{
            SearchBar(text:$searchTerm)
            List{
                
                ForEach(scripts.filter {
                    self.searchTerm.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchTerm)
                }) { script in
                    NavigationLink(destination: DownloadScripts().onAppear{
                        
                        self.controlCenter.scriptId = String(script.jamfId)
                        self.controlCenter.scriptName = script.name
                        self.controlCenter.downloadScript(id: String(script.jamfId))})
                    {Text(script.name)}
                    
                }.onDelete(perform: removeItems)
                
            }
                
            .onAppear {if self.firstLoader { ScriptsAPI().getScripts { (scripts) in
                self.scripts = scripts
                self.firstLoader = false
                }
                }
            }
        }
        .navigationBarTitle("Scripts")
    }
    
    
    struct DownloadScripts: View {
        @EnvironmentObject var controlCenter: ControlCenter
        
        func initShareData(){
            sharedSubject = self.controlCenter.scriptName
            sharedItem = self.controlCenter.scriptContents
        }
        
        var body: some View{
            ScrollView{
                VStack(alignment:.leading){
                    
                    
                    Text(self.controlCenter.scriptContents).padding(.all, 10)}
                HStack{
                    Spacer()
                }
                
                Button(action: {self.initShareData()
                    Share().showView()}){Image(systemName:"square.and.arrow.up").font(.largeTitle)
                        .padding(.all, 10)
                }
                
                
            }
            .navigationBarTitle(self.controlCenter.scriptName)
        }
    }
}
