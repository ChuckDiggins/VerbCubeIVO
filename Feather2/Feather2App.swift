//
//  VerbCubeIVOApp.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI
import JumpLinguaHelpers
import RealmSwift

class AppState: ObservableObject{
    @Published var hasOnboarded: Bool
    
    init(hasOnboarded: Bool){
        self.hasOnboarded = hasOnboarded
    }
}

//let app: RealmSwift.App? = nil

@main
struct Feather2App: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject var appState = AppState(hasOnboarded: false)
    @StateObject var languageViewModel = LanguageViewModel(language: .Spanish)
    @StateObject var vmecdm = VerbModelEntityCoreDataManager()
   
//    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack{
//                    Text("Feather2App: vmecdm count: \(vmecdm.vm.getVerbModelEntityCount())")
                    TabBarClassicVC(languageViewModel: languageViewModel)
                        
                        .onAppear{
                            languageViewModel.setVerbModelEntityCoreDataManager(vmecdm: vmecdm)
                        }
                    Spacer()
                }.navigationViewStyle(StackNavigationViewStyle())
                    .environmentObject(languageViewModel)
                    .environmentObject(vmecdm)
                    
                    
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
