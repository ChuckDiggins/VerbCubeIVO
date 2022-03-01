//
//  VerbCubeIVOApp.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI
import Dot

@main
struct VerbCubeIVOApp: App {
    @StateObject private var tabs = Tabs(count: 3)
    
    
    var body: some Scene {
        WindowGroup {
            let languageEngine = LanguageEngine()
            
            
            ContentView()
                .environmentObject(languageEngine)
                .environment(\.colorScheme, .dark)
                
            //                TabsStackContainer(tabs: tabs)
            //                GeneralVerbCubeView(VerbCubeConjugatedStringHandler(languageEngine: languageEngine, d1: .Tense, d2: .Person))
            Spacer()
            
        }
    }
}
