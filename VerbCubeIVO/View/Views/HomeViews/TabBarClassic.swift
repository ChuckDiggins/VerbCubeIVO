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
            HomePickerView(languageViewModel: languageViewModel, selectedTab: $selectedTab)
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
                //                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
                //                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                //                        UINavigationController.attemptRotationToDeviceOrientation()
                
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
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




//struct ModelView: View{
//    @ObservedObject var languageViewModel: LanguageViewModel
//
//    var body: some View {
//        ZStack{
//            Color.yellow
//            Image("FeatherInverted")
//                .resizable()
//                .scaledToFit()
//                .ignoresSafeArea(.all)
//
//            VStack {
//                Text("Model-Based Verbs")
//                    .font(.largeTitle)
//                    .foregroundColor(.black)
//                DisclosureGroupModel()
//                Spacer()
//                NavigationLink(destination: ModelLearnWrapper(languageViewModel: languageViewModel)){
//                    Text("Model-Based Learning")
//                        .frame(minWidth: 0, maxWidth: 300)
//                        .padding()
//                        .foregroundColor(.white)
//                        .padding(.horizontal)
//                        .font(.headline)
//                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
//                        .cornerRadius(10)
//                }
//
//
////                NavigationLink(destination: FeatherVerbQuizMorphView(languageViewModel: languageViewModel)){
////                    Text("Feather Quiz Morph")
////                }.frame(minWidth: 0, maxWidth: 300)
////                    .padding()
////                    .foregroundColor(.white)
////                    .padding(.horizontal)
////                    .font(.headline)
////                    .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
////                    .cornerRadius(10)
//
//                NavigationLink(destination: ModelQuizWrapper(languageViewModel: languageViewModel)){
//                    Text("Model-Based Quizzes")
//                        .frame(minWidth: 0, maxWidth: 300)
//                        .padding()
//                        .foregroundColor(.white)
//                        .padding(.horizontal)
//                        .font(.headline)
//                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
//                        .cornerRadius(10)
//                }
//                Spacer()
//
//            }
//        }
//    }
//}
//
//struct PatternView: View{
//    @ObservedObject var languageViewModel: LanguageViewModel
//
//    var body: some View {
//        ZStack{
//            Color.green
//            Image("FeatherInverted")
//                .resizable()
//                .scaledToFit()
//                .ignoresSafeArea(.all)
//
//            VStack {
//                Text("Pattern-Based Verbs")
//                    .font(.largeTitle)
//                    .foregroundColor(.black)
//                Spacer()
//                NavigationLink(destination: PatternLearnWrapper(languageViewModel: languageViewModel)){
//                    Text("Pattern-Based Learning")
//                        .frame(minWidth: 0, maxWidth: 300)
//                        .padding()
//                        .foregroundColor(.white)
//                        .padding(.horizontal)
//                        .font(.headline)
//                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
//                        .cornerRadius(10)
//                }
//
//                NavigationLink(destination: PatternQuizWrapper(languageViewModel: languageViewModel)){
//                    Text("Pattern-Based Quizzes")
//                        .frame(minWidth: 0, maxWidth: 300)
//                        .padding()
//                        .foregroundColor(.white)
//                        .padding(.horizontal)
//                        .font(.headline)
//                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
//                        .cornerRadius(10)
//                }
//
//                Spacer()
//
//            }
//        }
//    }
//}
//
//struct GeneralVerbView: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//    var backgroundColor = Color.blue
//    var body: some View {
//        ZStack{
//            backgroundColor
//            Image("FeatherInverted")
//                .resizable()
//                .scaledToFit()
//                .ignoresSafeArea(.all)
//
//            VStack{
//                Text("Verbs in General")
//                    .font(.largeTitle)
//                    .foregroundColor(.black)
//
//                Spacer()
//                NavigationLink(destination: GeneralVerbLearnWrapper(languageViewModel: languageViewModel)){
//                    Text("General Verb Learning")
//                        .frame(minWidth: 0, maxWidth: 300)
//                        .padding()
//                        .foregroundColor(.white)
//                        .padding(.horizontal)
//                        .font(.headline)
//                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
//                        .cornerRadius(10)
//                }
//                NavigationLink(destination: GeneralVerbQuizWrapper(languageViewModel: languageViewModel)){
//                    Text("General Verb Quizzes")
//                        .frame(minWidth: 0, maxWidth: 300)
//                        .padding()
//                        .foregroundColor(.white)
//                        .padding(.horizontal)
//                        .font(.headline)
//                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
//                        .cornerRadius(10)
//                }
//                Spacer()
//            }
//            Spacer()
//        }
//        .foregroundColor(.white)
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}

//struct ScrollViewVC: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//    @State var selectedTab: Int = 0
//    @State var currentLanguage = LanguageType.Spanish
//    @State var currentLanguageStr = "Agnostic"
//    @State var animationAmount = 5.0
//
//    var body: some  View{
//        //        Image("FeatherInverted")
//        //            .resizable()
//        //            .scaledToFit()
//        //            .ignoresSafeArea(.all)
//
//
//        VStack {
//            VStack{
//                ScrollView{
//                    DisclosureGroupMain()
//                    NavigationLink(destination: TeachMeARegularVerb(languageViewModel: languageViewModel)){
//                        HStack{
//                            Text("Teach me a regular verb")
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.yellow)
//                        }
//                    }.modifier(ModelTensePersonButtonModifier())
//                    NavigationLink(destination: TeachMeAModelVerb(languageViewModel: languageViewModel)){
//                        HStack{
//                            Text("Teach me a model verb")
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.yellow)
//                        }
//                    }.modifier(ModelTensePersonButtonModifier())
//                    NavigationLink(destination: TeachMeAPatternVerb(languageViewModel: languageViewModel)){
//                        HStack{
//                            Text("Teach me a pattern verb")
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.yellow)
//                        }
//                    }.modifier(ModelTensePersonButtonModifier())
//                    NavigationLink(destination: ShowMeModelQuizzes(languageViewModel: languageViewModel)){
//                        HStack{
//                            Text("Show me model quizzes")
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.yellow)
//                        }
//                    }.modifier(ModelTensePersonButtonModifier())
//                    NavigationLink(destination: FindMyVerb(languageViewModel: languageViewModel)){
//                        HStack{
//                            Text("Find my verb")
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.yellow)
//                        }
//                    }.modifier(ModelTensePersonButtonModifier())
//                    NavigationLink(destination: ShowMeVerbsPatternsAndModels(languageViewModel: languageViewModel)){
//                        HStack{
//                            Text("Verbs, patterns and models")
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.yellow)
//                        }
//                    }.modifier(ModelTensePersonButtonModifier())
//                    NavigationLink(destination: OddJobsView(languageViewModel: languageViewModel)){
//                        HStack{
//                            Text("Odds and Ends")
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.yellow)
//                        }
//                    }.modifier(ModelTensePersonButtonModifier())
//                        .background(.black)
//
//                }.navigationTitle("Home")
//                    .toolbar{
//                        ItemsToolbar(languageViewModel: languageViewModel)
//                    }
//
//            }
//        }.onAppear{
//            currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
//        }
//    }
//
//}
////
