//
//  VerbCubeIVOApp.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI
import Dot
import JumpLinguaHelpers

@main
struct VerbCubeIVOApp: App {
    @StateObject private var tabs = Tabs(count: 3)
//    @StateObject var languageEngine = LanguageEngine(language: .Spanish)
    @StateObject var languageViewModel = LanguageViewModel(language: .Spanish)
    
    var body: some Scene {
        WindowGroup {
            CircleButtonNavigationView()
                .environmentObject(languageViewModel)
                .onAppear{
                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }

            Spacer()
            
        }
    }
}
