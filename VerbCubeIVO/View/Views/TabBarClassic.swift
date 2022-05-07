//
//  TabBarClassic.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/3/22.
//

import SwiftUI
import JumpLinguaHelpers

struct TabBarClassic: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var selectedTab: Int = 0
    
    
    //    var body: some  View {
    //        TabView{
    //            ForEach(icons, id: \.self){ icon in
    //                Image(systemName: icon)
    //                    .resizable()
    //                    .scaledToFit()
    //                    .padding(30)
    //            }
    //        }
    //        .background(
    //            RadialGradient(gradient: Gradient(colors: [Color.red, Color.blue]), center: .center, startRadius: 5, endRadius: 250 ))
    //        .frame(height: 300)
    //        .tabViewStyle(PageTabViewStyle())
    //    }
    var body: some  View{
        
        TabView (selection: $selectedTab) {
            HomeView(languageViewModel: languageViewModel, selectedTab: $selectedTab)
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(0)
            LearningView(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "graduationcap")
                    Text("Learn")
                }.tag(1)
            QuizzesView(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "pencil.circle.fill")
                    Text("Quiz")
                }.tag(2)
            
            CollectionsView(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "archivebox.fill")
                    Text("Collections")
                }.tag(3)
            
            OddJobsView(languageViewModel: languageViewModel)
                .tabItem{
                    Image(systemName: "folder.badge.gearshape")
                    Text("Odd Jobs")
                }.tag(4)
            
            
        }
        .accentColor(.green)
        
    }
}


struct HomeView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Binding var selectedTab : Int
    @State var currentLanguage = LanguageType.Spanish
    
    var body: some View {
        NavigationView{
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
                        Text("Active language: \(currentLanguage.rawValue)")
                            .frame(minWidth: 0, maxWidth: 400)
                            .frame(height: 50)
                            .background(.purple)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                            .padding(20)
                        
                        HStack{
                            Text("Click ")
                            Image(systemName:"flag.fill").foregroundColor(.blue)
                            Image(systemName:"clock.arrow.circlepath").foregroundColor(.blue)
                            Text("above to change language and tenses")
                        }
                        .frame(minWidth: 0, maxWidth: 400)
                        .frame(height: 50)
                        .background(.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(5)
                        
                        HStack{
                            Text("Click ")
                            Image(systemName:"arrow.backward.circle").foregroundColor(.red)
                            Text("to exit")
                        }
                        .frame(minWidth: 0, maxWidth: 400)
                        .frame(height: 50)
                        .background(.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(20)
                        
                        Text("Click tabs below to go to learn, take quizzes and access collections")
                            .frame(minWidth: 0, maxWidth: 400)
                            .frame(height: 75)
                            .background(.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(20)
                        
                        Spacer()
                    }.navigationBarTitle("Verbs of a Feather")
                        .navigationBarItems(leading:
                                                Button{
                            exit(1)
                        } label: {
                            Image(systemName:"arrow.backward.circle").foregroundColor(.red)
                        },
                                            
                                            trailing:
                                                HStack{
                            NavigationLink(destination: LanguageView(languageViewModel: languageViewModel, currentLanguage: $currentLanguage)){
                                Image(systemName:"flag.fill").foregroundColor(.blue)
                            }
                            NavigationLink(destination: TenseSelectionView(languageViewModel: languageViewModel)){
                                Image(systemName:"clock.arrow.circlepath").foregroundColor(.blue)
                            }
                        } )
                    
                }
            }
        }
    }
}

struct FeatherView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    var body: some View {
        ZStack{
            Color.yellow
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Welcome to Feathers!")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                
                NavigationLink(destination: VerbsOfAFeather(languageViewModel: languageViewModel)){
                    Text("Verbs of a Feather")
                }.frame(width: 150, height: 50)
                    .padding(.leading, 10)
                    .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .cornerRadius(10)
                    .foregroundColor(.yellow)
                NavigationLink(destination: FeatherVerbMorphView(languageViewModel: languageViewModel)){
                    Text("Feather Morph")
                }.frame(width: 150, height: 50)
                    .padding(.leading, 10)
                    .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .cornerRadius(10)
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct OddJobsView: View {
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
                Text("Welcome to Odd Jobs!")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                
                NavigationLink(destination: OddJobsWrapper(languageViewModel: languageViewModel)){
                    Text("Odd Jobs")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.headline)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                }
            }
        }
    }
}
struct CollectionsView: View {
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
                Spacer()
                Text("Welcome to Collections!")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                
                NavigationLink(destination: WordCollectionScreen(languageViewModel: languageViewModel)){
                    Text("Word collections")
                }.frame(minWidth: 0, maxWidth: 300)
                    .padding()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .font(.headline)
                    .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .cornerRadius(10)
                
                
                
                NavigationLink(destination: VerbSelectionViewLazy(languageEngine: languageViewModel.getLanguageEngine())){
                    Text("Verb selection view")
                }.frame(minWidth: 0, maxWidth: 300)
                    .padding()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .font(.headline)
                    .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .cornerRadius(10)
                
                
                NavigationLink(destination: EmptyView()){
                    Text("Verb pattern selection")
                }.frame(minWidth: 0, maxWidth: 300)
                    .padding()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .font(.headline)
                    .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .cornerRadius(10)
                Spacer()
            }
            .foregroundColor(.white)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
}

struct QuizzesView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    var body: some View {
        ZStack{
            Color.orange
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Welcome to the Quizzes!")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                
                VStack{
                    Text("Quiz Cube")
                    NavigationLink(destination: QuizCubeOptionsView2(languageViewModel: languageViewModel)){
                        Text("Go to QuizCube")
                            .frame(minWidth: 0, maxWidth: 300)
                            .padding()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .font(.headline)
                            .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(10)
                        
                    }
                    
                    NavigationLink(destination: ModelPatternQuizWrapper(languageViewModel: languageViewModel)){
                        Text("Go to Models v Patterns")
                            .frame(minWidth: 0, maxWidth: 300)
                            .padding()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .font(.headline)
                            .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: QuizWrapper(languageViewModel: languageViewModel)){
                        Text("Go to Verb Practice")
                            .frame(minWidth: 0, maxWidth: 300)
                            .padding()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .font(.headline)
                            .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(10)
                    }
                }
                Spacer()
            }
        }
    }
}

struct LearningView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    var body: some View {
        ZStack{
            Color.purple
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Welcome to the Learning Module!")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                
                NavigationLink(destination: FeatherView(languageViewModel: languageViewModel)){
                    Text("Go to Feathers")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.headline)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: ExerciseWrapper(languageViewModel: languageViewModel)){
                    Text("Go to Exercises")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.headline)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: GeneralCubeWrapper(languageViewModel: languageViewModel)){
                    Text("Verb Cube")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.headline)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                }
            }
            Spacer()
        }
        
    }
}


//struct TabBarClassic_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBarClassic()
//    }
//}


