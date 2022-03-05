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
    @StateObject var languageEngine = LanguageEngine(load: true)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageEngine)
                .environment(\.colorScheme, .dark)
                
            //                TabsStackContainer(tabs: tabs)
            //                GeneralVerbCubeView(VerbCubeConjugatedStringHandler(languageEngine: languageEngine, d1: .Tense, d2: .Person))
            Spacer()
            
        }
    }
}
