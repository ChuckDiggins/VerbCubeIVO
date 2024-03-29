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
//    @StateObject var languageViewModel = LanguageViewModel(language: .Spanish)
    @StateObject var languageViewModel = LanguageViewModel()
    @StateObject var vmecdm = VerbModelEntityCoreDataManager()
    @StateObject var router = Router()
    @AppStorage("Language") var languageString = "Spanish"
    @AppStorage("VerbOrModelMode") var verbOrModelMode = "Verbs"
    @AppStorage("V2MChapter") var currentV2mChapter = "Chapter 3A"
    @AppStorage("V2MLesson") var currentV2mLesson = "AR, ER IR verbs"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "encontrar"
    @AppStorage("currentPage") var currentPage = 1
    @AppStorage("Explanation Page") var explanationPage = 7
    
//    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            if currentPage < totalPages{
                WalkthroughScreen()
            } else if explanationPage < totalExplanationPages{
                ExplanationScreen1()
            }
            else {
                NavigationStack{
                    //                TabBarClassicVC(languageViewModel: languageViewModel)
                    NavStackCarouselDispatcherView(languageViewModel: languageViewModel)
                    //                NavigationStackView(languageViewModel: languageViewModel)
                    //                CircleView(languageViewModel: languageViewModel)
                    //                CircleButtonView(languageViewModel: languageViewModel, selectedNewVerbModelType: NewVerbModelType.Regular)
                    
                    Spacer()
                }.environmentObject(languageViewModel)
                    .environmentObject(vmecdm)
                    .environmentObject(router)
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
