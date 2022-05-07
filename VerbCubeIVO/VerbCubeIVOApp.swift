//
//  VerbCubeIVOApp.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI
import Dot
import JumpLinguaHelpers

class AppState: ObservableObject{
    @Published var hasOnboarded: Bool
    
    init(hasOnboarded: Bool){
        self.hasOnboarded = hasOnboarded
    }
}

@main
struct VerbCubeIVOApp: App {
    @ObservedObject var appState = AppState(hasOnboarded: false)
    @StateObject private var tabs = Tabs(count: 3)
    @StateObject var languageViewModel = LanguageViewModel(language: .Spanish)
    
    var body: some Scene {
        WindowGroup {
            
            NavigationView {
                TabBarClassic(languageViewModel: languageViewModel)
//                if appState.hasOnboarded {
//                    CircleButtonNavigationView()
//                        .environmentObject(languageViewModel)
//                        .environmentObject(appState)
//                        .onAppear{
//                            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
//                            UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
//                        }
//                } else {
//                    OnboardingFlowView()
//                        .environmentObject(languageViewModel)
//                        .environmentObject(appState)
//
//                }
                
                Spacer()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
