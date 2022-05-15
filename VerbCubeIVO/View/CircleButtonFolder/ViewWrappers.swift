//
//  VerbCubeDispatcher.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//  bruñir

import SwiftUI

struct ModelPatternQuizWrapper: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [
                Color(.systemYellow),
                Color(.systemPink),
                Color(.systemPurple),
            ]),
                           startPoint: .top,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack{
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern)){
                    Text("Models for Pattern")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsBelongingToModel)){
                    Text("Verbs in Model")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelForGivenVerb)){
                    Text("Model for Given Verb")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsThatHaveGivenPattern)){
                    Text("Verbs with Given Pattern")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsThatHaveSameModelAsVerb)){
                    Text("Verbs with Verb's Model")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsWithSamePatternAsVerb)){
                    Text("Verbs with Verb's Pattern")
                }.modifier(NavLinkModifier())
                
            }
            
        }
        .navigationTitle("Verbs, Models & Patterns")
        
        
        Spacer()
    }
}

//struct OptionsWrapper: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//    var body: some View {
//        NavigationLink(destination: LanguageView(languageViewModel: languageViewModel)){
//            Text("Language")
//        }.modifier(NavLinkModifier())
//        
//        NavigationLink(destination: TenseSelectionView(languageViewModel: languageViewModel)){
//            Text("Tenses")
//        }.modifier(NavLinkModifier())
//    }
//}

struct OddJobsWrapper: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var body: some View {
        VStack{
            Text("Right/Wrong")
            NavigationLink(destination: RightWrongVerbView(languageViewModel: languageViewModel)){
                Text("Conjugate verb right and wrong")
            }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.orange)
                .cornerRadius(10)
        }
        Spacer()
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
    }
}


struct NavLinkModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .padding(.leading, 10)
            .padding(10)
            .frame(width: 300, height: 50)
            .background(.black)
            .border(Color.white, width: 2)
            .cornerRadius(25)
            .foregroundColor(.yellow)
        //                    .buttonStyle(.bordered)
            .tint(.yellow)
        
        
    }
    
}

struct GeneralCubeWrapper: View {
    @ObservedObject  var languageViewModel: LanguageViewModel
    var body: some View {
        VStack{
            Text("Verb Cube")
            NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Person))){
                Text("VerbCube")
            }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.yellow)
                .cornerRadius(10)
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct QuizCubeWrapper: View{
    @ObservedObject var languageViewModel: LanguageViewModel
    
    var body: some View {
        VStack{
            Text("Quiz Cube")
            HStack{
                NavigationLink(destination: QuizCubeOptionsView2(languageViewModel: languageViewModel)){
                    Text("Quiz Cube")
                }.frame(width: 100, height: 50)
                    .padding(.leading, 10)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
}

struct QuizWrapper: View{
    @ObservedObject var languageViewModel: LanguageViewModel
    
    var body: some View {
        VStack{
            //            QuizVerbView(languageViewModel: languageViewModel)
            //            FocusView(languageViewModel: languageViewModel)
            
            Text("Fill-in the Blanks")
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
            NavigationLink(destination: VerbSelectionViewLazy(languageEngine: languageViewModel.getLanguageEngine(), languageViewModel: languageViewModel)){
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
    @ObservedObject var languageViewModel: LanguageViewModel
    
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
            
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}

