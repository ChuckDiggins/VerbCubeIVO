//
//  VerbCubeDispatcher.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//  bruñir

import SwiftUI

struct UserSelectionWrapper: View {
//    @EnvironmentObject var languageViewModel: LanguageViewModel
    
    var body: some View {
        VStack{
            Text("User Settings").font(.largeTitle)
                .foregroundColor(.yellow)
            HStack{
                NavigationLink(
                    destination: TenseSelectionView(),
                    label: {
                        Text("Tenses")
                    })
                .frame(width: 100, height: 50)
                .padding(.leading, 10)
                .background(Color.orange)
                .cornerRadius(10)
                NavigationLink(
                    destination: LanguageView(),
                    label: {
                        Text("Language")
                    })
                .frame(width: 100, height: 50)
                .padding(.leading, 10)
                .background(Color.orange)
                .cornerRadius(10)
            }
            Spacer()
            Text("To enter program, click on circle below").font(.caption)
                .foregroundColor(.yellow)
            Spacer()
        }.foregroundColor(.black)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GeneralCubeWrapper: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    var body: some View {
        VStack{
            Text("Verb Cube")
            NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Person))){
                Text("VerbCube")
            }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.yellow)
                .cornerRadius(10)
            VStack{
                Text("Quiz Cube")
                HStack{
                    NavigationLink(destination: QuizCubeOptionsView2()){
                        Text("Options")
                    }.frame(width: 100, height: 50)
                        .padding(.leading, 10)
                        .background(Color.green)
                        .cornerRadius(10)
                    NavigationLink(destination: QuizCubeView2(languageViewModel: languageViewModel, qchc: QuizCubeHandlerClass(languageViewModel: languageViewModel), useCellAlert: languageViewModel.useAlertMode )){
                        Text("QuizCube")
                    }.frame(width: 100, height: 50)
                        .padding(.leading, 10)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct QuizCubeWrapper: View{
//    @EnvironmentObject var languageViewModel: LanguageViewModel
//
//    var body: some View {
//        VStack{
//            QuizCubeView2(languageViewModel: languageViewModel, qchc: QuizCubeHandlerClass(languageViewModel: languageViewModel), useCellAlert: languageViewModel.useAlertMode )
//        }.navigationViewStyle(StackNavigationViewStyle())
//    }
//}
//
//struct VerbCubeWrapper: View {
//    @EnvironmentObject var languageViewModel: LanguageViewModel
//
//    var body: some View {
//        VStack{
//            VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Person))
//        }.navigationViewStyle(StackNavigationViewStyle())
//    }
//}

struct CollectionsWrapper: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    var body: some View {
        VStack{
            Text("Choose from your word collections to use with Verb Cube and Quiz Cube")
            NavigationLink(destination: WordCollectionScreen(languageViewModel: languageViewModel)){
                Text("Word collections")
            }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.orange)
                .cornerRadius(10)
                .padding(10)
            Text("Customize verb list top focus on your preferred verbs")
            NavigationLink(destination: VerbSelectionViewLazy(languageEngine: languageViewModel.getLanguageEngine())){
                Text("Verb selection view")
            }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.orange)
                .cornerRadius(10)
            Text("Create lists of similar verbs")
            NavigationLink(destination: EmptyView()){
                Text("Verb pattern selection")
            }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.orange)
                .cornerRadius(10)
            Spacer()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}


struct ExerciseWrapper: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    
    var body: some View {
        VStack{
            Text("Show how to conjugate any active verb")
            NavigationLink(destination: VerbMorphView()){
                                Text("Verb Morph View")
                            }.frame(width: 200, height: 50)
                            .padding(.leading, 10)
                            .background(Color.orange)
                            .cornerRadius(10)
            Spacer()
            Text("Analyze any verb or verb phrase")
            NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel)){
                                Text("Analyze User Verb")
                            }.frame(width: 200, height: 50)
                            .padding(.leading, 10)
                            .background(Color.orange)
                            .cornerRadius(10)
            Text("Verbs of a Feather")
            NavigationLink(destination: VerbsOfAFeather(languageViewModel: languageViewModel)){
                                Text("Verbs of a Feather")
                            }.frame(width: 200, height: 50)
                            .padding(.leading, 10)
                            .background(Color.orange)
                            .cornerRadius(10)
            Spacer()
            VStack{
                Text("What is an Active verb?")
                HStack{
                    Text("Every verb in dictionary is active.  You can select active verbs by going to collections" )
                    ZStack{
                        Circle()
                        .fill(.purple)
                        .frame(width: 20, height: 20)
                        Text(Image(systemSymbol: .tray) )
                            .foregroundColor(.white)
                    }
                    
                }
            }
            Spacer()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

