//
//  SearchBar.swift
//  quicklook
//
//  Created by Toxicspu on 5/11/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import SwiftUI
//https://stackoverflow.com/questions/56490963/how-to-display-a-search-bar-with-swiftui

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        
        init(text: Binding<String>) {
            _text = text
            
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            text = searchText
            
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            searchBar.resignFirstResponder()
            
        }
        
        
    }
    
    
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
        
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar()
        
        searchBar.returnKeyType = .search
        searchBar.delegate = context.coordinator
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
        
    }
    
    
}

