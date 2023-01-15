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
    @StateObject var router = Router()
   
//    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                TabBarClassicVC(languageViewModel: languageViewModel)
//                NavigationStackView(languageViewModel: languageViewModel)
//                CircleView(languageViewModel: languageViewModel)
//                CircleButtonView(languageViewModel: languageViewModel, selectedNewVerbModelType: NewVerbModelType.Regular)
                    .onAppear{
                        languageViewModel.setVerbModelEntityCoreDataManager(vmecdm: vmecdm)
                    }
                Spacer()
            }.environmentObject(languageViewModel)
                .environmentObject(vmecdm)
                .environmentObject(router)
        }
    }
  
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all //by default, all views rotate freely
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
