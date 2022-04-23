//
//  VerbCubeDispatcher.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//  bruñir

import SwiftUI

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
                    NavigationLink(destination: QuizCubeOptionsView2(languageViewModel: languageViewModel)){
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

struct QuizWrapper: View{
    @EnvironmentObject var languageViewModel: LanguageViewModel

    var body: some View {
        VStack{
//            QuizVerbView(languageViewModel: languageViewModel)
//            FocusView(languageViewModel: languageViewModel)
            NavigationLink(destination: QuizVerbView(languageViewModel: languageViewModel)){
                Text("Quiz Verb 6 Persons")
            }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.orange)
                .cornerRadius(10)
                .padding(10)
            
            NavigationLink(destination: QuizVerbSingleView(languageViewModel: languageViewModel)){
                Text("Quiz Verb - Single Person")
            }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.orange)
                .cornerRadius(10)
                .padding(10)
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }


}

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
            VStack{
                Text("Show how to conjugate any active verb")
                NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                    Text("Verb Morph View")
                }.frame(width: 200, height: 50)
                    .padding(.leading, 10)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            Spacer()
            HStack(){
                VStack{
//                    Text("Verbs of a Feather")
                    NavigationLink(destination: VerbsOfAFeather(languageViewModel: languageViewModel)){
                        Text("Verbs of a Feather")
                    }.frame(width: 150, height: 50)
                        .padding(.leading, 10)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .padding(20)
                VStack{
//                    Text("Conjugate Feather Verbs")
                    NavigationLink(destination: FeatherVerbMorphView(languageViewModel: languageViewModel)){
                        Text("Feather Morph")
                    }.frame(width: 150, height: 50)
                        .padding(.leading, 10)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            .padding(20)
            VStack{
                Text("Analyze any verb or verb phrase")
                NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel)){
                    Text("Analyze User Verb")
                }.frame(width: 200, height: 50)
                    .padding(.leading, 10)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(20)
            VStack{
                Text("Unconjugate")
                NavigationLink(destination: UnconjugateView(languageViewModel: languageViewModel)){
                    Text("Find the verbs")
                }.frame(width: 200, height: 50)
                    .padding(.leading, 10)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            Spacer()
        }.navigationViewStyle(StackNavigationViewStyle())
            
    }
}

