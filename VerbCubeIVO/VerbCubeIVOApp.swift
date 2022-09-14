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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject var appState = AppState(hasOnboarded: false)
    @StateObject private var tabs = Tabs(count: 3)
    @StateObject var languageViewModel = LanguageViewModel(language: .Spanish)
    
    var body: some Scene {
        WindowGroup {
            
            NavigationView {
                VStack{
//                    ScrollViewVC(languageViewModel: languageViewModel)
                    TabBarClassicVC(languageViewModel: languageViewModel)
                    Spacer()
                }.navigationViewStyle(StackNavigationViewStyle())
                
            }
            
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all //by default, all views rotate freely
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
