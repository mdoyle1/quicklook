//
//  ShareView.swift
//  quicklook
//
//  Created by Toxicspu on 5/5/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI

var sharedSubject:String?
var sharedItem:String?


class Share: UIViewController, UIActivityItemSource {

    func showView(){
        let items = [self]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popOver = ac.popoverPresentationController {
            popOver.sourceView = self.view
          }
        UIApplication.shared.windows.first?.rootViewController?.present(ac, animated: true, completion: nil)
    }
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return sharedItem ?? ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return sharedItem
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return sharedSubject ?? ""
    }
    
}
