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
    @AppStorage("VerbOrModelMode") var verbOrModelMode = "NA"
    @AppStorage("V2MChapter") var currentV2mChapter = "nada 2"
    @AppStorage("V2MLesson") var currentV2mLesson = "nada 3"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "nada 4"
    @AppStorage("currentPage") var currentPage = 1
    @AppStorage("Explanation Page") var explanationPage = 7
    
//    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            if currentPage < totalPages{
                WalkthroughScreen()
            } else if explanationPage < totalExplanationPages{
                ExplanationScreen()
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
