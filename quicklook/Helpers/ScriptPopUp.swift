//
//  ScriptPopUp.swift
//  quicklook
//
//  Created by Toxicspu on 4/3/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI

struct ScriptPopUp: View {
    @Binding var showText: Bool
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.blue)
            .frame(width: 80, height: 180)
            Circle()
                .foregroundColor(.red)
            .frame(width: 50)
            Rectangle()
                .foregroundColor(.green)
            .frame(width: 150, height: 110)
        }
    }
}
