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
    @EnvironmentObject var controlCenter: ControlCenter
    
    var body: some View {
        VStack{
            HStack{
                TextField("Search for device...", text: $searchText)
                    .padding(.all, 8)
                    .background(Color(red:0.5, green: 0.5, blue: 0.5, opacity: 0.3))
                    .cornerRadius(4.0)
                Button(action: {
                    self.instructions = false
                    MatchAPI().getDevice(search: "*\(self.searchText)*".replacingOccurrences(of: " ", with: "")) { (devices) in
                        self.devices = devices}
                }){Text("Search").font(.headline).foregroundColor(Color.white).bold()
                    .padding(.all, 8)
                    .background(Color.gray).opacity(0.5).cornerRadius(4.0)}
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
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
                                    .background(Color.gray).opacity(0.5).cornerRadius(4.0)
                                    .padding(.bottom, 8)}
                        }
                    }
                }
            }
            Spacer()
        }.padding(EdgeInsets(top:1, leading: 20, bottom: 0, trailing: 20))
            .navigationBarTitle("Device Search")
        
    }
}

