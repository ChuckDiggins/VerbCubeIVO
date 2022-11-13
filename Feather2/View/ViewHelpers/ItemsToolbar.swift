//
//  ItemsToolbar.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/19/22.
//

import SwiftUI

struct ItemsToolbar: ToolbarContent{
    @ObservedObject var languageViewModel: LanguageViewModel
    
    var body: some ToolbarContent {
        
        ToolbarItemGroup(placement: .navigationBarTrailing) {
//            NavigationLink(destination: Flashcard(
//                front: { Text("Hello")},
//                back: { Text("Goodbye")}))
//            {
//            Label("Flashcard", systemImage: "bolt")
//            }
            
            NavigationLink(destination: FindMyVerbDispatcher(languageViewModel: languageViewModel ))
            {
            Label("Find", systemImage: "magnifyingglass")
            }
            NavigationLink(destination: PreferencesView(languageViewModel: languageViewModel ))
            {
            Label("Settings", systemImage: "gear")
            }
            
        }
    }
}

