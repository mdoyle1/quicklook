//
//  DeviceMatch.swift
//  quicklook
//
//  Created by Toxicspu on 5/4/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI

struct DeviceMatch: View {
    @State var searchText:String = ""
    @State var devices: [Responses.MobileDeviceMatch.MobileDevices] = []
    @State var instructions = true
    @State private var isShowingScanner = false
    @EnvironmentObject var controlCenter: ControlCenter
    
    //MARK: - HANDLE BARCODE SCAN
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success (let code):
            let details = code.components(separatedBy: "\n")
            print(details[0].description)
            self.searchText = details[0]
            self.instructions = false
            MatchAPI().getDevice(search: "*\(self.searchText)*".replacingOccurrences(of: " ", with: "")) { (devices) in
                                  self.devices = devices}
            
        case .failure(let error):
            print("scanning failed")
            print(error)
            
        }
    }

    
    var body: some View {
        VStack{
            HStack{
                TextField("Search for device...", text: $searchText)
                    .padding(.all, 8)
                    .background(Color.gray.opacity(0.5))
                    .foregroundColor(.primary)
                    .cornerRadius(5.0)
                    .contextMenu {
                        //MARK: - BARCODE SCAN
                        Button(action:{self.isShowingScanner.toggle()}){Text("Barcode Scanner")
                            Image(systemName: "barcode")}}
                
                Button(action: {
                    self.instructions = false
                    MatchAPI().getDevice(search: "*\(self.searchText)*".replacingOccurrences(of: " ", with: "")) { (devices) in
                        self.devices = devices}
                }){Text("Search").modifier(ButtonFormat())}
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
            if instructions {
                Text("Name, mac address, etc. to filter by. Match uses the same format as the general search in Jamf Pro.").font(.footnote)}
            List {
                ForEach (devices){ mobileDevice in
                    
                    VStack(alignment: .leading){
                        NavigationLink(destination: Device().onAppear{
                            self.controlCenter.deviceId = String("\(mobileDevice.jamfId)")
                            self.controlCenter.deviceName = String("\(mobileDevice.name ?? "")")
                        }){
                            Button(action: {
                            }){
                                Text("\(mobileDevice.name ?? "")\n\(mobileDevice.serialNumber ?? "")\nMAC: \(mobileDevice.wifiMACAddress ?? "Not Available")\nUsername: \(mobileDevice.username ?? "")\nAsset Tag: \(mobileDevice.assetTag ?? "N/A")")
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
            .navigationBarTitle("Device Search")
        //MARK: - BARCODE SCANNER
            .sheet(isPresented: self.$isShowingScanner) {
                CodeScannerView(codeTypes: [.ean8, .ean13, .pdf417, .upce, .code39], simulatedData: "Test",completion: self.handleScan)}
    }
}

