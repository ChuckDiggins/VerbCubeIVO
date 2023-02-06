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
    @State var startPos : CGPoint = .zero
    @State var isSwiping = true
    @State var color = Color.red.opacity(0.4)
    @State var direction = ""
    @State var maxTab = 3
    
    var body: some  View{
        NavigationStack(path: $router.path){
            TabView (selection: $selectedTab) {
                ModelSelectionWrapper()
                    .tabItem{
                        Image(systemName: "s.circle")
                        Text("Select")
                    }.tag(0)
                
                VerbSeeWrapper()
                    .tabItem{
                        Image(systemName: "e.circle")
                        Text("Explore")
                    }.tag(1)
                
                VerbLearnWrapper()
                    .tabItem{
                        Image(systemName: "l.circle")
                        Text("Learn")
                    }.tag(2)
                
                VerbTestWrapper()
                    .tabItem{
                        Image(systemName: "t.circle")
                        Text("Test")
                    }.tag(3)
                
            }
            .gesture(DragGesture()
                .onChanged { gesture in
                    if self.isSwiping {
                        self.startPos = gesture.location
                        self.isSwiping.toggle()
                    }
//                    print("Swiped")
                }
                .onEnded { gesture in
                    let xDist =  abs(gesture.location.x - self.startPos.x)
                    let yDist =  abs(gesture.location.y - self.startPos.y)
                   
                    if self.startPos.x > gesture.location.x + 10 && yDist < xDist {
                        self.direction = "Left"
                        self.color = Color.yellow.opacity(0.4)
                        if selectedTab < maxTab { selectedTab += 1 }
                        else { selectedTab = maxTab }
                    }
                    else if self.startPos.x < gesture.location.x + 10 && yDist < xDist {
                        self.direction = "Right"
                        self.color = Color.purple.opacity(0.4)
                        if selectedTab > 0 { selectedTab -= 1 }
                        else { selectedTab = 0 }
                    }
                    self.isSwiping.toggle()
//                    print("gesture here")
                }
            )

            .navigationTitle(languageViewModel.isModelMode() ? "Model: \(languageViewModel.getStudyPackage().lesson)" : "Lesson: \(languageViewModel.getStudyPackage().lesson)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        NavigationLink(destination: FindMyVerbDispatcher(languageViewModel: languageViewModel ))
                        {
                        Label("Find", systemImage: "magnifyingglass")
                        }
                        NavigationLink(destination: PreferencesView(languageViewModel: languageViewModel ))
                        {
                        Label("Settings", systemImage: "gear")
                        }
                    }
                }
            
        }.accentColor(.green)
        
            .onAppear{
                selectedCount = languageViewModel.getSelectedVerbModelList().count
                print("TabBarClassic:  selectedCount = \(selectedCount)")
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

