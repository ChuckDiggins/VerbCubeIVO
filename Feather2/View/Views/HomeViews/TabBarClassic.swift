//
//  TabBarClassic.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/3/22.
//

import SwiftUI
import JumpLinguaHelpers

struct TabBarClassicVC: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var vmecdm: VerbModelEntityCoreDataManager
    @EnvironmentObject var router: Router
    
    @State var selectedTab: Int = 0
    @State var currentLanguage = LanguageType.Spanish
    @State var selectedCount = 0
    @State var selectedModelString = ""
    @State var showTest = false
    
    var body: some  View{
        if languageViewModel.getSelectedNewVerbModelType() != .undefined {
            SelectedTypeView(selectedNewVerbModelType: languageViewModel.getSelectedNewVerbModelType(), selectedModelString: $selectedModelString)
            Text("\(languageViewModel.getFilteredVerbs().count) active verbs")
        }
        else {
            Text("No verbs are currently selected").font(.title)
        }
        NavigationStack(path: $router.path){
            TabView (selection: $selectedTab) {
                
//                VerbModelSelectionWrapper(selectedCount: $selectedCount, selectedModelString: $selectedModelString )
//                    .tabItem{
//                        Image(systemName: "pencil.circle.fill")
//                        Text("Verb Model Selection")
//                    }.tag(0)
                
                
                if (selectedCount>0 ){  //I should check verb count, not model count here
                    VerbSeeWrapper()
                        .tabItem{
                            Image(systemName: "pencil.circle.fill")
                            Text("See")
                        }.tag(1)
                    
                    VerbLearnWrapper()
                        .tabItem{
                            Image(systemName: "person.text.rectangle.fill")
                            Text("Learn")
                        }.tag(2)
                    
                    VerbTestWrapper()
                        .tabItem{
                            Image(systemName: "pencil.circle.fill")
                            Text("Test")
                        }.tag(3)

//                    VerbFindWrapper(languageViewModel: languageViewModel)
//                        .tabItem{
//                            Image(systemName: "person.fill")
//                            Text("Find")
//                        }.tag(4)
//                    
//                    //            if languageViewModel.getStudentLevel().getLessonLevel() == ( 2 | 4 | 5)
//                    
//                    OddJobsView(languageViewModel: languageViewModel)
//                        .tabItem{
//                            Image(systemName: "cube.fill")
//                            Text("Verb Cubes")
//                        }.tag(5)
                }
                    
                
            }
            
            
        }.accentColor(.green)
           
            .onAppear{
                selectedCount = languageViewModel.getSelectedVerbModelList().count
                if languageViewModel.getSelectedNewVerbModelType() != .undefined && languageViewModel.getSelectedVerbModelList().count > 0 {
                    selectedModelString = languageViewModel.getSelectedVerbModelList()[0].modelVerb
                } else {
                    selectedModelString = "No model selected"
                }
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
                //                UINavigationController.setNeedsUpdateOfSupportedInterfaceOrientations()
            }
    }
}

