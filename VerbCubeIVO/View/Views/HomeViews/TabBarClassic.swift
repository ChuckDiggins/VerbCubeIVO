//
//  TabBarClassic.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/3/22.
//

import SwiftUI
import JumpLinguaHelpers

struct ScrollViewVC: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var selectedTab: Int = 0
    @State var currentLanguage = LanguageType.Spanish
    @State var currentLanguageStr = "Agnostic"
    
    var body: some  View{
//        Image("FeatherInverted")
//            .resizable()
//            .scaledToFit()
//            .ignoresSafeArea(.all)
        
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            VStack{
//                Button{
//                    switch languageViewModel.getCurrentLanguage() {
//                    case .Spanish:
//                        languageViewModel.setLanguage(language: .French)
//                        currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
//                    case .French:
//                        languageViewModel.setLanguage(language: .English)
//                        currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
//                    case .English:
//                        languageViewModel.setLanguage(language: .Spanish)
//                        currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
//                    default:
//                        languageViewModel.setLanguage(language: .Spanish)
//                        currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
//                    }
//                } label: {
//                    Text("Active language: \(currentLanguageStr)")
//                        .frame(minWidth: 0, maxWidth: 400)
//                        .frame(height: 50)
//                        .background(.purple)
//                        .foregroundColor(.yellow)
//                        .cornerRadius(10)
//                        .padding(20)
//                }
                ScrollView{
                    NavigationLink(destination: PreferencesView(languageViewModel: languageViewModel)){
                        Text("Preferences")
                    }.modifier(NavLinkModifier())
                        .background(.orange)
                    NavigationLink(destination: ModelView(languageViewModel: languageViewModel)){
                        Text("Model-Based Verbs")
                    }.modifier(NavLinkModifier())
                        .background(.orange)
                    NavigationLink(destination: PatternView(languageViewModel: languageViewModel)){
                        Text("Pattern-Based Verbs")
                    }.modifier(NavLinkModifier())
                        .background(.yellow)
                    NavigationLink(destination: GeneralVerbView(languageViewModel: languageViewModel)){
                        Text("Verbs in General")
                    }.modifier(NavLinkModifier())
                        .background(.green)
                    NavigationLink(destination: OddJobsView(languageViewModel: languageViewModel)){
                        Text("Odds and Ends")
                    }.modifier(NavLinkModifier())
                        .background(.black)
                    
                    Button{
                        exit(1)
                    } label: {
                        HStack{
                            Text("Exit")
                            Text("👋🏼")
                        }
                    }
                    .padding(.leading, 10)
                    .padding(30)
                    .frame(width: 300, height: 50)
                    .background(.red)
                    .border(Color.white, width: 2)
                    .cornerRadius(25)
                    .foregroundColor(.black)
                    .tint(.pink)
                }
            }
        }.onAppear{
            currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
        }
    }
    
}
struct TabBarClassicVC: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var selectedTab: Int = 0
    @State var currentLanguage = LanguageType.Spanish
    
    var body: some  View{
        NavigationView{
        TabView (selection: $selectedTab) {
//            HomeView(languageViewModel: languageViewModel, selectedTab: $selectedTab)
//                .tabItem{
//                    Image(systemName: "house.fill")
//                    Text("Home")
//                }.tag(0)
//
            ScrollViewVC(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(0)
//            PreferencesView(languageViewModel: languageViewModel)
//                .tabItem{
//                    Image(systemName: "house.fill")
//                    Text("Pref")
//                }.tag(0)
            ModelView(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "graduationcap")
                    Text("MBVC")
                }.tag(1)
            PatternView(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "pencil.circle.fill")
                    Text("PBVC")
                }.tag(2)

            GeneralVerbView(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "archivebox.fill")
                    Text("GNRL")
                }.tag(3)
            
            OddJobsView(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "folder.badge.gearshape")
                    Text("Odd Jobs")
                }.tag(4)

            
        }
        .accentColor(.green)
        }.navigationBarTitle("Verbs of a Feather")
//            .navigationBarItems(leading:
//                                    Button{
//                exit(1)
//            } label: {
//                Image(systemName:"arrow.backward.circle").foregroundColor(.red)
//            }            )
//                                
//                                trailing:
//                                    HStack{
//                NavigationLink(destination: LanguageView(languageViewModel: languageViewModel, currentLanguage: $currentLanguage)){
//                    Image(systemName:"flag.fill").foregroundColor(.blue)
//                }
//                NavigationLink(destination: TenseSelectionView(languageViewModel: languageViewModel)){
//                    Image(systemName:"clock.arrow.circlepath").foregroundColor(.blue)
//                }
//            }

        
    }
}


struct HomeView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Binding var selectedTab : Int
    @State var currentLanguageStr = ""
    
    var body: some View {
        
            ZStack{
                Image("FeatherInverted")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea(.all)
                
                VStack {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    
                    VStack{
                        Button{
                            if languageViewModel.getCurrentLanguage() == .Spanish {
                                languageViewModel.setLanguage(language: .French)
                                currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
                            } else {
                                languageViewModel.setLanguage(language: .Spanish)
                                currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
                            }
                                
                        } label: {
                            Text("Active language: \(currentLanguageStr)")
                                .frame(minWidth: 0, maxWidth: 400)
                                .frame(height: 50)
                                .background(.purple)
                                .foregroundColor(.yellow)
                                .cornerRadius(10)
                                .padding(20)
                        }
                        
                        Spacer()
                      
                        Text("Click tabs below to go to learn, take quizzes and access collections")
                            .frame(minWidth: 0, maxWidth: 400)
                            .frame(height: 75)
                            .background(.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(20)
                        
                        Spacer()
                    }
                    
//
//
                }.onAppear{
                    currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
                }
//
//            }
       
        }
    }
}

struct ModelView: View{
    @ObservedObject var languageViewModel: LanguageViewModel

    var body: some View {
        ZStack{
            Color.yellow
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)

            VStack {
                Text("Model-Based Verbs")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                Spacer()
                NavigationLink(destination: ModelLearnWrapper(languageViewModel: languageViewModel)){
                    Text("Model-Based Learning")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.headline)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                }
                
                
//                NavigationLink(destination: FeatherVerbQuizMorphView(languageViewModel: languageViewModel)){
//                    Text("Feather Quiz Morph")
//                }.frame(minWidth: 0, maxWidth: 300)
//                    .padding()
//                    .foregroundColor(.white)
//                    .padding(.horizontal)
//                    .font(.headline)
//                    .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
//                    .cornerRadius(10)
                
                NavigationLink(destination: ModelQuizWrapper(languageViewModel: languageViewModel)){
                    Text("Model-Based Quizzes")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.headline)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                }
                Spacer()

            }
        }
    }
}

struct PatternView: View{
    @ObservedObject var languageViewModel: LanguageViewModel

    var body: some View {
        ZStack{
            Color.green
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)

            VStack {
                Text("Pattern-Based Verbs")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                Spacer()
                NavigationLink(destination: PatternLearnWrapper(languageViewModel: languageViewModel)){
                    Text("Pattern-Based Learning")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.headline)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: PatternQuizWrapper(languageViewModel: languageViewModel)){
                    Text("Pattern-Based Quizzes")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.headline)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                }
                
                Spacer()

            }
        }
    }
}

struct GeneralVerbView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var backgroundColor = Color.blue
    var body: some View {
        ZStack{
            backgroundColor
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            
            VStack{
                Text("Verbs in General")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                Spacer()
                NavigationLink(destination: GeneralVerbLearnWrapper(languageViewModel: languageViewModel)){
                    Text("General Verb Learning")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.headline)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                }
                NavigationLink(destination: GeneralVerbQuizWrapper(languageViewModel: languageViewModel)){
                    Text("General Verb Quizzes")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.headline)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                }
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(.white)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

