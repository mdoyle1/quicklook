//
//  Computer.swift
//  quicklook
//
//  Created by Toxicspu on 4/8/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI

struct ComputerMatch: View {
    @State var searchText:String = ""
    @State var computers: [Responses.Computers.Response] = []
    @ObservedObject var viewModel = Defaults()
    @State private var isShowingScanner = false
    @State var instructions = true
    @EnvironmentObject var controlCenter: ControlCenter
    let pasteboard = UIPasteboard.general
    
    //MARK: - HANDLE BARCODE SCAN
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success (let code):
            let details = code.components(separatedBy: "\n")
            print(details[0].description)
            self.searchText = details[0]
            self.instructions = false
            MatchAPI().getComputer(defaults: self.viewModel, search: "*\(self.searchText)*".replacingOccurrences(of: " ", with: "")) { (computers) in
                self.computers = computers
            }
            
        case .failure(let error):
            print("scanning failed")
            print(error)
            
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                TextField("Search for computer...", text: $searchText)
                    .padding(.all, 8)
                    .background(Color.gray.opacity(0.5))
                    //.opacity(0.5)
                
                    .cornerRadius(5.0)
                    .foregroundColor(.primary)
                    .contextMenu {
                        //MARK: - BARCODE SCAN
                        Button(action:
                            {self.isShowingScanner.toggle()}){Text("Barcode Scanner")
                            Image(systemName: "barcode")}
                }
                Button(action: {
                    self.instructions = false
                    MatchAPI().getComputer(defaults: self.viewModel, search: "*\(self.searchText)*".replacingOccurrences(of: " ", with: "")) { (computers) in
                        self.computers = computers
                    }
                    
                }){Text("Search").modifier(ButtonFormat())}
                
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
            if instructions {
                Text("Name, mac address, etc. to filter by. Match uses the same format as the general search in Jamf Pro.").font(.footnote)}
            List {
                ForEach (computers){ computer in
                    
                    VStack(alignment: .leading){
                        NavigationLink(destination: Computer(computerID: String(computer.jamfId)).onAppear{
                            self.controlCenter.computerId = String(computer.jamfId)
                            self.controlCenter.computerName = String(computer.name ?? "")
                        }){
                            Button(action: {print(computer.jamfId)
                            }){
                                Text("\(computer.name ?? "")\nSerial:\(computer.serial_number)\nAsset Tag:\(computer.asset_tag ?? "Not Available")\nUsername: \(computer.username ?? "")")
                                    .font(.headline).foregroundColor(Color.white).bold()
                                    .padding(.all, 8)
                                    .background(Color.gray).cornerRadius(4.0)
                                    .padding(.bottom, 8)}
                        }
                    }
                }
            }
            Spacer()
        }.padding(EdgeInsets(top:1, leading: 20, bottom: 0, trailing: 20))
            .navigationBarTitle("Computer Search")
            //MARK: - BARCODE SCANNER
            .sheet(isPresented: self.$isShowingScanner) {
                CodeScannerView(codeTypes: [.ean8, .ean13, .pdf417, .upce, .code39, .code128], simulatedData: "Test",completion: self.handleScan)}
    }
    
}



