//
//  Modifiers.swift
//  quicklook
//
//  Created by Toxicspu on 5/13/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI

struct ButtonFormat: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(Color.white)
            .padding(.all, 8)
            .background(Color.gray).cornerRadius(4.0)
           
    }
}
