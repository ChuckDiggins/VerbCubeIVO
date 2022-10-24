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

    @State var selectedTab: Int = 0
    @State var currentLanguage = LanguageType.Spanish
    
    var body: some  View{
        //        NavigationView{
        TabView (selection: $selectedTab) {
            
            ModelVerbChartView(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "eye.fill")
                    Text("Home")
                }.tag(0)
            
            VerbSeeWrapper(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "pencil.circle.fill")
                    Text("See")
                }.tag(1)
            
            VerbLearnWrapper(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "person.text.rectangle.fill")
                    Text("Learn")
                }.tag(2)
            
            VerbTestWrapper(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "pencil.circle.fill")
                    Text("Test")
                }.tag(3)
            
            VerbFindWrapper(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "person.fill")
                    Text("Find")
                }.tag(4)
            
            if languageViewModel.getStudentLevel().getLessonLevel() == ( 2 | 4 | 5)
            {
            OddJobsView(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "cube.fill")
                    Text("Verb Cubes")
                }.tag(5)
            
            }
            
            
        }.accentColor(.green)
            .navigationBarTitle("Verbs of a Feather")
            .toolbar{
                ItemsToolbar(languageViewModel: languageViewModel)
            }
            .onAppear{
//                languageViewModel.loadModelVerbEntitiesWithModelVerbs()
//                testCoreData()
                //                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
                //                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                //                        UINavigationController.attemptRotationToDeviceOrientation()
                
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
    }
}

struct HomePickerView2: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Binding var selectedTab : Int
    @State var currentLanguageStr = ""
    var frameWidth = CGFloat(150)
    var frameHeight = CGFloat(300)
    @State var studentLevelString = ""
    @State var studentLevel = StudentLevel.level1001
    @State var selection = StudentLevel.level1001
    @State var learningLevel = 1
    
    var body: some View {
        
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            //            Image("Feather")
            //                .resizable()
            //                .scaledToFit()
            //                .ignoresSafeArea(.all)
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
                .opacity(0.5)
            
            Form {
                
                NavigationLink(destination:showGeneralVerbsView(languageViewModel: languageViewModel, studentLevel: .level1001, selection: selection)){
                    Text("Show General Verbs")
                } .modifier(NavLinkModifier())
                
                NavigationLink(destination: showModelVerbsView(languageViewModel: languageViewModel, studentLevel: .level1001, selection: selection)){
                    Text("Show Model Verbs")
                } .modifier(NavLinkModifier())
                
                NavigationLink(destination: TeachMeAModelVerb(languageViewModel: languageViewModel)){
                    Text("Teach me a model verb")
                } .modifier(NavLinkModifier())
                
            }
            .onAppear{
                studentLevel = languageViewModel.getStudentLevel()
                learningLevel = studentLevel.getLessonLevel()
                selection = studentLevel
                //                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
                //                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                //                        UINavigationController.attemptRotationToDeviceOrientation()
                //
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
            
            
            
            
        }.foregroundColor(Color("BethanyGreenText"))
        
    }
    
    @ViewBuilder
    func LessonView()-> some View {
        VStack{
            
            Text(selection.getEnumString())
                .animation(.easeInOut(duration: 1))
        }
    }
    
    func getStudentLevels()->[StudentLevel]{
        return getStudentLevelsAt(level: learningLevel)
    }
}




struct HomePickerView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Binding var selectedTab : Int
    @State var currentLanguageStr = ""
    var frameWidth = CGFloat(150)
    var frameHeight = CGFloat(300)
    @State var studentLevelString = ""
    @State var studentLevel = StudentLevel.level1001
    @State var selection = StudentLevel.level1001
    @State var learningLevel = 1
    
    var body: some View {
        
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            //            Image("Feather")
            //                .resizable()
            //                .scaledToFit()
            //                .ignoresSafeArea(.all)
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
                .opacity(0.5)
            
            Form {
                Section {
                    VStack{
                        Text("Active Lesson:")
                            .font(.title2)
                        Text(selection.getEnumString())
                        
                    }
                    VStack{
                        Text("Levels")
                        Picker("", selection: $learningLevel){
                            ForEach(0..<7, id:\.self){level in
                                Text("\(level)").background(.green)
                            }
                        }.pickerStyle(.segmented)
                    }
                    .padding()
                    
                }
                
                
                List{
                    Section(
                        header: Text("Choose a lesson")) {
                            ForEach(getStudentLevels(), id:\.self){ sl in
                                if sl.getLessonLevel() < 4 || sl.getLessonLevel() == 6 {
                                    showGeneralVerbsView(languageViewModel: languageViewModel, studentLevel: sl, selection: selection)
                                }
                                else if sl.getLessonLevel() == 4 {
                                   showPatternVerbsView(languageViewModel: languageViewModel, studentLevel: sl, selection: selection)
                                }
                                else if sl.getLessonLevel() == 5 {
                                   showModelVerbsView(languageViewModel: languageViewModel, studentLevel: sl, selection: selection)
                                }
                            }
                        }
                }
            }
            .onAppear{
                studentLevel = languageViewModel.getStudentLevel()
                learningLevel = studentLevel.getLessonLevel()
                selection = studentLevel
                //                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
                //                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                //                        UINavigationController.attemptRotationToDeviceOrientation()
                //
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
             
            
        }.foregroundColor(Color("BethanyGreenText"))
        
    }
    
    @ViewBuilder
    func LessonView()-> some View {
        VStack{
            
            Text(selection.getEnumString())
                .animation(.easeInOut(duration: 1))
        }
    }
    
    func getStudentLevels()->[StudentLevel]{
        return getStudentLevelsAt(level: learningLevel)
    }
}


